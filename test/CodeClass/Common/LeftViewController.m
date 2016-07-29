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




@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建彩虹layer
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    //设置frame
    layer.frame = self.view.frame;
    //彩虹的颜色
    layer.colors = @[(id)[UIColor greenColor].CGColor,(id)[UIColor blueColor].CGColor];
    //添加到你要添加的地方
    [self.view.layer addSublayer:layer];

    //将所有的类名放到数组中
    self.classArrays = [NSMutableArray array];
    [self.classArrays addObject:@"ReadViewController"];
    [self.classArrays addObject:@"RadioViewController"];
    [self.classArrays addObject:@"TopicViewController"];
    [self.classArrays addObject:@"ProductViewController"];


    //初始化数组
    self.titles = @[@"阅读",@"电台",@"话题",@"良品"];

    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height - 160)) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftCell"];

    [self.view addSubview:self.tableView];

    //选中第一行
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];


    //初始化用户头像
    self.userImage = [[UIImageView alloc] initWithFrame:(CGRectMake(10, 40, 50, 50))];
    [self.userImage setImage:[UIImage imageNamed:@"userDefult"]];
    [self.view addSubview:self.userImage];
    //登陆按钮
    UIButton *loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];

    loginButton.tag = 909;
    loginButton.frame = CGRectMake(65, 40, 80, 50);
    [loginButton setTitle:@"登陆/注册" forState:(UIControlStateNormal)];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginButton];



}

//登陆按钮方法
- (void)loginAction{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"骚年 你要注销?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            //删除用户数据
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            //把登陆按钮标题修改回原来的
            UIButton *loginBtn = [self.view viewWithTag:909];
            [loginBtn setTitle:@"登陆/注册" forState:(UIControlStateNormal)];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"不要吧" style:(UIAlertActionStyleDefault) handler:nil]];
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
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
        NSLog(@"创建了一个新的控制器");

    }
    //切换主试图控制器
    [delegate.drawerVC setMainViewController:NAVC];
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
