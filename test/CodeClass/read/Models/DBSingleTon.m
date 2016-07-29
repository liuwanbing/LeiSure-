//
//  DBSingleTon.m
//  test
//
//  Created by lanou on 16/6/22.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "DBSingleTon.h"

static DBSingleTon *singleTon = nil;

@implementation DBSingleTon


- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [[DBSingleTon alloc] init];
        [singleTon createDB];
        
    });

    return singleTon;
}
//创建一个数据库
- (void)createDB {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    self.dbPath = [docPath stringByAppendingPathComponent:@"readList.sqlite"];
    self.db = [FMDatabase databaseWithPath:self.dbPath];
    NSLog(@"数据库的路径%@",self.dbPath);
    
    //打开数据库
    BOOL result = [self.db open];
    if (result) {
        NSLog(@"打开数据库成功");
        self.userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"][@"auth"];
        NSLog(@"%@",self.userName);
#warning -----NSString pin jie de hao chu -------
        //创建一个表
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key, title text not null, content text not null, coverimg text not null,modelID text not null);",self.userName];
        BOOL createResult = [self.db executeUpdate:sql];
        if (createResult) {
            
            NSLog(@"建表成功");
        }else {
            NSLog(@"建表失败");
        }
        
    }else {
        NSLog(@"打开数据库失败");
    }
}

//查询方法
- (NSString *)selectWithID:(NSString *)modelID {

    [self.db open];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where modelID = ?;",self.userName];
    FMResultSet *resultSet = [self.db executeQuery:sql,modelID];
    NSString *modelid = nil;
    while ([resultSet next]) {
        modelid = [resultSet stringForColumn:@"modelID"];
        NSLog(@"modelid = %@",modelid);
        }
    [self.db close];
    return modelid;
    
}


- (BOOL)insertDataWitnModel:(ListReadModel *)model {

    //打开数据库
    [self.db open];
    
    //创建查询语句
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (title,content,coverimg,modelID) values(?,?,?,?);",self.userName];
    //执行语句
    BOOL result = [self.db executeUpdate:sql,model.title,model.content,model.coverimg,model.ID];
    
    if (result) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败");
    }
  
    [self.db close];
    return YES;
}

- (BOOL)deleteDataWithID:(NSString *)modelID {
    [self.db open];
    //创建查询语句
    NSString *sql  = [NSString stringWithFormat:@"delete from %@ where modelID = ?;",self.userName];
    BOOL result = [self.db executeUpdate:sql,modelID];
    if (result) {
        NSLog(@"删除数据成功");
        NSLog(@"%@",self.dbPath);
    }else {
        NSLog(@"删除数据失败");
    }
    [self.db close];
    
    return YES;

}
//查询所有数据
- (NSMutableArray *)selectAllData {
    [self.db open];
    
//    self.dataArray = nil;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ ;",self.userName];
    FMResultSet *resultSet = [self.db executeQuery:sql];
    NSLog(@"%@",resultSet);
    NSLog(@"开始查询");
    while ([resultSet next]) {
            
        NSString *allTitle = [resultSet stringForColumn:@"title"];
        NSString *allContent = [resultSet stringForColumn:@"content"];
        NSString *allCoverimg = [resultSet stringForColumn:@"coverimg"];
        NSString *allModelID = [resultSet stringForColumn:@"modelID"];
        self.model = [[ListReadModel alloc] init];
        self.model.title = allTitle;
        self.model.content = allContent;
        self.model.coverimg = allCoverimg;
        self.model.ID = allModelID;
        [self.dataArray addObject:self.model];
    }
    
    [self.db close];
    return self.dataArray;
}

@end
