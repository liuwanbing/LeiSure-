//
//  TopciDetailTableViewController.h
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TopciDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic, strong) NSNumber * addtime;
@property (nonatomic, copy) NSString  * addtime_f;
@property (nonatomic, copy) NSString * titles;
@property (nonatomic, copy) NSString * coverimg;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) NSDictionary *counterList;
@property (nonatomic, strong) NSDictionary *userinfos;



@end
