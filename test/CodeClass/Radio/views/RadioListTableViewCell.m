//
//  RadioListTableViewCell.m
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RadioListTableViewCell.h"

@implementation RadioListTableViewCell
- (IBAction)playMusic:(id)sender {
    
    NSLog(@"开始播放音乐");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
