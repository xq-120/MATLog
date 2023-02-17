//
//  MATLog+Internal.h
//  Pods
//
//  Created by xq on 2023/2/16.
//

#import "MATLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface MATLog (Internal)

+ (DDLogLevel)toDDLogLevel:(MATLogLevel)level;

+ (DDLogFlag)toDDLogFlag:(MATLogFlag)flag;

+ (MATLogModel *)convertToDBItemWithLogMessage:(DDLogMessage *)logMessage;

+ (void)log:(BOOL)asynchronous
   isUpload:(BOOL)isUpload
      level:(MATLogLevel)level
       flag:(MATLogFlag)flag
 moduleType:(NSInteger)type
       file:(const char *)file
   function:(nullable const char *)function
       line:(NSUInteger)line
 logMessage:(DDLogMessage *)logMessage;

@end
