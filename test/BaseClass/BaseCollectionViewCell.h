//
//  BaseCollectionViewCell.h
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"


@interface BaseCollectionViewCell : UICollectionViewCell

//控件赋值的方法
- (void)setContentWithModel:(BaseModel *)model;


@end
