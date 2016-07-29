//
//  RequestTool.m
//  test
//
//  Created by lanou on 16/6/14.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool

+ (void)requestWithType:(requestType)type URLString:(NSString *)urlString parameter:(NSDictionary *)parameterDic callBack:(void (^)(NSData *, NSError *))callBack {

    //转换
    NSURL *url = [NSURL URLWithString:urlString];
    //如果地址中包含了中文或者一些特殊的字符，会导致URL转换失败，需要进行UTF8转码
    //UTF8编码，如果url中有中文字符，就会显示为空
    if (url == nil) {
        NSString *utf8Str = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        url = [NSURL URLWithString:utf8Str];
    }
    //创建一个可变的请求对象
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    if (type == POST) {
        //修改请求方法
        [request setHTTPMethod:@"POST"];
        
        if (parameterDic == nil) {
            
        }else {
            //设置请求参数
            [request setHTTPBody:[RequestTool dataForDic:parameterDic]];
        }
    }

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
       //创建一个任务task 并开始
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求完成后，回调自己的block 将数据传递出去
        callBack(data,error);
        if (error) {
            NSLog(@"请求失败%@",error);
        }else {
            
        }
    }];
    
    [task resume];
}


//将字典转换为Data
+ (NSData *)dataForDic:(NSDictionary *)dic {

    //创建一个数组
    NSMutableArray *arr = [NSMutableArray array];
    //遍历所有的key
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        //将每次遍历 得到的键值存到数组
        [arr addObject:str];
    }
    //用&符号将所有的键值连接
    NSString *parameterStr = [arr componentsJoinedByString:@"&"];
    return [parameterStr dataUsingEncoding:NSUTF8StringEncoding];
}

@end
