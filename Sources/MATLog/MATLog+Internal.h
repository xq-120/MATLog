//
//  MATLog+Internal.h
//  Pods
//
//  Created by xq on 2023/2/16.
//

#import "MATLog.h"

@interface MATLog (Internal)

+ (DDLogLevel)toDDLogLevel:(MATLogLevel)level;

+ (DDLogFlag)toDDLogFlag:(MATLogFlag)flag;

@end
