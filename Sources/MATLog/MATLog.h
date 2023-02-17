//
//  MATLog.h
//  MATLog
//
//  Created by 薛权 on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MATLogFlag) {
    MATLogFlagError,
    MATLogFlagWarning,
    MATLogFlagInfo,
    MATLogFlagDebug,
    MATLogFlagVerbose,
};

typedef NS_ENUM(NSUInteger, MATLogLevel) {
    MATLogLevelOff,
    MATLogLevelError,
    MATLogLevelWarning,
    MATLogLevelInfo,
    MATLogLevelDebug,
    MATLogLevelVerbose,
    MATLogLevelAll,
};

@class MATLogModel;
@protocol MATLogDelegate <NSObject>

/// 上传日志到服务器
/// - Parameters:
///   - logs: 日志
///   - completionBlock: 完成回调。上传完成后必须调用completionBlock。
- (void)uploadLogs:(NSArray<MATLogModel *> *)logs completion:(void(^)(NSError *error))completionBlock;

@end


@interface MATLog : NSObject

+ (void)setLogLevel:(MATLogLevel)level;

+ (MATLogLevel)logLevel;

+ (void)setDelegate:(id<MATLogDelegate>)delegate;

+ (void)logErrorWithFile:(const char *)file
               function:(nullable const char *)function
                   line:(NSUInteger)line
                 format:(NSString *)format, ... ;

+ (void)logWarningWithFile:(const char *)file
                 function:(nullable const char *)function
                     line:(NSUInteger)line
                   format:(NSString *)format, ... ;

+ (void)logInfoWithFile:(const char *)file
              function:(nullable const char *)function
                  line:(NSUInteger)line
                format:(NSString *)format, ... ;

+ (void)logDebugWithFile:(const char *)file
               function:(nullable const char *)function
                   line:(NSUInteger)line
                 format:(NSString *)format, ... ;

+ (void)logVerboseWithFile:(const char *)file
                 function:(nullable const char *)function
                     line:(NSUInteger)line
                   format:(NSString *)format, ... ;

+ (void)logError:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... ;

+ (void)logWarning:(BOOL)isAsynchronous
           upload:(BOOL)isUpload
         moduleType:(NSInteger)type
               file:(const char *)file
           function:(nullable const char *)function
               line:(NSUInteger)line
             format:(NSString *)format, ... ;

+ (void)logInfo:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... ;

+ (void)logDebug:(BOOL)isAsynchronous
       upload:(BOOL)isUpload
     moduleType:(NSInteger)type
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... ;

+ (void)logVerbose:(BOOL)isAsynchronous
           upload:(BOOL)isUpload
         moduleType:(NSInteger)type
               file:(const char *)file
           function:(nullable const char *)function
               line:(NSUInteger)line
             format:(NSString *)format, ... ;

+ (void)log:(BOOL)asynchronous
   upload:(BOOL)isUpload
      level:(MATLogLevel)level
       flag:(MATLogFlag)flag
 moduleType:(NSInteger)type
       file:(const char *)file
   function:(nullable const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... ;

@end

NS_ASSUME_NONNULL_END
