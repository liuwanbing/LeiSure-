//
//  ListReadModel.m
//  test
//
//  Created by lanou on 16/6/16.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ListReadModel.h"

@implementation ListReadModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
        
    }

}

@end
