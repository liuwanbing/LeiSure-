//
//  RadioTypeTableViewCell.m
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RadioTypeTableViewCell.h"

@implementation RadioTypeTableViewCell

- (void)setContentWithModel:(RadioTypeModel *)model {

    self.titelLabel.text = model.title;
    self.authorLabel.text = model.userinfo[@"uname"];
    self.countLabel.text = model.count.stringValue;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"u=3410367871,2246389702&fm=116&gp=0.jpg"]];
    self.contentLabel.text = model.desc;
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
