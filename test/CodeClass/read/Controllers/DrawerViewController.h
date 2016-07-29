//
//  DrawerViewController.h
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

//主页面偏移距离
#define kproportion 0.7

@interface DrawerViewController : UIViewController

//用来判断是否已经打开抽屉
@property (nonatomic,assign) BOOL isOpen;

//初始化方法，第一个参数 左侧抽屉控制器，第二页，主页控制器

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController MainViewController:(UIViewController *)mainViewControlelr;

//打开抽屉
- (void)open;

//关闭
- (void)close;

//切换主视图控制器
- (void)setMainVIewController:(UIViewController *)newVC;

@end
