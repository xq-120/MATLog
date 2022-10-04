//
//  MATLog.h
//  MATLog
//
//  Created by 薛权 on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, MATLogFlag) {
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
        

@interface MATLog : NSObject

+ (void)setLogLevel:(MATLogLevel)level;

+ (MATLogLevel)logLevel;

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
