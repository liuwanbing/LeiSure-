//
//  CollectionViewCellFactory.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "CollectionViewCellFactory.h"

@implementation CollectionViewCellFactory

+ (BaseCollectionViewCell *)CellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath {
    
    //创建cell 先从重用池中寻找
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;


}


@end
