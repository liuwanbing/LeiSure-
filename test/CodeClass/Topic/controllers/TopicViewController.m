//
//  TopicViewController.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListTableViewCell.h"
#import "TopicListModel.h"
#import "TopciDetailTableViewController.h"

@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *segment;


@end

@implementation TopicViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (void)requestData {
    
    [RequestTool requestWithType:POST URLString:KtopicList_URL parameter:@{@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"client":@"1",@"sort":@"addtime",@"limit":@(10),@"version":@"3.0.2",@"start":@0,@"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P0"} callBack:^(NSData *data, NSError *error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];        
        for (NSDictionary *tempDic in dic[@"data"][@"list"]) {
            TopicListModel *model = [[TopicListModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
        }
        NSLog(@"%ld",self.dataArray.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    }];
    
}

- (void)requestHotData {
    
    [RequestTool requestWithType:POST URLString:KtopicList_URL parameter:nil callBack:^(NSData *data, NSError *error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        // NSLog(@"%@",dic);
        for (NSDictionary *tempDic in dic[@"data"][@"list"]) {
            TopicListModel *model = [[TopicListModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)layoutTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
- (void)loadDataAndGetNewData {

    if (self.segment.selectedSegmentIndex == 0) {
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.dataArray removeAllObjects];
            [self requestData];
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestData];
        }];
    }else {

        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.dataArray removeAllObjects];
            [self requestHotData];
        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestHotData];
        }];
    }
   

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSegmentM];
    self.navigationItem.title = @"话题";
    [self layoutTableView];
    [self requestData];
    self.view.backgroundColor = [UIColor blueColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    [self loadDataAndGetNewData];
    

    // Do any additional setup after loading the view.
}


//点击分段控件改变热门和最新的方法
- (void)clickAction:(UISegmentedControl *)seg {
    
    if (seg.selectedSegmentIndex == 0) {
        [self.dataArray removeAllObjects];
        [self requestData];

    }else {
        [self.dataArray removeAllObjects];
        [self requestHotData];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

//设置segmentController
- (void)setSegmentM{
    
    NSArray *array = @[@"New",@"Hot"];
    UISegmentedControl *segmentController = [[UISegmentedControl alloc] initWithItems:array];
    segmentController.frame = CGRectMake(145, 10, 140, 30);
    [segmentController addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventValueChanged];
    segmentController.selectedSegmentIndex = 0 ;
    self.segment = segmentController;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    [headerView addSubview:self.segment];
    //[self.view addSubview:headerView];
    return headerView;

}
//返回分区头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 80;

}

//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    TopicListModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.headerView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"05beb0eb5c645389930ac01cb7bacc9c.jpg"]];
    cell.contentLabel.text = model.content;
    //cell.timeLabel.text = model.addtime.stringValue;//类型不匹配会崩溃，而且一直崩在main函数
    cell.timeLabel.text = model.addtime_f;
    cell.conmentCountLabel.text = [NSString stringWithFormat:@"%@", model.counterList[@"view"]];
    //cell.conmentCountLabel.text = model.counterList[@"view"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

//页面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopciDetailTableViewController *detailVC = [story instantiateViewControllerWithIdentifier:@"topDetail"];
    //获取模型
    TopicListModel *ListModel = self.dataArray[indexPath.row];
    detailVC.addtime = ListModel.addtime;
    detailVC.addtime_f = ListModel.addtime_f;
    detailVC.titles = ListModel.title;
    detailVC.coverimg = ListModel.coverimg;
    detailVC.content  = ListModel.content;
    detailVC.counterList = ListModel.counterList;
    detailVC.userinfos = ListModel.userinfo;
    [self.navigationController pushViewController:detailVC animated:YES];

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
