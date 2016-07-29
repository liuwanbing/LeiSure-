//
//  LOMusicManager.h
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LOMusicManagerDelegate<NSObject>

@optional
//代理方法，将当前的时间和总时间传给外界
-(void)currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;

@end

@interface LOMusicManager : NSObject


//声明代理属性
@property (nonatomic,weak) id<LOMusicManagerDelegate> delegate;

//媒体播放对象属性
@property (nonatomic,strong) AVPlayer *AV;

//当前播放的item
@property (nonatomic,strong)AVPlayerItem *currentItem;

+ (instancetype)sharedManager;

//播放某个地址的音频
- (void)playMusicWithURLString:(NSString *)URLString;

//播放
- (void)play;
//暂停
- (void)pause;

//当前播放状态
@property (nonatomic,assign) BOOL isPlay;



@end
