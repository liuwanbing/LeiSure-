//
//  AppDelegate.m
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "ReadViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

//打开或者关闭抽屉
- (void)openDrawer {

    //打开抽屉
    //判断抽屉的状态，关闭就打开，打开就关闭
    if (self.drawerVC.isOpen) {
        
        [self.drawerVC close];
        
    } else {
        
        [self.drawerVC open];
        
    }


}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //从storyboard来获取
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *readNAVC = [mainStory instantiateViewControllerWithIdentifier:@"readNAVC"];
    
    //创建左侧抽屉控制器
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    
    //创建抽屉
    self.drawerVC = [[DrawerViewController alloc] initWithLeftViewController:leftVC MainViewController:readNAVC];

    //将抽屉设置为根视图控制器
    self.window.rootViewController = self.drawerVC;
    
#warning -----The Third share By UMengSocial -----
    
    [UMSocialData setAppKey:@"57566adb67e58e8d4c0010ad"];
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
#pragma mark-----
    //初始化字典
    self.viewControllerDic = @{}.mutableCopy;
    
    //将阅读控制器放入字典
    [self.viewControllerDic setObject:readNAVC forKey:@"ReadViewController"];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

//回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
