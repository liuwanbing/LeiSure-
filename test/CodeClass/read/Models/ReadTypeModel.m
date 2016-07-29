//
//  ReadTypeModel.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ReadTypeModel.h"

@implementation ReadTypeModel
+ (instancetype)modelWithDic:(NSDictionary *)dic {

    ReadTypeModel *mode = [[ReadTypeModel alloc] init];
    [mode setValuesForKeysWithDictionary:dic];
    
    return mode;

}

@end
