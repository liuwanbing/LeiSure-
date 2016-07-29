//
//  CarouselView.h
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个block，无返回值，有参数
typedef void(^CarouselViewViewBlock)(NSInteger index);

//自动轮播时间
#define Kinterval  2

@interface CarouselView : UIView

//声明一个block属性 用做图片点击
@property (nonatomic,copy)CarouselViewViewBlock imageClickBlock;

//两个必要的参数，frame和图片地址
- (instancetype)initWithFrame:(CGRect)frame iamgeURLS:(NSArray *)imageURLS;

//重新配置轮播图数据
- (void)setUpScrollerView:(NSArray *)imageURLS;



@end
