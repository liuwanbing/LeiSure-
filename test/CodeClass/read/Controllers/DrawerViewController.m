//
//  DrawerViewController.m
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "DrawerViewController.h"


#warning ----cancel ----
@interface DrawerViewController ()<UINavigationControllerDelegate>

//主页面视图
@property (nonatomic,strong)UIView *mainView;

//左侧试图
@property (nonatomic,strong)UIView *leftView;


//添加一个手势
@property (nonatomic,strong)UIPanGestureRecognizer *pan;

@end

@implementation DrawerViewController



- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController MainViewController:(UIViewController *)mainViewControlelr {
    
    self = [super init];
    if (self) {
        
        //添加为子视图的控制器,如果在一个控制器里使用了另外一个控制器的View需要把这个控制器B添加为控制器的子视图控制器，防止控制器被销毁 ，先加left视图，点击main出现left
        
        [self addChildViewController:leftViewController];
        
        [self addChildViewController:mainViewControlelr];
        
        //左侧控制器添加在最下面
        [self.view addSubview:leftViewController.view];

        //添加主页面的控制器view
        [self.view addSubview:mainViewControlelr.view];
        
        //视图赋值
        self.mainView = mainViewControlelr.view;
        self.leftView = leftViewController.view;
        
        //在mainview 添加一个手势 初始化手势
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHander)];
        
        //将手势添加到上面的mainview上
        [self.mainView addGestureRecognizer:self.pan];
    
        //将leftView的frame 修改到屏幕的左边，来做一个平移效果
        CGRect leftFrame = self.leftView.frame;
//        leftFrame.origin.x -= self.view.frame.size.width *kproportion / 2;
        leftFrame.origin.x = leftFrame.origin.x - self.view.frame.size.width *kproportion / 2;
        
        self.leftView.frame = leftFrame;

        
        //先把缩放设置为2，也就是放大状态
        self.leftView.transform = CGAffineTransformMakeScale(2, 2);
        
        //给导航控制器设置代理协议
        UINavigationController *NAVC  = (UINavigationController *)mainViewControlelr ;
    
        NAVC.delegate = self;
    }

    return self;
}

//平移手势处理方法
- (void) panHander {

    //获取用户手势的位置
    CGPoint userPoint = [self.pan translationInView:self.mainView];

    
// NSLog(@"%@",NSStringFromCGPoint(userPoint));

    //接收原始的frame
    CGRect mainFrame = self.mainView.frame;
    //mainview的x的值等于手滑动所在的位置
//    mainFrame.origin.x += userPoint.x;
    mainFrame.origin.x = mainFrame.origin.x + userPoint.x;
    
    //判断是否是在可滑动的范围内 ，mainframe.origin.x >= 0 ,是为了使手势不能往左滑动，同时小于滑动的所占屏幕的最大的比例
    
    if (mainFrame.origin.x >= 0 && mainFrame.origin.x <= self.mainView.frame.size.width * kproportion) {
        
        self.mainView.frame = mainFrame;
        
        
        //修改缩放
        //获得当前偏移的比例
        CGFloat a = self.mainView.frame.origin.x / (self.view.frame.size.width * kproportion);
        
        self.leftView.transform  = CGAffineTransformMakeScale(2 - a, 2 - a);
        
        
        
        //同时修改leftview的frame
        CGRect leftFrame  = self.leftView.frame;
        
        //????这个地方表示 -self.view.frame.size.width * kproportion / 2 + mainFrame.origin.x / 2 ;
        
        leftFrame.origin.x = mainFrame.origin.x / 2 - self.view.frame.size.width * kproportion / 2;
        
        self.leftView.frame = leftFrame;
        
        
    }
    
    
    //将本次已经移动到的点设置为0
    [self.pan setTranslation:(CGPointZero) inView:self.mainView];
    //当用户手指离开屏幕的时候判断需要打开的还是关闭
    if (self.pan.state == UIGestureRecognizerStateEnded) {
        if (self.mainView.frame.origin.x >= self.view.frame.size.width * kproportion / 2) {
            
            [self open];
            
        }else {
            
            //否则调用close
            [self close];
        }
    }
    
}

