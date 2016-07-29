//
//  PlayDetailView.h
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//




typedef void(^playViewScrollViewBlock)(CGFloat offsetx);


#import <UIKit/UIKit.h>
#import "RadioDetailModel.h"


@interface PlayDetailView : UIView

//在一个UIView 上加一个Scrollview，ScrollView加一个
@property (nonatomic, strong) UIScrollView *rootScroller;

@property (nonatomic, strong) UITableView *musicListTableView;

//显示专辑
@property (nonatomic, strong) UIImageView *imageView;

//显示专辑的名称
@property (nonatomic, strong) UILabel *titleLabel;

//最右边的显示歌词的webView
@property (nonatomic, strong) UIWebView *webView;

//当前正在播放的model
@property (nonatomic, strong) RadioDetailModel *currentModel;

//将当前scrollview的偏移量传递给外界
@property (nonatomic,copy) playViewScrollViewBlock offsetChanged;

//初始化方法，传入所有的歌曲列表
- (instancetype)initWithFrame:(CGRect)frame musicList:(NSMutableArray *)musicListArray;


@end
