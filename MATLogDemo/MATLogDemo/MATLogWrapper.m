//
//  MATLogWrapper.m
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

#import "MATLogWrapper.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
//#import <MATLog/MATLogger.h>

static NSInteger ddLogLevel = DDLogLevelDebug;

@implementation MATLogWrapper

+ (void)logError:(NSString *)message {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DDLog addLogger:[DDOSLogger new]];
    });
    
    DDLogError(@"%@", message);
    
//    MATLogError(@"%@", message);
}

@end
