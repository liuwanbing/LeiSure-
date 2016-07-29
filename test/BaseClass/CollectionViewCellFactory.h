//
//  CollectionViewCellFactory.h
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"

@interface CollectionViewCellFactory : NSObject

//统一创建方法 ，由于cell需要重用，得把重用时需要的参数都传进来
+ (BaseCollectionViewCell *)CellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath;


@end
