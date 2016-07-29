//
//  TopciDetailTableViewController.m
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "TopciDetailTableViewController.h"
#import "TopicDetailModel.h"
#import "TopicDetailTableViewCell.h"

@interface TopciDetailTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation TopciDetailTableViewController

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}


//只看楼主
- (IBAction)onlyLookTheHoster:(id)sender {
    
    NSLog(@"只看楼主");
    
}
//顺序浏览评论
- (IBAction)sequenceScanComment:(id)sender {
    NSLog(@"顺序浏览评论");
}
//热门评论
- (IBAction)hotComment:(id)sender {
    NSLog(@"热门评论");

}


- (void)getData {

    [RequestTool requestWithType:POST URLString:KtopicDetail_URL parameter:@{@"contentid":@"555e965895f95b05320001a3"} callBack:^(NSData *data, NSError *error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
        for (NSDictionary *tempDic in dic[@"data"][@"commentlist"]) {
            TopicDetailModel *model = [[TopicDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
            
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        });
    }];
}

- (void)setValueToHeaderView {
    
    self.contentLabel.text = self.titles;
    self.titleLabel.text = self.content;
    self.nameLabel.text = self.userinfos[@"uname"];
    self.timeLable.text = self.addtime_f;
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:self.coverimg] placeholderImage:[UIImage imageNamed:@"05beb0eb5c645389930ac01cb7bacc9c.jpg"]];
    [self.userIcon  sd_setImageWithURL:[NSURL URLWithString:self.userinfos[@"icon"]]];
    
    


}
//上拉加载，下拉刷新的方法
- (void)PullOnloadingData {

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self getData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setValueToHeaderView];
    [self PullOnloadingData];
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

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    TopicDetailModel *model = self.dataArray[indexPath.row];
    [cell.userIconImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo[@"icon"]] placeholderImage:[UIImage imageNamed:@"u=707949111,1212900127&fm=116&gp=0.jpg"]];
    cell.userNameLable.text = model.userinfo[@"uname"];
    cell.timeLabel.text = model.addtime_f;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.cmtnum];

    
    return cell;
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
