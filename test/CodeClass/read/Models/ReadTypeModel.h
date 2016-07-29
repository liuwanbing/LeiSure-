//
//  ReadTypeModel.h
//  test
//
//  Created by lanou on 16/6/15.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "BaseModel.h"

@interface ReadTypeModel : BaseModel

//图片网址
@property(nonatomic,strong)NSString *coverimg;
//中文名
@property (nonatomic,strong)NSString *name;

//英文名
@property (nonatomic,strong)NSString *enname;

//类型
@property (nonatomic,assign)NSInteger type;




@end
