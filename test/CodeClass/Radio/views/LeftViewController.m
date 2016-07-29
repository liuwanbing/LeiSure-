//
//  LeftViewController.m
//  leiSure
//
//  Created by yuanhu on 16/6/13.
//  Copyright © 2016年 yuanhu. All rights reserved.
//

#import "LeftViewController.h"

#import "TopicViewController.h"
#import "ProductViewController.h"
#import "RadioViewController.h"
#import "CollectionTableViewController.h"
#import "DownloadListTableViewController.h"
#import "LoginViewController.h"
#import "DBSingleTon.h"




@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
//页面选择用的tableView
@property (nonatomic,strong) UITableView *tableView;

//标题数组
@property (nonatomic,strong) NSArray *titles;
//存放所有的控制器类
@property (nonatomic,strong) NSMutableArray *classArrays;

//当前选中的控制器下标
@property (nonatomic,assign) NSInteger currentIndex;
//用户头像
@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic, strong) NSArray *imageArray;



@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    //创建彩虹layer
//    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
//    //设置frame
//    layer.frame = self.view.frame;
//    //彩虹的颜色
//    layer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor blueColor].CGColor];
//    //添加到你要添加的地方
//    [self.view.layer addSublayer:layer];

    self.view.backgroundColor = [UIColor colorWithRed:115 / 255.0 green:201 / 255.0 blue:230 /255.0  alpha:1];

    //将所有的类名放到数组中
    self.classArrays = [NSMutableArray array];
    [self.classArrays addObject:@"ReadViewController"];
    [self.classArrays addObject:@"RadioViewController"];
    [self.classArrays addObject:@"TopicViewController"];
    [self.classArrays addObject:@"ProductViewController"];


    //初始化数组
    self.titles = @[@"阅读",@"电台",@"话题",@"良品"];
    self.imageArray = @[@"read.jpg",@"radio",@"topic.jpg",@"product.jpg"];

    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height - 160)) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:209 / 255.0 blue:248 /255.0  alpha:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftCell"];

    [self.view addSubview:self.tableView];

    //选中第一行
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];


    //初始化用户头像
    self.userImage = [[UIImageView alloc] initWithFrame:(CGRectMake(20, 40, 60, 60))];
    [self.userImage setImage:[UIImage imageNamed:@"u=707949111,1212900127&fm=116&gp=0.jpg"]];
    [self.view addSubview:self.userImage];
    //登陆按钮
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];

    loginButton.tag = 909;
    loginButton.frame = CGRectMake(80, 40, 120, 50);
    [loginButton setTitle:@"登陆/注册" forState:(UIControlStateNormal)];
    loginButton.tintColor = [UIColor whiteColor];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginButton];
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    collectionBtn.tintColor = [UIColor whiteColor];
    [collectionBtn setImage:[UIImage imageNamed:@"收藏 (1)"] forState:UIControlStateNormal];
    collectionBtn.frame = CGRectMake(30, 110, 40, 40);
    [collectionBtn addTarget:self action:@selector(collection) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionBtn];
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    downloadBtn.tintColor = [UIColor whiteColor];
    [downloadBtn setImage:[UIImage imageNamed:@"下载 (1)"] forState:UIControlStateNormal];
    downloadBtn.frame = CGRectMake(100, 108, 45, 45);
    [downloadBtn addTarget:self action:@selector(downloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadBtn];




}
//收藏的按钮
- (void) collection {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]) {
        
        [[DBSingleTon sharedInstance]selectAllData];
        CollectionTableViewController *collectionVC = [[CollectionTableViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:collectionVC];
        [self presentViewController:naVC animated:YES completion:nil];

    }else {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNAVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
    
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    
    
    }
    
  
}
//下载按钮的方法
- (void)downloadBtnAction {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]) {
        
        DownloadListTableViewController *downVC = [[DownloadListTableViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:downVC];
        [self presentViewController:naVC animated:YES completion:nil];
        
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNAVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    


}

//登陆按钮方法
- (void)loginAction{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否确定注销" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            //删除用户数据
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            //把登陆按钮标题修改回原来的
            UIButton *loginBtn = [self.view viewWithTag:909];
            [loginBtn setTitle:@"登陆/注册" forState:(UIControlStateNormal)];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    //获取storyboard
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //获取管理者登陆界面的导航控制器
    UINavigationController *NAVC = [story instantiateViewControllerWithIdentifier:@"loginNAVC"];
    //跳转至登陆界面
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentIndex == indexPath.row) {
        return;
    }
    self.currentIndex = indexPath.row;

    //取出对应的类名
    NSString *className = self.classArrays[indexPath.row];

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    //从字典中找对应的控制器
    UINavigationController *NAVC = [delegate.viewControllerDic objectForKey:className];
    //如果取不到 就初始化
    if (NAVC == nil) {

        UIViewController *VC = [[NSClassFromString(className) alloc] init];
        NAVC = [[UINavigationController  alloc] initWithRootViewController:VC];

        //添加一个按钮
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:delegate action:@selector(openDrawer)];
        VC.navigationItem.leftBarButtonItem = leftItem;

        //把初始化来的控制器 放入字典
        [delegate.viewControllerDic setObject:NAVC forKey:className];
      

    }
    //切换主试图控制器
    [delegate.drawerVC setMainVIewController:NAVC];
}

//视图将要显示的时候修改登陆按钮的标题
-(void)viewWillAppear:(BOOL)animated{
    //取出当前用户信息
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    //如果dic不为空说明已经登陆了 修改头像 和按钮标题
    if (dic) {

        UIButton *loginBtn = [self.view viewWithTag:909];
        [loginBtn setTitle:dic[@"uname"] forState:(UIControlStateNormal)];
    }
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
