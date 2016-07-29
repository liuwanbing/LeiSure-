//
//  DBSingleTon.h
//  test
//
//  Created by lanou on 16/6/22.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "ListReadModel.h"



@interface DBSingleTon : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *dbPath;

@property (nonatomic, strong) FMDatabase *db;

//保存数据库中数据的数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ListReadModel *model;



+ (instancetype)sharedInstance;

- (void)createDB;

//添加数据
- (BOOL)insertDataWitnModel:(ListReadModel *)model;

//删除数据
- (BOOL)deleteDataWithID:(NSString *)modelID;

//删除当前用户所有数据
- (BOOL)removeAllDataFromCurrentUser;

//根据id查询某个
- (ListReadModel *)selectModelWithID:(NSString *)modelID;

//返回当前用户所有的收藏
- (NSMutableArray *)selectAllData;


//通过一个模型的id去判断数据库中是否
- (NSString *) selectWithID:(NSString *)modelID;



@end
