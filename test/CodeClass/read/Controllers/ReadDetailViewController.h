//
//  ReadDetailViewController.h
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListReadModel.h"

@interface ReadDetailViewController : UIViewController

//文章ID
@property (nonatomic, copy) NSString *contentid;
#warning ---mo xing chuan mo xing----
@property (nonatomic, strong) ListReadModel *model;

@end
