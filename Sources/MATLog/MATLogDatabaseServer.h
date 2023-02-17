//
//  MATLogDatabaseServer.h
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import <Foundation/Foundation.h>
#import "MATLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MATLogDatabaseServer : NSObject

- (BOOL)insertItem:(MATLogModel *)log;

- (void)deleteItems:(NSArray<MATLogModel *> *)logs;

- (NSArray<MATLogModel *> *)querryAllItems;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
