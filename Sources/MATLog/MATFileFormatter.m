//
//  MATFileFormatter.m
//  MATLog
//
//  Created by xq on 2021/5/28.
//

#import "MATFileFormatter.h"

@interface MATFileFormatter () {
    NSDateFormatter *_dateFormatter;
}

@end

@implementation MATFileFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSInteger moduleType = logMessage.context;
    NSString *levelStr = [self stringWithLogFlag:logMessage.flag];
    return [NSString stringWithFormat:@"%@ %@ +%@ [level:%@,module:%@]\n%@\n", [_dateFormatter stringFromDate:logMessage ->_timestamp], logMessage.function, @(logMessage->_line), levelStr, @(moduleType), logMessage->_message];
}

- (NSString *)stringWithLogFlag:(DDLogFlag)flag {
    NSString *ret = @"Unknown";
    switch (flag) {
        case DDLogFlagError:
            ret = @"Error";
            break;
        case DDLogFlagWarning:
            ret = @"Warning";
            break;
        case DDLogFlagInfo:
            ret = @"Info";
            break;
        case DDLogFlagDebug:
            ret = @"Debug";
            break;
        case DDLogFlagVerbose:
            ret = @"Verbose";
            break;
        default:
            break;
    }
    return ret;
}

@end
