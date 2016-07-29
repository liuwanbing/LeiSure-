//
//  TopicListTableViewCell.h
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conmentCountLabel;


@end
