//
//  MATLogDatabaseServer.m
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import "MATLogDatabaseServer.h"
#import "MATLogModel+WCTTableCoding.h"
#import <WCDB/WCDB.h>

#define kMATLogTable @"MATLogTable"
#define kMATLogDBPath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"DB/MATLog.db"])

@interface MATLogDatabaseServer ()

@property (nonatomic, strong) WCTDatabase *database;

@end

@implementation MATLogDatabaseServer

- (instancetype)init
{
    self = [super init];
    BOOL rs = [self creatDatabase];
    if (!rs) {
        return nil;
    }
    return self;
}

- (BOOL)creatDatabase
{
    BOOL result = YES;
    _database = [[WCTDatabase alloc] initWithPath:kMATLogDBPath];
    if (![_database isTableExists:kMATLogTable]) {
        result = [_database createTableAndIndexesOfName:kMATLogTable withClass:MATLogModel.class];
    }
    return result;
}
    
- (BOOL)insertItem:(MATLogModel *)log
{
    BOOL result = [_database insertObject:log into:kMATLogTable];
    if (result) {
        log.logID = log.lastInsertedRowID;
    }
    return result;
}

- (void)deleteItems:(NSArray<MATLogModel *> *)logs {
    WCTCondition condition;
    BOOL isFirst = YES;
    for (MATLogModel *model in logs) {
        if (isFirst) {
            isFirst = NO;
            condition = (MATLogModel.logID == model.logID);
        } else {
            condition = condition || MATLogModel.logID == model.logID;
        }
    }
    BOOL success = [_database deleteObjectsFromTable:kMATLogTable where:condition];
    if (!success) {
        NSLog(@"删除失败");
    }
}
    
- (NSArray<MATLogModel *> *)querryAllItems {
    NSArray<MATLogModel *> *items = [_database getAllObjectsOfClass:MATLogModel.class fromTable:kMATLogTable];
    return items;
}

- (void)clear {
    [_database deleteAllObjectsFromTable:kMATLogTable];
}

@end
