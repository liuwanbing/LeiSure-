//
//  ProductViewController.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductTableViewCell.h"
#import "WebViewController.h"


@interface ProductViewController ()<UITableViewDelegate,UITableViewDataSource>

//定义一个tableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation ProductViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}



- (void)requestData {
    
    [RequestTool requestWithType:POST URLString:KproductList_URL parameter:@{@"start":@0,@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"limit":@10,@"auth":@"",@"version":@"3.0.2"} callBack:^(NSData *data, NSError *error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *tempDic in dic[@"data"][@"list"]) {
            ProductListModel *model = [[ProductListModel alloc] init];
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




- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self layoutTableView];

    self.view.backgroundColor = [UIColor redColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self requestData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self requestData];
    }];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    ProductListModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.headView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"05beb0eb5c645389930ac01cb7bacc9c.jpg"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.plankBtn addTarget:self action:@selector(plankBtn:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//布局tableview
- (void)layoutTableView {

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    

}

- (void)plankBtn:(UIButton *)button {
    
//    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
//    //通过cell获取点击的下标
//    NSInteger index = [self.tableView indexPathForCell:cell].row;
//    //取出model
//    RadioDetailModel *model = self.dataArray[index];
//    NSLog(@"%@",model.musicUrl);
//    
//    //开始播放
//    LOMusicManager *manager = [LOMusicManager sharedManager];
//    [manager playMusicWithURLString:model.musicUrl];

    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.index = index;
    webVC.array = self.dataArray;
    [self.navigationController pushViewController:webVC animated:YES];
//    [self.view addSubview:webView];




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
