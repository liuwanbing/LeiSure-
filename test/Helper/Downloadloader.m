//
//  Downloadloader.m
//  test
//
//  Created by lanou on 16/6/23.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "Downloadloader.h"

@interface Downloadloader ()<NSURLSessionDownloadDelegate>
//下载任务对象
@property (nonatomic,strong) NSURLSessionDownloadTask *task;

@end

@implementation Downloadloader



- (instancetype)initWithURL:(NSString *)URLString saveName:(NSString *)fileName {

    self = [super init];
    
    if (self) {
        //保存传进来的字符串的值，
        _fileName = fileName;
        _URLString = URLString;
        
//        //拼接文件的后缀名
//        NSArray *arr = [URLString componentsSeparatedByString:@"."];
//        _fileName = [fileName stringByAppendingFormat:@".%@",arr.lastObject];
//        NSLog(@"%@",_fileName);
    
        //转换，URL
        NSURL *URL = [NSURL URLWithString:URLString];
        
        //下载使用的NSURLSession类
        //初始化task需要一个session对象
        //初始化一个session 并设置代理 ，需要指定代理方法回调的队列
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [session downloadTaskWithURL:URL];
    }
    return self;
}

//下载完成代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //location是下载完成后文件所在的地址，默认在tmp下，需要我们移动到别的地方，否则会被系统删除
       //判断有没有这个问件夹我就创建一个
 BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:localFolderPath];
    if (!exists) {
        //WithIntermediateDireectories 如果中间路径不存在 是否要创建， attributes 文件的属性，如修改时
        [[NSFileManager defaultManager] createDirectoryAtPath:localFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
  
    //目标路径
    NSString *distentPath = [localFolderPath stringByAppendingFormat:@"%@",_fileName];
    //将文件移动到指定的文件夹
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:distentPath error:nil];
    NSLog(@"%@",localFolderPath);
    //把网址从正在下载的数组里面删除
    [[DownloadloadManager sharedInstance].URLArray removeObject:_URLString];
    //把当前任务从数组中删除
    [[DownloadloadManager sharedInstance].taskArray removeObject:self];

#warning --- 如果不加通知的话，下载完成后拖拽tableviw会崩溃----
    //提示数组越界，因为下载完成后，你再拖动tableviw的时候，他会走indexpath forrow 这个方法，但是他保存数据的数组已经删除了，所以找不到数据，就会崩溃Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM objectAtIndex:]: index 0 beyond bounds for empty array'

    //发送通知，提醒外界有任务完成了
    [[NSNotificationCenter defaultCenter]postNotificationName:downloadFinishNotification object:self];
    
    NSLog(@"下载完成");
    


}

//正在下载中
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //didWriteData本次获得数据的大小 int64是长整形
    //totalBytesWritten 已经写入的数据的总大小
    //totalBytesExpectedToWrite  这个文件的总大小
       self.totalMB = [NSString stringWithFormat:@"%.1fMB",(float)totalBytesExpectedToWrite / 1024 / 1024];
    self.currentMB = [NSString stringWithFormat:@"%.1fMB",(float)totalBytesWritten / 1024 / 1024];
    self.proportion = totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    //如果已经实现了block， 就调用
    if (self.loadingBlock) {
        self.loadingBlock(totalBytesWritten,totalBytesExpectedToWrite);
    }
   
}

//继续下载
- (void)resume {

    [_task resume];
    self.isLoading = YES;
    

}

//暂停下载
-(void)suspend {
    self.isLoading = NO;
    [_task suspend];

}

//取消下载
-(void)cancel {
    self.isLoading = NO;
    [_task cancel];
    
}

@end

//管理类实现部分
@implementation DownloadloadManager

//获取管理器单例
+ (instancetype)sharedInstance {
    
    static DownloadloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadloadManager alloc] init];
        //初始化网址数组
        manager.URLArray = [NSMutableArray array];

        //初始化任务数组
        manager.taskArray = [NSMutableArray array];
        
    });
    return manager;

}

//添加一个任务 文件网址，保存文件名称，添加结果回调（block）
- (Downloadloader *)addDownloadWithURL:(NSString *)URLString saveName:(NSString *)fileName addResult:(void(^)(addResult result))resultCallBack {
    //拼接后缀名
    NSArray *arr  = [URLString componentsSeparatedByString:@"."];
    NSString *saveName = [fileName stringByAppendingFormat:@".%@",arr.lastObject];
    //判断这个文件是否正在下载
    if ([self.URLArray containsObject:URLString]) {
        //如果包含这个网址 ,回调block 为正在下载中
        resultCallBack(addResultDownloading);
        return nil;
    }else if ([[self alreadyDownload]containsObject:saveName]) {
    //这个文件是否已经下载完成了
        //如果文件夹包含这个文件， 回调block为下载完成
        resultCallBack(addResultDownloadFinish);
        return nil;
        
    }else {
        
        //如果不是正在下载 也没有下载完成，说明是一个新的任务
        Downloadloader *load = [[Downloadloader alloc]initWithURL:URLString saveName:saveName];
        resultCallBack(addResultSuccess);
        //把网址加入正在下载的网址的数组中
        [self.URLArray addObject:URLString];
        
        //将下载对象加入数组
        [self.taskArray addObject:load];
        return load;
    
    }
    
    

}

- (NSArray *)alreadyDownload {
    return [[NSFileManager defaultManager]contentsOfDirectoryAtPath:localFolderPath error:nil];

}


@end

