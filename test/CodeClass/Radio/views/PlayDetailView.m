//
//  PlayDetailView.m
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "PlayDetailView.h"
#import "PlayViewTableViewCell.h"
#import "MusicControllerView.h"
#import "Downloadloader.h"
#import "UIView YYHFrame.h"





@interface PlayDetailView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) MusicControllerView *musicController;

@end


@implementation PlayDetailView

- (instancetype)initWithFrame:(CGRect)frame musicList:(NSMutableArray *)musicListArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.dataArray = musicListArray;
        self.rootScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 64)];
        self.rootScroller.contentSize = CGSizeMake(3 * frame.size.width, 0);
        self.rootScroller.pagingEnabled = YES;
        self.rootScroller.delegate = self;
        [self addSubview:self.rootScroller];
        
        self.musicListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:(UITableViewStylePlain)];
        self.musicListTableView.delegate = self;
        self.musicListTableView.dataSource = self;
        [self.musicListTableView registerNib:[UINib nibWithNibName:@"PlayViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
        [self.rootScroller addSubview:self.musicListTableView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.rootScroller.contentSize.width / 2 - frame.size.width * 0.8 / 2, 30, frame.size.width * 0.8, frame.size.width * 0.8)];
        self.imageView.backgroundColor = [UIColor redColor];
        self.rootScroller.backgroundColor = [UIColor whiteColor];
        [self.rootScroller addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width, _imageView.frame.size.height + _imageView.frame.origin.y + 20, frame.size.width, 30)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"歌曲名称";
        [self.rootScroller addSubview:self.titleLabel];
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(2 * frame.size.width, 0, frame.size.width, frame.size.height)];
        [self.rootScroller addSubview:self.webView];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    //取出对应的cell赋值
    RadioDetailModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.userNameLabel.text = model.playInfo[@"userinfo"][@"uname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //判断是否正在播放
    if ([model.tingid isEqualToString:_currentModel.tingid]) {
        cell.isPlaying.hidden = NO;
    }else {
        
        cell.isPlaying.hidden = YES;

    }
    //给下载按钮添加事件
    [cell.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
#warning ----tag get ----
    cell.downloadBtn.tag = indexPath.row + 2000;
    
    
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioDetailModel *model = self.dataArray[indexPath.row];
    [[LOMusicManager sharedManager]playMusicWithURLString:model.musicUrl];
     [self.musicController.PlayAndPauseBtn setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateSelected];


}


//重写set方法，对控件进行赋值
- (void)setCurrentModel:(RadioDetailModel *)currentModel {

    _currentModel = currentModel;
    //图片赋值
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:currentModel.coverimg]];
    //标题赋值
    self.titleLabel.text = currentModel.title;
    
    //加载网页
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:currentModel.playInfo[@"webview_url"]]];
    [self.webView loadRequest:request];
    //刷新table
    [self.musicListTableView reloadData];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //判断是tableview还是rootScroll
    if (scrollView != self.rootScroller) {
        return;
    }
    if (self.offsetChanged) {
        self.offsetChanged(scrollView.contentOffset.x);
        
        
    }


}

- (void)downloadAction:(UIButton *)btn {

 //取出对应的model
    RadioDetailModel *model = self.dataArray[btn.tag - 2000];
    NSLog(@"%@",model.title);
//    Downloadloader *load = [[Downloadloader alloc] initWithURL:moedel.musicUrl saveName:moedel.title];
//    [load resume];
//
  Downloadloader *load =   [[DownloadloadManager sharedInstance]addDownloadWithURL:model.musicUrl saveName:model.title addResult:^(addResult result) {
        switch (result) {
            case addResultSuccess:
                NSLog(@"添加成功");
#warning ----tips class UIView YYHFrame.h--
                //这个地方使用的是封装的第三方类，UIView YYHFrame,提醒效果
                [self popMessageWithTitle:@"添加成功" postion:CENTER];
                break;
            case addResultDownloadFinish:
                NSLog(@"文件已下载");
                [self popMessageWithTitle:@"文件已经下载" postion: CENTER];
                break;
            default:
                NSLog(@"正在下载中");
                [self popMessageWithTitle:@"正在下载中" postion: CENTER];
                break;
        }
    }];
    [load resume];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
