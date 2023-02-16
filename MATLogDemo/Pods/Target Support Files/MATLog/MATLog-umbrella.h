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
#import "MATLog+Internal.h"
#import "MATLog.h"
#import "MATLogFileManager.h"
#import "MATLogger.h"
#import "MATLogMacros.h"
#import "MATOSFormatter.h"

FOUNDATION_EXPORT double MATLogVersionNumber;
FOUNDATION_EXPORT const unsigned char MATLogVersionString[];