//打开抽屉,
- (void)open {

    
    
    
    [UIView animateWithDuration:0.3 animations:^{
    
        //修改leftview 的缩放
        self.leftView.transform = CGAffineTransformMakeScale(1, 1);

        //打开抽屉，就是将mianview的frame改变到所给的比例，改变x的大小。屏幕大小的比例乘以0.7，在将改变的值赋值给mainframe，然后就做到显示到了左边的视图，
        
        //获取原始的frame
        CGRect mainFrame = self.mainView.frame;
        //修改x值，使其往右边移动 总的宽度乘以比例
        mainFrame.origin.x = self.view.frame.size.width * kproportion;
        //赋值新的View的frame
        self.mainView.frame = mainFrame;
        
        
        //修改leftView的frame让他跟着一起动
        self.leftView.frame = self.view.frame;
        
        
    }completion:^(BOOL finished) {

        self.isOpen = YES;
        
    }];
    

}

//关闭抽屉
-(void)close {
    
    //修改leftview 的缩放
    self.leftView.transform = CGAffineTransformMakeScale(2, 2);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //让主页视图回到原始的位置，关闭抽屉，就是让mianview.frame回到原来的位置，和屏幕等大的位置
        self.mainView.frame = self.view.frame;
        
        
    } completion:^(BOOL finished) {
        
        
        //将leftView的frame 修改到屏幕的左边，来做一个平移效果
        CGRect leftFrame = self.leftView.frame;
        leftFrame.origin.x -= self.view.frame.size.width *kproportion / 2;
        self.leftView.frame = leftFrame;

        //修改状态
        self.isOpen = NO;
    }];
    

}



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
//    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
}


//切换主视图控制器，因为导航控制器也是视图控制器的子类，所有可以直接用视图控制器来接收
- (void)setMainVIewController:(UIViewController *)newVC {
    //给导航控制器设置代理协议
    UINavigationController *NAVC  = (UINavigationController *)newVC ;
    
    NAVC.delegate = self;
    
//判断视图控制器是否已经存在
    if (![self.childViewControllers containsObject:newVC]) {
        [self addChildViewController:newVC];
    }
    
    //如果传进来的控制器正在显示 直接返回
    if (newVC.view == self.mainView) {
        return;
    }
    //用当前主视图的frame作为新的视图frame
    CGRect mainFrame = self.mainView.frame;

    //先让视图出现在view处于屏幕的下方,加上一个与屏幕登高的高度之后，mainFrame就显示在屏幕的下方
    
    //mainFrame.origin.y += KscreenHeight;
    mainFrame.origin.y = mainFrame.origin.y + KscreenHeight;
    
    //将改变后的frame赋给新的frame
    newVC.view.frame = mainFrame;
    
    //第二个要去的地方是原来的位置
    //mainFrame.origin.y -= KscreenHeight;
    mainFrame.origin.y = mainFrame.origin.y - KscreenHeight;
    
    //添加到视图上
    [self.view addSubview:newVC.view];

    
    //加点特效，用动画的方式将视图控制器显示出来
    [UIView animateWithDuration:0.3 animations:^{
        
        //将第二次改变后的frame赋值给添加进来的视图控制器
        newVC.view.frame = mainFrame;

        self.leftView.userInteractionEnabled = NO;
        
    }completion:^(BOOL finished) {
       
        
        //移除旧的视图
        [self.mainView removeFromSuperview];
        
        //移除平移手势
        [self.mainView removeGestureRecognizer:self.pan];
        
        //让MainView的指针指向新的Mainview
        self.mainView = newVC.view;
        
        //给新的mainview添加手势
        [self.mainView addGestureRecognizer:self.pan];
        self.leftView.userInteractionEnabled = YES;
        //切换完成，关闭抽屉
        [self close];

    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning -----remove guesture----
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //如果将要显示的vc 就是rootvc 把手势添加回来，如果不是，把手势删掉
    if (navigationController.childViewControllers[0] == viewController) {
        [self.mainView addGestureRecognizer:self.pan];
        
    }else {
    
        [self.mainView removeGestureRecognizer:self.pan];
    
    }

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
