//
//  RegistViewController.h
//  test
//
//  Created by lanou on 16/6/21.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个用于从注册界面传值的block，block有两个参数，一个参数是用户名，一个参数是密码，可以根据需要选择穿过来的值
typedef void(^registerFinishBlock) (NSString *email,NSString *password);

@interface RegistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;

//注册成功的block
@property (nonatomic,copy) registerFinishBlock registerOK;

@end
