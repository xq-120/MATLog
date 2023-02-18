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
@property (nonatomic, assign) NSInteger uploadThreshold; //10条
@property (nonatomic, assign) NSInteger uploadInterval; //10s
@property (nonatomic, strong) NSTimer *reportTimer;
@property (nonatomic, assign) BOOL isUploading;

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
        
        [self uploadWithThreshold:self.uploadThreshold];
    });
}

// 确保在serailQueue中执行。
- (void)uploadWithThreshold:(NSInteger)threshold {
    if (self.isUploading) {
        return;
    }
    
    NSArray *items = [self.dbServer querryAllItems];
    if (items.count == 0 || items.count < threshold) {
        return;
    }
    [self uploadItems:items];
}


- (void)uploadItems:(NSArray<MATLogModel *> *)items {
    if (self.isUploading) {
        return;
    }
    self.isUploading = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.delegate uploadLogs:items completion:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        
        dispatch_async(strongSelf.serailQueue, ^{
            if (!error) {
                [strongSelf.dbServer deleteItems:items];
            }
            strongSelf.isUploading = NO;
        });
    }];
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
        [self uploadWithThreshold:0];
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
