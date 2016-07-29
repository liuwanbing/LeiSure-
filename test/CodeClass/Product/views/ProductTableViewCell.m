//
//  ProductTableViewCell.m
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell


- (IBAction)buyButtonAction:(id)sender {
    NSLog(@"立即购买");
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
