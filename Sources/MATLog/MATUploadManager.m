//
//  MATUploadManager.m
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import "MATUploadManager.h"
#import "MATLogDatabaseServer.h"

/**
 上报策略：
 1.攒够10条则上报
 2.定时器每隔10s上报。
 3.进入前台马上上报。
 4.调用asyncUpload:immediately,immediately=YES马上上报。
 */
@interface MATUploadManager ()

@property (nonatomic, strong) MATLogDatabaseServer *dbServer;
@property (nonatomic, strong) dispatch_queue_t serailQueue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSInteger uploadThreshold; //10条
@property (nonatomic, assign) NSInteger uploadInterval; //10s
@property (nonatomic, strong) NSTimer *reportTimer;

@end

@implementation MATUploadManager

- (void)dealloc {
    [self removeNotification];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dbServer = [[MATLogDatabaseServer alloc] init];
        _serailQueue = dispatch_queue_create("com.matlog.upload", DISPATCH_QUEUE_SERIAL);
        _semaphore = dispatch_semaphore_create(0);
        _uploadThreshold = 10;
        _uploadInterval = 10;
        [self setupTimer];
        [self addNotification];
    }
    return self;
}

- (void)asyncUpload:(MATLogModel *)item {
    [self asyncUpload:item immediately:NO];
}

- (void)asyncUpload:(MATLogModel *)item immediately:(BOOL)immediately {
    dispatch_async(self.serailQueue, ^{
        [self.dbServer insertItem:item];
        if (immediately) {
            [self uploadItems:@[item]];
            return;
        }
        NSArray *items = [self.dbServer querryAllItems];
        if (items.count < self.uploadThreshold) {
            return;
        }
        [self uploadItems:items];
    });
}

// 同步任务
- (void)uploadItems:(NSArray<MATLogModel *> *)items {
    NSLog(@"将要上报数据：arr.count:%ld", items.count);
    
    __weak typeof(self) weakSelf = self;
    [self.delegate uploadLogs:items completion:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        if (!error) {
            [strongSelf.dbServer deleteItems:items];
            NSArray *tmp = [strongSelf.dbServer querryAllItems];
            NSLog(@"上传成功，删除已上报数据后数据库剩余：tmp.count:%ld,tmp：%@", tmp.count, tmp);
        } else {
            // 上传失败则不删除数据库数据
        }
        dispatch_semaphore_signal(strongSelf.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)setupTimer {
    __weak typeof(self) weakSelf = self;
    _reportTimer = [NSTimer scheduledTimerWithTimeInterval:self.uploadInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [strongSelf timerCountDown:timer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:_reportTimer forMode:NSRunLoopCommonModes];
}

- (void)timerCountDown:(NSTimer *)timer {
    dispatch_async(self.serailQueue, ^{
        NSArray *items = [self.dbServer querryAllItems];
        if (items.count == 0) {
            return;
        }
        [self uploadItems:items];
    });
}

// MARK: 监听

- (void)addNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [center addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)enterForegroundNotification {
    [_reportTimer setFireDate:[NSDate date]];
}

- (void)enterBackgroundNotification {
    [_reportTimer setFireDate:[NSDate distantFuture]];
}

@end
