//
//  CarouselView.m
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "CarouselView.h"


@interface CarouselView ()<UIScrollViewDelegate>

//最底层的scrollview
@property (nonatomic,strong)UIScrollView *scrollerView;
//位置指示器
@property (nonatomic,strong)UIPageControl *pageController;
//定时器
@property(nonatomic,strong)NSTimer *timer;




@end
@implementation CarouselView


//两个必要的参数，frame和图片地址
- (instancetype)initWithFrame:(CGRect)frame iamgeURLS:(NSArray *)imageURLS {
#warning self = [super init]不会有效果;
    
    self = [super initWithFrame:frame];//这个地方需要注意，用init初始化的话，他的frame没有初始化
    if (self) {
        //如果数组里是空的，就没有必要初始化了
        if (imageURLS.count == 0) {
            return nil;
        }
        //初始化scrollview
        self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollerView.backgroundColor =[UIColor cyanColor];
        //指定代理对象
        self.scrollerView.delegate = self;
        //不显示水平进度条
        self.scrollerView.showsHorizontalScrollIndicator = NO;
        //整页滑动
        self.scrollerView.pagingEnabled = YES;
        [self addSubview:self.scrollerView];
        //初始化pangeController
        self.pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        [self addSubview:self.pageController];
        //配置scrollerview
        [self setUpScrollerView:imageURLS];
        //点击添加事件
        [self.pageController addTarget:self action:@selector(pageControllerClick) forControlEvents:UIControlEventValueChanged];
        
        if (imageURLS.count > 1) {
            //初始化定时器
            self.timer = [NSTimer scheduledTimerWithTimeInterval:Kinterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
    }
    
        return self;
}

//重新配置轮播图数据
- (void)setUpScrollerView:(NSArray *)imageURLS {
    
    if (imageURLS.count == 1) {
        
        self.scrollerView.contentSize = self.scrollerView.frame.size;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageURLS.lastObject]];
        [self.scrollerView addSubview:image];
        image.userInteractionEnabled = YES;
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation:)];
        [image addGestureRecognizer:tap];
        [self.timer setFireDate:[NSDate distantFuture]];
        
        return;
    }
    //设置滚动区域
    self.scrollerView.contentSize = CGSizeMake(self.frame.size.width * imageURLS.count + 2, 0);
    //从第一张开始真图显示
    self.scrollerView.contentOffset = CGPointMake(self.frame.size.width, 0);
    for (int i = 0; i < imageURLS.count + 2; i++) {
        //创建UIiamgeView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * self.frame.size.width), 0, self.frame.size.width, self.frame.size.height)];

        //创建点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation:)];
        [imageView addGestureRecognizer:tap];
        //打开交互
        imageView.userInteractionEnabled = YES;
        
        //第一张假图显示真实的最后一张
        if (i == 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS.lastObject]];
        //最后一张假图显示第一张真图
        }else if (i == imageURLS.count + 1) {
             [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS.firstObject]];
        }else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS[i - 1]]];
        }
        [self.scrollerView addSubview:imageView];
    }
    //设置pageController个数
    self.pageController.numberOfPages = imageURLS.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //滚动到最前面时回到真实的最后一张
    if (scrollView.contentOffset.x <= 0) {
        self.scrollerView.contentOffset = CGPointMake(self.frame.size.width *self.pageController.numberOfPages, 0);
    }
    
    //滚动到最后一张假图的时候，回到第一张真图
    if (scrollView.contentOffset.x >= (self.pageController.numberOfPages + 1)*self.frame.size.width) {
        self.scrollerView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    
    //修改page下标
    self.pageController.currentPage = self.scrollerView.contentOffset.x / self.frame.size.width - 1;
}

//用户拖拽时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //暂停定时器
    //[self.timer invalidate];//调用定时器无效，死亡，

    //暂停定时器，定时器没有暂停的方法，只能设置，开启时间
    [self.timer setFireDate:[NSDate distantFuture]];
}

//结束拖拽时再开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:Kinterval]];

}

- (void)timerAction {
    
    NSInteger index = self.scrollerView.contentOffset.x / self.frame.size.width + 1;
    
    
    
    //当结构体和对象连用时，不能直接赋值
    CGPoint offset = self.scrollerView.contentOffset;
    offset.x = self.frame.size.width *index;
    
    //修改偏移量
    [self.scrollerView setContentOffset:offset animated:YES];

}

//pageController 点击方法
- (void)pageControllerClick {

    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [UIView animateWithDuration:1 animations:^{
        
        self.scrollerView.contentOffset = CGPointMake((self.pageController.currentPage + 1) * self.frame.size.width , 0);

    } completion:^(BOOL finished) {
        //继续定时器
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:Kinterval]];
        
    }];
    
    
}
//图片点击方法
-(void)imageClickFouncation:(UIGestureRecognizer *)tap {

    NSInteger  index = self.scrollerView.contentOffset.x / self.frame.size.width;
    //先判断block是否实现
    if (self.imageClickBlock) {
        
        if (self.scrollerView.contentSize.width == self.frame.size.width) {
            self.imageClickBlock(index);
        }else {
            self.imageClickBlock(index -1);
        }
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
