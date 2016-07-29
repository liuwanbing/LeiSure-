//
//  RadioListTableViewCell.h
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *playMusicButtion;

@end
