//
//  RadioViewController.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioTypeModel.h"
#import "CarouselView.h"
#import "RadioTypeTableViewCell.h"
#import "RadioListTableViewController.h"



@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation RadioViewController

- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电台";
    self.view.backgroundColor = [UIColor greenColor];
    [self requestData];
    [self createSubViews];
    
    
    
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"电台" style:UIBarButtonItemStylePlain target:self action:nil];

//    self.navigationItem.leftBarButtonItem = item;

    
   
    // Do any additional setup after loading the view.
}

- (void)requestData {

    [RequestTool requestWithType:POST URLString:KradioList_URL parameter:nil callBack:^(NSData *data, NSError *error) {
        if (data == nil) {
            return ;
        }
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //轮播图网址数组
        NSMutableArray *imageURLS = [NSMutableArray array];
        for (NSDictionary *dic in jsonDic[@"data"][@"carousel"]) {
            [imageURLS addObject:dic[@"img"]];
            
        }
        
        //解析Model
        for (NSDictionary *dic in jsonDic[@"data"][@"alllist"]) {
            RadioTypeModel *model = [[RadioTypeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
            
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{

            //判断是否已经有了headerview
            if (self.tableView.tableHeaderView == nil) {
                //初始化轮播图
                CarouselView *carousel = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KscreenHeight - KscreenWidth - 5 -100) iamgeURLS:imageURLS];
                //设置为tableVieHeaderView
                self.tableView.tableHeaderView = carousel;

            }
            
            [self.tableView reloadData];

            
        });
    }];



}

-(void)loadMoreData {
    
    [RequestTool requestWithType:POST URLString:KradioMoreList_URL parameter:@{@"start":@(self.dataSourceArray.count)} callBack:^(NSData *data, NSError *error) {
        if (data == nil) {
            return ;
        }
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *dic in jsonDic[@"data"][@"list"]) {
            RadioTypeModel *model = [[RadioTypeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        
        //回主线程和结束刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    }];


}
- (void)createSubViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    //添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //调用加载更多的方法
        [self loadMoreData];
    }];
    
    //添加下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMoreData];
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.dataSourceArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取出对应的model
    RadioTypeModel *model = self.dataSourceArray[indexPath.row];
    RadioListTableViewController *radioListVC = [[RadioListTableViewController alloc] init];
    radioListVC.radioID = model.radioid;
    radioListVC.titles = model.title;
    radioListVC.coverimg = model.coverimg;
    radioListVC.desc = model.desc;
    radioListVC.userinfo = model.userinfo;
    radioListVC.count = model.count;
    //可以通过模型传值，将这个模型赋值给详情的模型，就是你要跳转的那个界面的模型
    
    [self.navigationController pushViewController:radioListVC animated:YES];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    [cell setContentWithModel:self.dataSourceArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;

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
