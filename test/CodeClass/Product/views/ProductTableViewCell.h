//
//  ProductTableViewCell.h
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//立即购买按钮
@property (weak, nonatomic) IBOutlet UIButton *plankBtn;

@end
