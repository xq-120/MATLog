//
//  MATUploadManager.h
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import <Foundation/Foundation.h>
#import "MATLogModel.h"
#import "MATLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface MATUploadManager : NSObject

@property (nonatomic, weak) id<MATLogDelegate> delegate;

- (void)asyncUpload:(MATLogModel *)item;

- (void)asyncUpload:(MATLogModel *)item immediately:(BOOL)immediately;

@end

NS_ASSUME_NONNULL_END
