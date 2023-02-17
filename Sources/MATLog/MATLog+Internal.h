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

@end
