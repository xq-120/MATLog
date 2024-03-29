//
//  MATLogWrapper.m
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

#import "DDLogWrapper.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static NSInteger ddLogLevel = DDLogLevelDebug;

@implementation DDLogWrapper

+ (void)logError:(NSString *)message {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DDLog addLogger:[DDOSLogger new]];
    });
    
    DDLogError(@"%@", message);
}

@end
