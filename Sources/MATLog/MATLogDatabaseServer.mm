//
//  MATLogDatabaseServer.m
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import "MATLogDatabaseServer.h"
#import "MATLogModel+WCTTableCoding.h"
#import <WCDBObjc/WCDBObjc.h>

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
    _database = [[WCTDatabase alloc] initWithPath:kMATLogDBPath];
    BOOL result = [_database createTable:kMATLogTable withClass:MATLogModel.class];
    return result;
}
    
- (BOOL)insertItem:(MATLogModel *)log
{
    BOOL result = [_database insertObject:log intoTable:kMATLogTable];
    //lastInsertedRowID is only useful when inserting new data.
    //一条数据插入后，模型的lastInsertedRowID的值才可用。其他时候获取是0,比如查询。
    return result;
}

- (void)deleteItems:(NSArray<MATLogModel *> *)logs {
    if (logs.count == 0) {
        return;
    }

    // 获取主键数组
    NSMutableArray *logIDs = [NSMutableArray arrayWithCapacity:logs.count];
    for (MATLogModel *log in logs) {
        if (log.logID > 0) {
            [logIDs addObject:@(log.logID)];
        }
    }

    BOOL success = [_database deleteFromTable:kMATLogTable where:MATLogModel.logID.in(logIDs)];
    if (!success) {
        NSError *error = _database.error;
        NSLog(@"批量删除失败：%@", error.localizedDescription);
    }
}
    
- (NSArray<MATLogModel *> *)querryAllItems {
    NSArray<MATLogModel *> *items = [_database getObjectsOfClass:MATLogModel.class fromTable:kMATLogTable];
    return items;
}

- (void)clear {
    [_database deleteFromTable:kMATLogTable];
}

@end
