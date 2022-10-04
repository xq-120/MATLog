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
#import <stdatomic.h>

static MATLogLevel logLevel = MATLogLevelDebug;

@implementation MATLog

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupLogger];
    });
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
    
    if (isUpload) {
        //TODO:上传服务器
    }
    DDLogLevel ddLevel = [self toDDLogLevel:level];
    DDLogFlag ddFlag = [self toDDLogFlag:flag];
    if((ddLevel & ddFlag) != 0) {
        [DDLog log:asynchronous level:ddLevel flag:ddFlag context:type file:file function:function line:line tag:nil format:format args:args];
    }
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
