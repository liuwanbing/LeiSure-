//
//  RadioPlayViewController.m
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "PlayDetailView.h"
#import "MusicControllerView.h"
#import "LOMusicManager.h"
#import "DownloadTableViewController.h"

@interface RadioPlayViewController ()<LOMusicManagerDelegate>

//上面部分用来显示复合部分
@property (nonatomic,strong)PlayDetailView *detailView;

//下面部分的控制按钮
@property (nonatomic, strong)MusicControllerView *musicController;


@end

@implementation RadioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"正在下载" style:UIBarButtonItemStylePlain target:self action:@selector(clickDownload)];
    self.navigationItem.rightBarButtonItem = leftBtn;
    
    [LOMusicManager sharedManager].delegate = self;
    
    self.detailView = [[PlayDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) musicList:self.musicListArr];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.detailView];
    
    //显示当前正在播放的model
    [self.detailView setCurrentModel:self.musicListArr[_selectIndex]];
    
#warning -----布局按钮视图-----
    //加载按钮视图
    self.musicController = [[NSBundle mainBundle]loadNibNamed:@"MusicControllerView" owner:self options:nil].lastObject;
    self.musicController.frame = CGRectMake(0, self.view.frame.size.height - 125, self.view.frame.size.width,125);
    [self.view addSubview:self.musicController];
    
    //添加点击事件
    //上一曲
    [self.musicController.previousBtn addTarget:self action:@selector(previousBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //下一曲
    [self.musicController.nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //播放暂停
    [self.musicController.PlayAndPauseBtn addTarget:self action:@selector(PlayAndPauseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //slider
    [self.musicController.slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    
    __block RadioPlayViewController *weakSelf = self;
    //通过block获取detailView偏移量
    self.detailView.offsetChanged = ^(CGFloat offsetx) {
    
        NSInteger index = offsetx / self.view.frame.size.width;
        for (int i = 0; i < 3; i ++) {
            UIView *view = [weakSelf.musicController viewWithTag:100 + i];
            if (index == i) {
                view.backgroundColor = [UIColor greenColor];
                
            }else {
            
                view.backgroundColor = [UIColor whiteColor];
    
            }
        }
    };
    
    
    // Do any additional setup after loading the view.
}
//上一曲
- (void)previousBtnAction {
    
    if (self.selectIndex == 0) {
        self.selectIndex = self.musicListArr.count - 1 ;
    }else {
        self.selectIndex -= 1;
    
    }
    RadioDetailModel *model = self.musicListArr[_selectIndex];
    [[LOMusicManager sharedManager]playMusicWithURLString:model.musicUrl];
    [self.musicController.PlayAndPauseBtn setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateSelected];
    [self.detailView setCurrentModel:model];
    
}

//下一曲
- (void)nextBtnAction {
    
    //如果已经到了最后一个 回到第一个
    if (self.selectIndex == self.musicListArr.count - 1) {
        self.selectIndex = 0;
    }else {
        self.selectIndex += 1;
    }
    
    //取出下一model
    RadioDetailModel *model = self.musicListArr[_selectIndex];
    //播放音频
    [[LOMusicManager sharedManager]playMusicWithURLString:model.musicUrl];
    //设置播放按钮的图片
    [self.musicController.PlayAndPauseBtn setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateSelected];
    //刷新界面
    [self.detailView setCurrentModel:model];
    

}

- (void)PlayAndPauseBtnAction {
    //判断当前是播放还是暂停
    if ([LOMusicManager sharedManager].isPlay) {
        [[LOMusicManager sharedManager]pause];
        //设置图片为播放按钮
    [self.musicController.PlayAndPauseBtn setImage:[UIImage imageNamed:@"player_play@2x"] forState:UIControlStateSelected];
        
    }else {
    
        [[LOMusicManager sharedManager]play];
        //设置图片为暂停图片
        //
            [self.musicController.PlayAndPauseBtn setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateSelected];
        
    }


}

//进度条
- (void)sliderAction{
//设置当前播放的时间
    [[LOMusicManager sharedManager].AV seekToTime:CMTimeMake(self.musicController.slider.value, 1)];



}

-(void)currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime {
    self.musicController.slider.maximumValue = totalTime;
    self.musicController.slider.value = currentTime;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击我的下载的方法
-(void)clickDownload {
    DownloadTableViewController *downloadVC = [[DownloadTableViewController alloc] init];
    
    [self.navigationController pushViewController:downloadVC animated:YES];


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
