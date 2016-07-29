//
//  LoginViewController.m
//  test
//
//  Created by lanou on 16/6/21.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "LeftViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

//登录的方法
- (IBAction)LoginAction:(id)sender {
    //直接请求登录的接口
    [RequestTool requestWithType:POST URLString:LOGIN_URL parameter:@{@"email":self.emailTextField.text,@"passwd":self.passwordTextField.text} callBack:^(NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",jsonDic);
        NSNumber *result = jsonDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result.intValue == 1) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                    //获取到页面之前来保存用户信息
                    [[NSUserDefaults standardUserDefaults]setObject:jsonDic[@"data"] forKey:@"user"];
                    //立即保存
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:UIAlertControllerStyleAlert ];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"请重新登录" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}


- (IBAction)registAction:(id)sender {
    
}


- (IBAction)backVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RegistViewController *registerVC = [segue destinationViewController];
    registerVC.registerOK = ^(NSString *email,NSString *password) {
        self.passwordTextField.text = password;
        self.emailTextField.text = email;
    };
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
