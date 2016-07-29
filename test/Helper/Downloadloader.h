//
//  Downloadloader.h
//  test
//
//  Created by lanou on 16/6/23.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

//下载中block 将已经下载的大小的总和作为参数传递
typedef void(^downloadingBlock) (int64_t currentBytes,int64_t totalBytes);

#define localFolderPath [NSHomeDirectory() stringByAppendingString:@"/Documents/download/"]

//下载完成通知名称
#define downloadFinishNotification @""

#import "DownloadTableViewCell.h"
#import <Foundation/Foundation.h>


@interface Downloadloader : NSObject

//文件网址
@property (nonatomic, copy) NSString *URLString;

//文件名称
@property (nonatomic, copy) NSString *fileName;


//当前进度
@property (nonatomic, assign) CGFloat proportion;

//已经下载的大小
@property (nonatomic, copy) NSString *currentMB;

//总大小
@property (nonatomic, copy) NSString *totalMB;

//下载中回调
@property (nonatomic, copy) downloadingBlock loadingBlock;

//是否正在下载
@property (nonatomic, assign) BOOL isLoading;


//继续下载
- (void)resume;
//暂停下载
-(void)suspend;
//取消下载
-(void)cancel;


//指定文件的地址，和保存的文件名
- (instancetype)initWithURL:(NSString *)URLString saveName:(NSString *)fileName;


@end



#warning -----enum----
//枚举
typedef enum {
    
    addResultSuccess,//添加成功
    addResultDownloading,//正在下载中
    addResultDownloadFinish//下载已完成
    
}addResult;


//下载管理类
@interface DownloadloadManager : NSObject

//正在下载的所有文件的地址
@property (nonatomic,strong) NSMutableArray *URLArray;

//正在下载的任务
@property (nonatomic ,strong) NSMutableArray *taskArray;


//获取管理器单例
+ (instancetype)sharedInstance;

//添加一个任务 文件网址，保存文件名称，添加结果回调（block）
- (Downloadloader *)addDownloadWithURL:(NSString *)URLString saveName:(NSString *)fileName addResult:(void(^)(addResult result))resultCallBack;



@end

