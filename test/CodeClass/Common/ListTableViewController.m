//
//  ListTableViewController.m
//  test
//
//  Created by lanou on 16/6/16.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListReadModel.h"
#import "ListTableViewCell.h"
#import "ReadDetailViewController.h"




@interface ListTableViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;




@end

@implementation ListTableViewController

- (NSMutableArray *)dataArray {
    
    @synchronized(self) {
        if (_dataArray == nil) {
            
            _dataArray = [NSMutableArray array];
        }
    }
    
    
    return _dataArray;

}

- (void)getData {
    
    [RequestTool requestWithType:POST URLString:@"http://api2.pianke.me/read/columns_detail" parameter:@{@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"typeid":[NSString stringWithFormat:@"%@",self.typeID],@"client":@"1",@"sort":@"addtime",@"limit":@10,@"version":@"3.0.2",@"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P0",@"start":@"0",@"start":@(self.dataArray.count)} callBack:^(NSData *data, NSError *error) {
    
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dictionary = dic[@"data"];
        NSArray *array = dictionary[@"list"];
        for (NSDictionary *tempDic in array) {
            ListReadModel *model = [[ListReadModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
        }
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];

        //上拉加载下拉刷新结束的方法
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    });
    
}];

}

//添加上拉，和下载控件
-(void) addHeaderAndFooter {
    
    //MJRefresh 3.0之后，给Scrollerview添加了两个属性，mj_header 和mj_footer 分别为头部和尾部
    //创建一个头部控件,提供两种头部控件，一个可设置动态图片，一个是普通的
    //创建时也提供两种方式 一种直接使用block回调
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //从网络加载数据，下拉加载是从数组中加载数据，下拉时不用将数组中的数据先清空，如果快速删除的话，会导致程序崩溃
        //写刷新数据的代码
        //删除就旧的数据
        [self.dataArray removeAllObjects];
        //请求新的数据
        [self getData];
    }];
    
    //一种是指定target和action
    //normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(下拉回调方法)];
    //添加到tableview上
    self.tableView.mj_header = normalHeader;
    
    
 /*   //使用动画的头部文件
    MJRefreshGifHeader *gif = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //删除就旧的数据
        [self.dataArray removeAllObjects];
        //请求新的数据
        [self getData];
    }];
    //同过For循环添加轮播图片
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        UIImage *image = [UIImage imageNamed:@"RK8CM`J5$}58[7KHD7CND(Y－1（被拖移）.tiff"];
        [imagesArray addObject:image];
    }
    
    //
    [gif setImages:imagesArray duration:1 forState:(MJRefreshStateRefreshing)];
    self.tableView.mj_header = gif;
    

    //隐藏最后更新的label
    gif.lastUpdatedTimeLabel.hidden = YES;
    //可以修改上面现实的文字
    [gif setTitle:@"有种你松手" forState: MJRefreshStatePulling];
  */
  
#pragma mark ----- 上拉加载，下拉刷新 ----
    
    //上拉控件
    MJRefreshAutoNormalFooter *normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    self.tableView.mj_footer = normalFooter;

    //上拉控件动画
/*    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
 
        //请求新的数据
        [self getData];
    }];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1; i < 60; i ++) {
        UIImage *iamge = [UIImage imageNamed:@"RK8CM`J5$}58[7KHD7CND(Y－1（被拖移）.tiff"];
        [imageArr addObject:iamge];
    }
    [gifFooter setImages:imageArr duration:3 forState:  MJRefreshStateRefreshing];

    self.tableView.mj_footer = gifFooter;
    
 */
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self addHeaderAndFooter];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阅读列表";
    //xib注册要用nib
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;

}

//返回分区头视图高度的方法
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    return 80;
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    ListReadModel *model = self.dataArray[indexPath.row];
  
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    
    [cell.headView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ListReadModel *model = self.dataArray[indexPath.row];
    ReadDetailViewController *detail = [[ReadDetailViewController alloc] init];
    //属性赋值
    detail.contentid = model.ID;
    detail.model = model;
    //实现跳转
    [self.navigationController pushViewController:detail animated:YES];


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
