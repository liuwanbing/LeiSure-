//
//  URLDefineHeader.h
//  test
//
//  Created by lanou on 16/6/14.
//  Copyright © 2016年 刘万兵. All rights reserved.
//


//专门用来存放所有的网络接口地址
#ifndef URLDefineHeader_h
#define URLDefineHeader_h


#endif /* URLDefineHeader_h */

//测试地址
#define  KtestUrl @"http://mapi.yinyuetai.com/video/list.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.0.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20U9508%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%225eec1e1b389ff457f6c886ef88eeb6dd%22%2C%22clid%22%3A110002000%7D&area=ELITE&offset=0&size=20"
//阅读分类列表地址
#define KreadTypeList_URL @"http://api2.pianke.me/read/columns_detail"
//阅读列表
#define KreadList_URl @"http://api2.pianke.me/read/columns"
//文章详情列表
#define KreadDetail_URL @"http://api2.pianke.me/article/info"
//电台列表
#define KradioList_URL @"http://api2.pianke.me/ting/radio"

//2、电台首页上拉加载更多
#define KradioMoreList_URL @"http://api2.pianke.me/ting/radio_list"

//电台详情列表的接口
#define KradioDetailList_URL @"http://api2.pianke.me/ting/radio_detail"
//良品首页接口
#define KproductList_URL @"http://api2.pianke.me/pub/shop"

//主题首页接口
#define KtopicList_URL @"http://api2.pianke.me/group/posts_hotlist"

//话题详情接口
#define KtopicDetail_URL @"http://api2.pianke.me/group/posts_info"




//  登录注册
#define LOGIN_URL              @"http://api2.pianke.me/user/login" //登录接口的地址   email  passwd
#define REGIST_URL             @"http://api2.pianke.me/user/reg"   //注册接口的地址 uname gender email passwd

//  评论
#define GETCOMMENT_url         @"http://api2.pianke.me/comment/get" // 获取评论  id

#define ADDCOMMENT_url         @"http://api2.pianke.me/comment/add" // 发表评论  contentid content   auth
#define DELCOMMENT_url         @"http://api2.pianke.me/comment/del" // 删除评论 contentid commentid auth


