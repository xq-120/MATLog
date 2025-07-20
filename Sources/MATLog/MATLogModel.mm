//
//  MATLogModel.m
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import "MATLogModel.h"
#import "MATLogModel+WCTTableCoding.h"

@implementation MATLogModel

WCDB_IMPLEMENTATION(MATLogModel)
WCDB_PRIMARY_AUTO_INCREMENT(logID) //特别注意logID只有入库后再取出来才会有值，刚创建的对象是没有值的。
WCDB_SYNTHESIZE(logID)
WCDB_SYNTHESIZE(logTimestamp)
WCDB_SYNTHESIZE(logContent)
WCDB_SYNTHESIZE(logDetail)

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p>,logID:%ld,logDetail:%@", self.class, self, _logID, _logDetail];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAutoIncrement = YES;
    }
    return self;
}

@end
