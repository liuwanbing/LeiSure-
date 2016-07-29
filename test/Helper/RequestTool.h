//
//  RequestTool.h
//  test
//
//  Created by lanou on 16/6/14.
//  Copyright © 2016年 刘万兵. All rights reserved.
//


//请求类型.使用枚举来选择选用什么请求方式

typedef enum{
    
    GET,
    POST,

} requestType;


#import <Foundation/Foundation.h>

@interface RequestTool : NSObject


//数据请求,type请求类型，URString请求的地址，parameterDic：post请求的参数，callBack：block回调

+ (void)requestWithType:(requestType)type URLString:(NSString *)urlString parameter:(NSDictionary *)parameterDic callBack:(void(^)(NSData *data,NSError *error))callBack;


@end
