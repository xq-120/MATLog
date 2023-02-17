//
//  MATLogModel.h
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MATLogModel : NSObject

/**
 主键index
 */
@property (nonatomic, assign) NSUInteger logID;

/// 日志产生时间。毫秒级
@property (nonatomic, assign) NSUInteger logTimestamp;

@property (nonatomic, copy) NSString *logContent;

@property (nonatomic, copy) NSString *logDetail;

@end

NS_ASSUME_NONNULL_END
