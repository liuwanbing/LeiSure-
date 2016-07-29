//
//  DownloadTableViewCell.h
//  test
//
//  Created by lanou on 16/6/23.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *currentMB;
@property (weak, nonatomic) IBOutlet UILabel *totalMB;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

@end
