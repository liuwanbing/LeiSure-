//
//  TopicListModel.h
//  test
//
//  Created by lanou on 16/6/18.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicListModel : NSObject

@property (nonatomic, strong) NSNumber * addtime;
@property (nonatomic, copy) NSString  * addtime_f;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * coverimg;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) NSDictionary *counterList;
@property (nonatomic, strong) NSDictionary *userinfo;


@end
