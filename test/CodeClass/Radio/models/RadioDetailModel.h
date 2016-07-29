//
//  RadioDetailModel.h
//  test
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailModel : BaseModel

//图片地址
@property (nonatomic, copy) NSString *coverimg;
//音频地址
@property (nonatomic, copy) NSString *musicUrl;
//播放次数
@property (nonatomic, copy) NSNumber *musicVisit;
//节目id
@property (nonatomic, copy) NSString *tingid;
//标题
@property (nonatomic, copy) NSString *title;

//
@property (nonatomic, strong) NSDictionary *playInfo;

@property (nonatomic, copy) NSString *webview_url;

@end
