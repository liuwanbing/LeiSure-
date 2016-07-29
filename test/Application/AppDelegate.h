//
//  AppDelegate.h
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//抽屉控制器，声明为属性，方便在其他地方使用
@property (nonatomic,strong)DrawerViewController *drawerVC;

//打开抽屉
- (void)openDrawer;

//声明一个字典 存放已经初始化过的控制器，避免重复初始化
@property (nonatomic,strong)NSMutableDictionary *viewControllerDic;


@end

