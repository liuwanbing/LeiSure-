//
//  DownloadTableViewController.m
//  test
//
//  Created by lanou on 16/6/23.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "DownloadTableViewCell.h"
#import "Downloadloader.h"
#import "DownloadListTableViewController.h"



@interface DownloadTableViewController ()

@end

@implementation DownloadTableViewController

- (void)clickMyDownload {
    DownloadListTableViewController *listVC = [[DownloadListTableViewController alloc ] init];
    [self.navigationController pushViewController:listVC animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在下载";
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"我的下载" style:UIBarButtonItemStylePlain target:self action:@selector(clickMyDownload)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //监听下载完成的通知
    [[NSNotificationCenter defaultCenter]addObserver:self.tableView selector:@selector(reloadData) name:downloadFinishNotification object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [DownloadloadManager sharedInstance].taskArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    Downloadloader *load = [DownloadloadManager sharedInstance].taskArray[indexPath.row];
    
    //返回cell时先用属性赋值 保证重用的cell不显示他下载对象的数据
    cell.nameLabel.text = load.fileName;
    cell.currentMB.text = load.currentMB;
    cell.totalMB.text = load.totalMB;
    cell.progressView.progress = load.proportion;
    //实现下载中的block
    load.loadingBlock = ^(int64_t currentBytes ,int64_t totalBytes) {
        cell.currentMB.text = [NSString stringWithFormat:@"%.1fMB",(float)currentBytes / 1024/ 1024];
    
        cell.totalMB.text = [NSString stringWithFormat:@"%.1fMB",(float)totalBytes / 1024 / 1024];
        cell.progressView.progress = (float)currentBytes / totalBytes;
    };
    //给暂停添加点击事件
    [cell.pauseBtn addTarget:self action:@selector(pauseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.pauseBtn.tag = 7000 + indexPath.row;
    [cell.pauseBtn setTitle:@"继续" forState:UIControlStateSelected];
    
        return cell;
}



//结束显示的方法 ，从屏幕上消失
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [DownloadloadManager sharedInstance].taskArray.count) {
        //取出对应的下载对象
        Downloadloader *load = [DownloadloadManager sharedInstance].taskArray[indexPath.row];
        //让下载对象的block置空，
        load.loadingBlock = nil;

        
    }
    
}


- (void)pauseBtnAction:(UIButton *)button {
    Downloadloader *load = [DownloadloadManager sharedInstance].taskArray[button.tag - 7000];
    if (load.isLoading) {
        [load suspend];
        button.selected = YES;
    } else {
    
        [load resume];
        button.selected = NO;
    }


}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         //取出对应的下载对象
        Downloadloader *load = [DownloadloadManager sharedInstance].taskArray[indexPath.row];
        // 取消下载
        [load cancel];
        //从数组删掉,从正在下载网址的数组中删掉这个网址
        [[DownloadloadManager sharedInstance].URLArray removeObject:load.URLString];
        //从任务数组中删除这个任务
        [[DownloadloadManager sharedInstance].taskArray removeObject:load];
        

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
