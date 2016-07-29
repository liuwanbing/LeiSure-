//
//  CommentListModel.h
//  test
//
//  Created by lanou on 16/6/21.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *addtime_f;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDictionary * userinfo;
@property (nonatomic, copy) NSString *  contentid;

@end
