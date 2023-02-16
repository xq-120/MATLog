//
//  MATLogMacros.h
//  Pods
//
//  Created by 薛权 on 2022/10/3.
//

#ifndef MATLogMacros_h
#define MATLogMacros_h

#define MATLog_FUNCTION_MACRO(isAsynchronous, isUpload, lvl, flg, type, frmt, ...)   \
        [MATLog log : isAsynchronous                                      \
             upload : isUpload                                              \
              level : lvl                                                  \
               flag : flg                                                  \
         moduleType : type                                                 \
               file : __FILE__                                             \
           function : __PRETTY_FUNCTION__                                  \
               line : __LINE__                                             \
             format : (frmt), ## __VA_ARGS__]

#define MATLog_MACRO(isAsynchronous, isUpload, lvl, flg, moduleType, frmt, ...) \
        do { MATLog_FUNCTION_MACRO(isAsynchronous, isUpload, lvl, flg, moduleType, frmt, ##__VA_ARGS__); } while(0)

#define MATLogLevel ([MATLog logLevel])

//mark: 普通打印，不上传服务器
#define MATLogError(frmt, ...) MATLog_MACRO(NO, NO, MATLogLevel, MATLogFlagError, 0, frmt, ##__VA_ARGS__)

#define MATLogWarning(frmt, ...) MATLog_MACRO(YES, NO, MATLogLevel, MATLogFlagWarning, 0, frmt, ##__VA_ARGS__)

#define MATLogInfo(frmt, ...) MATLog_MACRO(YES, NO, MATLogLevel, MATLogFlagInfo, 0, frmt, ##__VA_ARGS__)

#define MATLogDebug(frmt, ...) MATLog_MACRO(YES, NO, MATLogLevel, MATLogFlagDebug, 0, frmt, ##__VA_ARGS__)

#define MATLogVerbose(frmt, ...) MATLog_MACRO(YES, NO, MATLogLevel, MATLogFlagVerbose, 0, frmt, ##__VA_ARGS__)

//mark: 打印并上传服务器
#define MATLogErrorUpload(frmt, ...) MATLog_MACRO(NO, YES, MATLogLevel, MATLogFlagError, 0, frmt, ##__VA_ARGS__)

#define MATLogWarningUpload(frmt, ...) MATLog_MACRO(YES, YES, MATLogLevel, MATLogFlagWarning, 0, frmt, ##__VA_ARGS__)

#define MATLogInfoUpload(frmt, ...) MATLog_MACRO(YES, YES, MATLogLevel, MATLogFlagInfo, 0, frmt, ##__VA_ARGS__)

#define MATLogDebugUpload(frmt, ...) MATLog_MACRO(YES, YES, MATLogLevel, MATLogFlagDebug, 0, frmt, ##__VA_ARGS__)

#define MATLogVerboseUpload(frmt, ...) MATLog_MACRO(YES, YES, MATLogLevel, MATLogFlagVerbose, 0, frmt, ##__VA_ARGS__)

//mark: 高级打印.是否异步打印，是否上传服务器，模块类型，日志内容
#define MATLogErrorPro(isAsynchronous, isUpload, moduleType, frmt, ...) MATLog_MACRO(isAsynchronous, isUpload, MATLogLevel, MATLogFlagError, moduleType, frmt, ##__VA_ARGS__)

#define MATLogWarningPro(isAsynchronous, isUpload, moduleType, frmt, ...) MATLog_MACRO(isAsynchronous, isUpload, MATLogLevel, MATLogFlagWarning, moduleType, frmt, ##__VA_ARGS__)

#define MATLogInfoPro(isAsynchronous, isUpload, moduleType, frmt, ...) MATLog_MACRO(isAsynchronous, isUpload, MATLogLevel, MATLogFlagInfo, moduleType, frmt, ##__VA_ARGS__)

#define MATLogDebugPro(isAsynchronous, isUpload, moduleType, frmt, ...) MATLog_MACRO(isAsynchronous, isUpload, MATLogLevel, MATLogFlagDebug, moduleType, frmt, ##__VA_ARGS__)

#define MATLogVerbosePro(isAsynchronous, isUpload, moduleType, frmt, ...) MATLog_MACRO(isAsynchronous, isUpload, MATLogLevel, MATLogFlagVerbose, moduleType, frmt, ##__VA_ARGS__)

#endif /* MATLogMacros_h */
