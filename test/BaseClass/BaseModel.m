//
//  BaseModel.m
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {


}


+ (instancetype)modelWithDic:(NSDictionary *)dic {

    NSLog(@"子类未实现配置model的方法");
    return nil;
    

}
@end
