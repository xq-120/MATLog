//
//  MATLogWrapper.m
//  MATLogDemo
//
//  Created by xq on 2023/2/16.
//

#import "MATLogWrapper.h"
#import <MATLog/MATLogger.h>

@implementation MATLogWrapper

+ (void)logError:(NSString *)message {
    MATLogError(message);
}

@end
