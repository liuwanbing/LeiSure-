//
//  RegistViewController.m
//  test
//
//  Created by lanou on 16/6/21.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
- (IBAction)registAction:(id)sender {
    //获取用户输入的数据
    NSDictionary *parament = @{@"email":self.emailTextField.text,@"passwd":self.passwordTextField.text,@"uname":self.userNameTextField.text,@"gender":@(self.genderSegment.selectedSegmentIndex)};
    
    //请求注册接口
    [RequestTool requestWithType:POST URLString:REGIST_URL parameter:parament callBack:^(NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",jsonDic);
//        NSLog(@"%@",jsonDic[@"data"][@"msg"]);
        NSNumber *result = jsonDic[@"result"];
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (result.intValue == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:jsonDic[@"data"][@"msg"] preferredStyle:(UIAlertControllerStyleAlert)];
                [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:(UIAlertActionStyleDefault) handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else {
            //注册成功
                //如果实现了block就回调block
                NSLog(@"注册成功");
                if (self.registerOK) {
                    //利用block 产值，从后一个界面传到前一个界面
                    self.registerOK (self.emailTextField.text,self.passwordTextField.text);
                }
                //返回上级界面
                [self.navigationController popToRootViewControllerAnimated:YES];
            
            }
        });
    
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
