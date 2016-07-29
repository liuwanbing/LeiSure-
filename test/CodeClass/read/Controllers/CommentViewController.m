//
//  CommentViewController.m
//  test
//
//  Created by lanou on 16/6/21.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentListModel.h"
#import "LoginViewController.h"



@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *backView;
//评论的textFieldView，用户输入的内容
@property (nonatomic, strong) UITextView *commentView;



@end

@implementation CommentViewController

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

//获取数据的方法
- (void)getData {
    
    [RequestTool requestWithType:POST URLString:GETCOMMENT_url parameter:@{@"contentid":self.commtendID} callBack:^(NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"**********%@",jsonDic);
        for (NSDictionary *tempDic  in jsonDic[@"data"][@"list"]) {
            CommentListModel *model = [[CommentListModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    
}
#warning ----从数组中某个地方开始
//上拉加载的方法，请求参数的改变，否则会重复的加载数据，在数据请求的参数中添加他的重新加载的位置，，从数组中个数的最大值开始加载，避免出现重复的数据
-(void)requestData {

    [RequestTool requestWithType:POST URLString:GETCOMMENT_url parameter:@{@"contentid":self.commtendID,@"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count]} callBack:^(NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *tempDic  in jsonDic[@"data"][@"list"]) {
            CommentListModel *model = [[CommentListModel alloc] init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    //布局下面的backview
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.backView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.backView];
    
#warning ---布局问题--------
    //布局textview,布局的时候，这个地方是放在backView上来布局的，所以你的所有坐标是根据backVIew的左上角坐标而定的
    self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 50, 50)];
    self.commentView.backgroundColor = [UIColor grayColor];
    [self.backView addSubview:self.commentView];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commentBtn.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 50);
    commentBtn.backgroundColor = [UIColor blueColor];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.tintColor = [UIColor whiteColor];
    [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside]; 
    [self.backView addSubview:commentBtn];
    
    //监听键盘弹出和隐藏的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新之前先把原有的数组中的数据清空，否则会出现大量的重复的数据
        [self.dataArray removeAllObjects];
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestData];
    }];

}

#warning -----回收键盘的方法-------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentView resignFirstResponder];

}

#warning ----键盘将要出现的方法------
- (void)keyBoardWillShow:(NSNotification *)note {
    
//    NSLog(@"字典的值为###%@",note);
    NSDictionary *userinfo = note.userInfo;
    NSValue *value = [userinfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    //将value转化为结构体，键盘的frame
    CGRect bounds = [value CGRectValue];
    
    NSString *durationStr = [userinfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    CGFloat duration = durationStr.floatValue;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.backView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - bounds.size.height - 50;
        self.backView.frame = frame;
    }];
}

//键盘要消失了
- (void)keyBoardWillHidden:(NSNotification *)note{
    
    //note 传过来的是一个字典，要用字典去接收他，可以先Nslog打印一下
    //    NSDictionary *userinfoDictionary = note.userInfo;
    //    NSString *durationStr = [userinfoDictionary objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    //    CGFloat duration = durationStr.floatValue;
    
    [UIView animateWithDuration:0.01 animations:^{
        self.backView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    }];
}

//点击评论的方法
- (void)clickComment {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]) {
        
        [RequestTool requestWithType:POST URLString:ADDCOMMENT_url parameter:@{@"contentid":self.commtendID,@"content":self.commentView.text,@"auth":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"][@"auth"] } callBack:^(NSData *data, NSError *error) {
            NSLog(@"发送成功");
#warning -----评论前删除之前的数据，评论后再刷新数据,避免没有刷新数据-----
            self.dataArray = nil;
            [self getData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        //清空textview的值，并且回收键盘
        self.commentView.text = nil;
        [self.view endEditing:YES];
        
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning pushing ----stroyBoard-------
            //推出的是导航控制器，如果直接推出视图控制器的话，会没有数据
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"loginNAVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    CommentListModel *model = self.dataArray[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.addTimeLabel.text = model.addtime_f;
    cell.userNameLabel.text = model.userinfo[@"uname"];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo[@"icon"]]];
    return cell;
}


//编辑self.tabbleview
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:YES animated:animated];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

            CommentListModel *model = self.dataArray[indexPath.row];
            [RequestTool requestWithType:POST URLString:DELCOMMENT_url parameter:@{@"contentid":model.contentid,@"commentid":self.commtendID,@"auth":[[NSUserDefaults standardUserDefaults]objectForKey:@"user"][@"auth"]} callBack:^(NSData *data, NSError *error) {
                //通过用户的id,评论的id内容的id作为参数，然后去删除所对应获得的模型里面的数组数据
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSNumber *reslut = jsonDic[@"result"];
                if (reslut.intValue == 0) {
                    NSLog(@"删除失败 ERROR:%@",jsonDic[@"data"][@"msg"]);
                }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                //删除这条数据 刷新表格
                [self.dataArray removeObject:model];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
            });
         }
    }];
}

#warning ----判断是否可以编辑，shi fou ke yi bian ji
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //先判断这条评论是不是自己的，是自己的才让编辑
    //取出自己的uid
    NSDictionary *userDic  = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSNumber *muUid = userDic[@"uid"];
    //取出这条评论的id
    CommentListModel *model = self.dataArray[indexPath.row];
    NSNumber *uid = model.userinfo[@"uid"];
    //如果uid和自己的uid相同说明是自己评论的
    if (muUid.integerValue == uid.integerValue) {
        return YES;
    }else {
        return NO;
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
