//
//  MATOSFormatter.m
//  MATLog
//
//  Created by xq on 2021/6/3.
//

#import "MATOSFormatter.h"

@implementation MATOSFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSInteger moduleType = logMessage.context;
    NSString *levelStr = [self stringWithLogFlag:logMessage.flag];
    return [NSString stringWithFormat:@"%@ +%@ [level:%@,module:%@]\n%@\n", logMessage.function, @(logMessage->_line), levelStr, @(moduleType), logMessage->_message];
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

+ (NSString *)getPrettyCurrentThreadDescription {
    NSString *raw = [NSString stringWithFormat:@"%@", [NSThread currentThread]];

    NSArray *firstSplit = [raw componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{"]];
    if ([firstSplit count] > 1) {
        NSArray *secondSplit = [firstSplit[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"}"]];
        if ([secondSplit count] > 0) {
            NSString *numberAndName = secondSplit[0];
            return numberAndName;
        }
    }

    return raw;
}

@end
