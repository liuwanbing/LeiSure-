//
//  CollectionTableViewController.m
//  test
//
//  Created by lanou on 16/6/22.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "CollectionTableViewController.h"
#import "DBSingleTon.h"
#import "ListTableViewCell.h"
#import "ListReadModel.h"
#import "ReadDetailViewController.h"




@interface CollectionTableViewController ()

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation CollectionTableViewController

//- (NSMutableArray *)dataArray {
//
//    if (_dataArray == nil) {
//        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//
//    return _dataArray;
//
//}
//


- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"我的收藏";
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    self.dataArray = [[DBSingleTon sharedInstance]selectAllData];
 
    
    NSLog(@"数组中的值为：%@",self.dataArray);
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationController.title = @"我的收藏";

    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    
    ListReadModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    [cell.headView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 180;
}

//布局分区头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(10, 22, 40, 30);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [headerView addSubview:backBtn];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [titleBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 30, 22, 60, 30);
    [headerView addSubview:titleBtn];

    return headerView;
}

////返回tableView的头视图高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    return 64;
//
//}

- (void)back {

    [self dismissViewControllerAnimated:YES completion:nil];

}
#warning ----this action unnecessary when delete row ------
//编辑self.tabbleview
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:YES animated:animated];
//    
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
////        [self.dataArray removeObject:[DBSingleTon sharedInstance].model];

// Override to support conditional editing of the table view.




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ListReadModel *model = self.dataArray[indexPath.row];
        [self.dataArray removeObject:model];
        [[DBSingleTon sharedInstance]deleteDataWithID:model.ID];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }   
}

//点击调到详情界面的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ReadDetailViewController *readVC = [[ReadDetailViewController alloc] init];
    ListReadModel *model = self.dataArray[indexPath.row];
    readVC.contentid = model.ID;

    [self.navigationController pushViewController:readVC animated:YES];
    
    

}
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
