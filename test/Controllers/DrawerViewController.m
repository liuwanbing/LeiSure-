//
//  DrawerViewController.m
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "DrawerViewController.h"



@interface DrawerViewController ()

//主页面视图
@property (nonatomic,strong)UIView *mainView;

//左侧试图
@property (nonatomic,strong)UIView *leftView;

@end

@implementation DrawerViewController

-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController MainViewController:(UIViewController *)mainViewControlelr {
    self = [super init];
    if (self) {
        
        //添加为子视图的控制器
        [self addChildViewController:leftViewController];
        [self addChildViewController:mainViewControlelr];
        
        //左侧控制器添加在最小面
        [self.view addSubview:leftViewController.view];

        //添加主页面的控制器view
        [self.view addSubview:mainViewControlelr.view];
        
        //视图赋值
        self.mainView = mainViewControlelr.view;
        self.leftView = leftViewController.view;
    
    }

    return self;
}

//打开抽屉
-(void)open {

    [UIView animateWithDuration:0.3 animations:^{
        
        //获取原始的frame
        CGRect mainFrame = self.mainView.frame;
        //修改x值，使其往右边移动 总的宽度乘以比例
        mainFrame.origin.x = self.view.frame.size.width * kproportion;
        //赋值新的View的frame
        self.mainView.frame = mainFrame;
        
        
    }completion:^(BOOL finished) {
        
    }];

}

//关闭抽屉
-(void)close {


}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
