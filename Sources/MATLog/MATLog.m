//
//  MATLog.m
//  MATLog
//
//  Created by 薛权 on 2022/10/2.
//

#import "MATLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "MATOSFormatter.h"
#import "MATFileFormatter.h"
#import "MATLogFileManager.h"
#import "MATLogDatabaseServer.h"
#import "MATLogModel.h"
#import "MATUploadManager.h"

static MATLogLevel logLevel = MATLogLevelDebug;

@interface MATLog ()

@property (nonatomic, strong) MATOSFormatter *logFormatter;
@property (nonatomic, strong) MATUploadManager *uploadManager;

@end

@implementation MATLog

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupLogger];
    });
}

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[MATLog alloc] init];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploadManager = [[MATUploadManager alloc] init];
        _logFormatter = [[MATOSFormatter alloc] init];
    }
    return self;
}

+ (void)setupLogger {
#ifdef  DEBUG
    DDOSLogger *osLogger = [DDOSLogger sharedInstance];
    osLogger.logFormatter = [MATOSFormatter new];
    [DDLog addLogger:osLogger]; //不指定Level则为DDLogLevelAll
#endif
    MATLogFileManager *logFileManager = [[MATLogFileManager alloc] initWithLogsDirectory:[self defaultLogsDirectory]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.logFormatter = [MATFileFormatter new];
    [DDLog addLogger:fileLogger withLevel:DDLogLevelAll];
    
#ifdef DEBUG
    logLevel = MATLogLevelVerbose;
#else
    logLevel = MATLogLevelInfo;
#endif
}

+ (NSString *)defaultLogsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"MATLogs"];
    return logsDirectory;
}

+ (void)setLogLevel:(MATLogLevel)level {
    logLevel = level;
}

+ (MATLogLevel)logLevel {
    return logLevel;
}

+ (void)setDelegate:(id<MATLogDelegate>)delegate {
    [MATLog shared].uploadManager.delegate = delegate;
}

#pragma mark- Log

+ (void)log:(BOOL)asynchronous
   isUpload:(BOOL)isUpload
      level:(MATLogLevel)level
       flag:(MATLogFlag)flag
 moduleType:(NSInteger)type
       file:(const char *)file
   function:(nullable const char *)function
       line:(NSUInteger)line
     format:(NSString *)format
       args:(va_list)args {
    
    NSAssert(format != nil, @"format不能为空");

    DDLogLevel ddLevel = [self toDDLogLevel:level];
    DDLogFlag ddFlag = [self toDDLogFlag:flag];
    DDLogMessage *logMessage = nil;
    if((ddLevel & ddFlag) != 0) {
        logMessage = [self logMessageWithlevel:ddLevel flag:ddFlag moduleType:type file:file function:function line:line format:format args:args];
        [[DDLog sharedInstance] log:asynchronous message:logMessage];
    }
    
    if (isUpload) {
        if (logMessage == nil) {
            logMessage = [self logMessageWithlevel:ddLevel flag:ddFlag moduleType:type file:file function:function line:line format:format args:args];
        }
        MATLogModel *item = [self convertToDBItemWithLogMessage:logMessage];
        [[MATLog shared].uploadManager asyncUpload:item immediately:!asynchronous];
    }
}

+ (MATLogModel *)convertToDBItemWithLogMessage:(DDLogMessage *)logMessage {
    MATLogModel *item = [[MATLogModel alloc] init];
    item.logTimestamp = [logMessage.timestamp timeIntervalSince1970] * 1000;
    item.logContent = logMessage.message;
    item.logDetail = [[MATLog shared].logFormatter formatLogMessage:logMessage];
    return item;
}

+ (DDLogMessage *)logMessageWithlevel:(DDLogLevel)level
                                   flag:(DDLogFlag)flag
                             moduleType:(NSInteger)type
                                   file:(const char *)file
                               function:(nullable const char *)function
                                   line:(NSUInteger)line
                                 format:(NSString *)format
                                   args:(va_list)args {
    NSAssert(format != nil, @"format不能为空");
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    
    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithMessage:message
                                               level:level
                                                flag:flag
                                             context:type
                                                file:[NSString stringWithFormat:@"%s", file]
                                            function:[NSString stringWithFormat:@"%s", function]
                                                line:line
                                                 tag:nil
                                             options:(DDLogMessageOptions)0
                                           timestamp:nil];
    
    return logMessage;
}

