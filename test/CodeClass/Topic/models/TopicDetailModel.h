//
//  TopicDetailModel.h
//  test
//
//  Created by lanou on 16/6/19.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDetailModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSString *commenttotal;
@property (nonatomic, copy) NSDictionary *userinfo;
@property (nonatomic, copy) NSString *addtime_f;
@property (nonatomic, copy) NSString *cmtnum;


@end
