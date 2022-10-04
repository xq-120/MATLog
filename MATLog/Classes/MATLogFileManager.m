//
//  MATLogFileManager.m
//  MATLog
//
//  Created by xq on 2021/5/28.
//

#import "MATLogFileManager.h"

@interface MATLogFileManager () {
    NSDateFormatter *_dateFormatter;
}
@end

@implementation MATLogFileManager

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory {
    self = [super initWithLogsDirectory:logsDirectory];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'--'HH'-'mm'-'ss'"];
    }
    return self;
}

- (NSString *)newLogFileName {
    NSString *appName = [self applicationName];

    NSString *formattedDate = [_dateFormatter stringFromDate:[NSDate date]];

    return [NSString stringWithFormat:@"%@ %@.log", appName, formattedDate];
}

- (BOOL)isLogFile:(NSString *)fileName {
    return [super isLogFile:fileName];
}

- (NSString *)applicationName {
    static NSString *_appName;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];

        if (_appName.length == 0) {
            _appName = [[NSProcessInfo processInfo] processName];
        }

        if (_appName.length == 0) {
            _appName = @"";
        }
    });

    return _appName;
}


@end
