//
//  RadioListTableViewController.h
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioListTableViewController : UITableViewController

//电台类型ID
@property (nonatomic, copy) NSString  *radioID;

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *titles;

@property (nonatomic, strong) NSDictionary *userinfo;

@end
