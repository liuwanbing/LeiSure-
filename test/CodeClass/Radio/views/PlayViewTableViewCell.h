//
//  PlayViewTableViewCell.h
//  test
//
//  Created by lanou on 16/6/20.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *isPlaying;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;


@end
