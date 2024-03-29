#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MATFileFormatter.h"
#import "MATLog.h"
#import "MATLogDatabaseServer.h"
#import "MATLogFileManager.h"
#import "MATLogger.h"
#import "MATLogMacros.h"
#import "MATLogModel.h"
#import "MATOSFormatter.h"
#import "MATUploadManager.h"

FOUNDATION_EXPORT double MATLogVersionNumber;
FOUNDATION_EXPORT const unsigned char MATLogVersionString[];

