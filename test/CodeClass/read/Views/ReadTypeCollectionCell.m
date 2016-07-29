//
//  ReadTypeCollectionCell.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ReadTypeCollectionCell.h"
#import "ReadTypeModel.h"




@implementation ReadTypeCollectionCell

- (void)setContentWithModel:(ReadTypeModel *)model {

    self.nameLabel.text = model.name;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.enname];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
