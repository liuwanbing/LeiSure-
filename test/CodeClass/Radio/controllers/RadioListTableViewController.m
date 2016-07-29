//
//  RadioListTableViewController.m
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RadioListTableViewController.h"
#import "RadioDetailModel.h"
#import "RadioListTableViewCell.h"
#import "RadioPlayViewController.h"



@interface RadioListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation RadioListTableViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)requestData {
    
    [RequestTool requestWithType:POST URLString:KradioDetailList_URL parameter:@{@"radioid":self.radioID} callBack:^(NSData *data, NSError *error) {
    
        if (data == nil) {
            return ;
        }
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = jsonDic[@"data"];
        NSArray *array = dic[@"list"];
        for (NSDictionary *tempDic in array) {
            RadioDetailModel *model = [[RadioDetailModel alloc] init];
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
    self.title = @"电台列表";
   [self.tableView registerNib:[UINib nibWithNibName:@"RadioListTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    //上拉加载
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    //下拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestData];
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

//返回分区头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 320)];
    UIImageView *showImageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    showImageview1.backgroundColor = [UIColor redColor];
    [showImageview1 sd_setImageWithURL:[NSURL URLWithString:self.coverimg] placeholderImage:[UIImage imageNamed:@"05beb0eb5c645389930ac01cb7bacc9c.jpg"]];
    
    UIImageView *userImageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, 30, 30)];
    [userImageview2 sd_setImageWithURL:[NSURL URLWithString:self.coverimg] placeholderImage:[UIImage imageNamed:@"05beb0eb5c645389930ac01cb7bacc9c.jpg"]];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 130, 30)];
    titleLabel.text = self.titles;
    
    UIImageView *countImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(280, 167, 15, 15)];
    countImageView3.image = [UIImage imageNamed:@"u58"];
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 165, 80, 20)];
    countLabel.textColor = [UIColor grayColor];
    countLabel.text = self.count.stringValue;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 30)];
    detailLabel.text = self.desc;
    
    [view addSubview:detailLabel];
    [view addSubview:countLabel];
    [view addSubview:countImageView3];
    [view addSubview:titleLabel];
    [view addSubview:userImageview2];
    [view addSubview:showImageview1];
    
    return view;
}
//返回分区头视图高度的方法
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {

    return 240;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    RadioDetailModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%@",model.musicVisit];
    [cell.headView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    [cell.playMusicButtion addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (void)playButton:(UIButton *)button {
    
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    //通过cell获取点击的下标
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    //取出model
    RadioDetailModel *model = self.dataArray[index];
    NSLog(@"%@",model.musicUrl);
    
    //开始播放
    LOMusicManager *manager = [LOMusicManager sharedManager];
    [manager playMusicWithURLString:model.musicUrl];


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailModel *model = self.dataArray [indexPath.row];
    //开始播放
    [[LOMusicManager sharedManager]playMusicWithURLString:model.musicUrl];
    
    RadioPlayViewController *radioPlayVC = [[RadioPlayViewController alloc] init];
    
    radioPlayVC.selectIndex = indexPath.row;
    radioPlayVC.musicListArr = self.dataArray;
    
    
    [self.navigationController pushViewController:radioPlayVC animated:YES];
    


}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
