//
//  ReadDetailViewController.m
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"
#import "DBSingleTon.h"





@interface ReadDetailViewController ()



@end

@implementation ReadDetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    self.title = @"详情";
#warning -----css autoLayout---自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加收藏按钮
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(CollectionBtnAction)];
    //分享按钮
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享 (1)"] style:UIBarButtonItemStylePlain target:self action:@selector(sharedBtnAction)];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"评论 (1)"] style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
    NSArray *items = @[collectItem,shareItem,commentItem];
    self.navigationItem.rightBarButtonItems = items;

    
    // Do any additional setup after loading the view.
}

//返回上一个界面的方法
- (void)back {

    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];

}

//收藏按钮的方法
- (void)CollectionBtnAction {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"] == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNAVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        
        [[DBSingleTon sharedInstance] createDB];
        NSString *modelid = [[DBSingleTon sharedInstance]selectWithID:self.model.ID];
        NSLog(@"查询的结果是%@",modelid);

        if ([modelid isEqualToString:self.model.ID]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"文章已经收藏过了，点击确定删除收藏" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[DBSingleTon sharedInstance] deleteDataWithID:modelid];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sure];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否确定收藏" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[DBSingleTon sharedInstance] insertDataWitnModel:self.model];

            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sure];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

//分享按钮的方法
- (void)sharedBtnAction {
    
    NSLog(@"%@",[UIImage imageNamed:@"icon"]);
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"u=707949111,1212900127&fm=116&gp=0.jpg"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

//评论按钮的方法
- (void)comment {
        CommentViewController *commentVc = [[CommentViewController alloc] init];
        commentVc.commtendID = self.contentid;
    [self.navigationController pushViewController:commentVc animated:YES];
}

//请求数据
- (void)requestData {
    
    [RequestTool requestWithType:POST URLString:KreadDetail_URL parameter:@{@"contentid":self.contentid} callBack:^(NSData *data, NSError *error) {
        //判断是否请求到数据
        if (data == nil) {
            return ;
        }
        //json解析
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
#warning ----------****----------------
            //请求数据成功才创建webView
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:webView];
            //工程包地址
            NSString *cssPath = [[NSBundle mainBundle]resourcePath];
            //强大的html+css让人膜拜 但是，只有html就强大不了，如果我们直接让webview加载html是没有布局的，不适配屏幕 我们得给它指定一个css让它去布局，
            //和直接加载网页是不同的，网页自带css 所以不需要我们去指定
            //加载html内容
            [ webView loadHTMLString:jsonDic[@"data"][@"html"] baseURL:[NSURL fileURLWithPath:cssPath]];
    
        });
    }];

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