+ (void)logErrorWithFile:(const char *)file
               function:(nullable const char *)function
                   line:(NSUInteger)line
                  format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagError;
        [self log:NO isUpload:NO level:level flag:flag moduleType:0 file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logWarningWithFile:(const char *)file
                 function:(nullable const char *)function
                     line:(NSUInteger)line
                    format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagWarning;
        [self log:YES isUpload:NO level:level flag:flag moduleType:0 file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logInfoWithFile:(const char *)file
              function:(nullable const char *)function
                  line:(NSUInteger)line
                 format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagInfo;
        [self log:YES isUpload:NO level:level flag:flag moduleType:0 file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logDebugWithFile:(const char *)file
               function:(nullable const char *)function
                   line:(NSUInteger)line
                  format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagDebug;
        [self log:YES isUpload:NO level:level flag:flag moduleType:0 file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logVerboseWithFile:(const char *)file
                 function:(nullable const char *)function
                     line:(NSUInteger)line
                    format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagVerbose;
        [self log:YES isUpload:NO level:level flag:flag moduleType:0 file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logError:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
          format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagError;
        [self log:isAsynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logWarning:(BOOL)isAsynchronous
           upload:(BOOL)isUpload
         moduleType:(NSInteger)type
               file:(const char *)file
           function:(nullable const char *)function
               line:(NSUInteger)line
            format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagWarning;
        [self log:isAsynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logInfo:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagInfo;
        [self log:isAsynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logDebug:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
          format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagDebug;
        [self log:isAsynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)logVerbose:(BOOL)isAsynchronous
           upload:(BOOL)isUpload
         moduleType:(NSInteger)type
               file:(const char *)file
           function:(nullable const char *)function
               line:(NSUInteger)line
            format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        MATLogLevel level = [self logLevel];
        MATLogFlag flag = MATLogFlagVerbose;
        [self log:isAsynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}

+ (void)log:(BOOL)asynchronous
   upload:(BOOL)isUpload
      level:(MATLogLevel)level
       flag:(MATLogFlag)flag
 moduleType:(NSInteger)type
       file:(const char *)file
   function:(nullable const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... {
    va_list ap;
    if (format) {
        va_start(ap, format);
        [self log:asynchronous isUpload:isUpload level:level flag:flag moduleType:type file:file function:function line:line format:format args:ap];
        va_end(ap);
    }
}


+ (DDLogLevel)toDDLogLevel:(MATLogLevel)level {
    DDLogLevel ddLevel = DDLogLevelOff;
    switch (level) {
        case MATLogLevelOff:
            ddLevel = DDLogLevelOff;
            break;
        case MATLogLevelError:
            ddLevel = DDLogLevelError;
            break;
        case MATLogLevelWarning:
            ddLevel = DDLogLevelWarning;
            break;
        case MATLogLevelInfo:
            ddLevel = DDLogLevelInfo;
            break;
        case MATLogLevelDebug:
            ddLevel = DDLogLevelDebug;
            break;
        case MATLogLevelVerbose:
            ddLevel = DDLogLevelVerbose;
            break;
        case MATLogLevelAll:
            ddLevel = DDLogLevelAll;
            break;
        default:
            break;
    }
    return ddLevel;
}

+ (DDLogFlag)toDDLogFlag:(MATLogFlag)flag {
    DDLogFlag ddFlag = DDLogFlagVerbose;
    switch (flag) {
        case MATLogFlagError:
            ddFlag = DDLogFlagError;
            break;
        case MATLogFlagWarning:
            ddFlag = DDLogFlagWarning;
            break;
        case MATLogFlagInfo:
            ddFlag = DDLogFlagInfo;
            break;
        case MATLogFlagDebug:
            ddFlag = DDLogFlagDebug;
            break;
        case MATLogFlagVerbose:
            ddFlag = DDLogFlagVerbose;
            break;
        default:
            break;
    }
    return ddFlag;
}

@end
