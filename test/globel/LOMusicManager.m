//
//  LOMusicManager.m
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "LOMusicManager.h"

static LOMusicManager *musicManager = nil;

@implementation LOMusicManager



{   //当前播放的网址
    NSString *currentUrl;
    //定时器 用来不断的获取当前播放进度
    NSTimer *timer;

}

+(instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicManager = [[LOMusicManager alloc] init];
    });

    return musicManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.AV = [[AVPlayer alloc] init];
        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        //加入到runloop
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

//播放某个地址的音频
- (void)playMusicWithURLString:(NSString *)URLString {
    
    //判断这个是不是正在播放
    if ([URLString isEqualToString:currentUrl]) {
        return;
    }
    currentUrl = URLString;
    //暂停定时器
    [timer setFireDate:[NSDate distantFuture]];
    //先移除旧的item上的观察者， 因为，一旦替换了资源，旧的item 就会被销毁
    if (self.currentItem != nil) {
        [self.currentItem removeObserver:self forKeyPath:@"status"];
    }
    //创建一个item
    self.currentItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:URLString]];
    //替换当期资源
    [self.AV replaceCurrentItemWithPlayerItem:self.currentItem];
    
//    [self.AV play];

    //添加一个观察着，观察者播放器的缓冲状态
    [self.currentItem  addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

//观察者回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //判断当前的缓冲状态
    AVPlayer *play = object;
    switch (play.status) {
        case AVPlayerStatusReadyToPlay:
            NSLog(@"缓冲成功");
            [self play];
            break;
        case AVPlayerStatusFailed:
            NSLog(@"缓冲失败");
            break;
            case AVPlayerStatusUnknown:
            NSLog(@"状态未知");
            break;
        default:
            NSLog(@"状态未知");
            break;
    }


}

//播放
- (void)play {
    [self.AV play];
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [timer fire];

}
//暂停
- (void)pause {

    [self.AV pause];
    //暂停同时暂停定时器
    [timer setFireDate:[NSDate distantFuture]];



}

//定时器方法
- (void)timerAction {
    //0不能当分母 需要加判断
    if (self.AV.currentTime.timescale != 0 && self.AV.currentItem.duration.timescale != 0) {
        //获取当前时间
        CGFloat currentTime = self.AV.currentTime.value / self.AV.currentTime.timescale;
        //获取总时间
        CGFloat totalTime = self.AV.currentItem.duration.value / self.AV.currentItem.duration.timescale;
        //判断代理对象是否实现了代理方法
        if ([self.delegate respondsToSelector:@selector(currentTime:totalTime:)]) {
            //如果实现了  就调用代理方法
            [self.delegate currentTime:currentTime totalTime:totalTime];
        }
        
    }


}

- (BOOL)isPlay {
    //1，是表示在播放状态
    if (self.AV.rate == 1.0) {
        return YES;
    }else {
    
        return NO;
    }

}
@end
