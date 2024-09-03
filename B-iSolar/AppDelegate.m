//
//  AppDelegate.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AppDelegate.h"
#import "IOAApiHelper.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "ReportViewController.h"
#import "MonitorViewController.h"
#import "AssetsViewController.h"
#import "CheckUpViewController.h"
#import "NoticeTableViewCell.h"
#import "AlarmsDetailViewController.h"
#import "NoticeDetailViewController.h"
#import "GGDetailViewController.h"
#import "FiveWebViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "MissionDetailViewController.h"
#import "AlarmsDetailViewController.h"
#import "AlarmNewViewController.h"
#import "GZDetailViewController.h"
#import "WorksViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tabC;
@synthesize homeNavi,reportNavi,monitorNavi,myNavi,assetsNavi,checkUpNavi,workNavi;
@synthesize adV;
+(AppDelegate*)App
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
+ (UIColor*)defaultTinitColor{
//    return UIColorFromHex(0xff4DFF);

    return UIColorFromHex(0x019AD8);
//    return UIColorFromHex(0x4E4DFF);
}
+ (UIColor*)defaultTitleColor{
    //    return UIColorFromHex(0x41a9fa);
    
    return UIColorFromHex(0x333333);
    //    return UIColorFromHex(0x4E4DFF);
}

- (void)initGT{
    [GeTuiSdk runBackgroundEnable:false];

    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
}
- (void)initBMap{
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"hNCp36xJc6GBgryO7kjwq6XZB0mGPZwg"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initGT];
    [self initBMap];
    
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    self.lastSelect = [[NSMutableDictionary alloc] init];
    //[IOAApiHelper configNetworkWithBaseUrl:API_HOST];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLogin:) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLogout:) name:NOTIFICATION_NOT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDismiss:) name:NOTIFICATION_AD_DISMISS object:nil];

    
    homeNavi = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init] ];
    reportNavi = [[UINavigationController alloc]initWithRootViewController:[[ReportViewController alloc]init] ];
    monitorNavi = [[UINavigationController alloc]initWithRootViewController:[[MonitorViewController alloc]init] ];
    myNavi = [[UINavigationController alloc]initWithRootViewController:[[UserViewController alloc]init] ];
//    assetsNavi = [[[UINavigationController alloc]initWithRootViewController:[AssetsViewController alloc]init]];
    checkUpNavi = [[UINavigationController alloc]initWithRootViewController:[[CheckUpViewController alloc]init] ];
    workNavi = [[UINavigationController alloc]initWithRootViewController:[[WorksViewController alloc]init] ];

    assetsNavi = [[UINavigationController alloc]initWithRootViewController: [[FiveWebViewController alloc]init] ];

    self.tabC = [[UITabBarController alloc]init];
//    self.tabC.viewControllers = [NSArray arrayWithObjects:checkUpNavi,homeNavi,monitorNavi,assetsNavi, nil];
    self.tabC.viewControllers = [NSArray arrayWithObjects:homeNavi,monitorNavi,workNavi,assetsNavi, nil];
//    self.tabC.viewControllers = [NSArray arrayWithObjects:checkUpNavi,assetsNavi, nil];
    self.tabC.selectedIndex = 0;
    self.tabC.delegate = self;
    self.tabC.tabBar.tintColor = MAIN_TINIT_COLOR;
    
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"menu_icon_ a"];
    homeNavi.tabBarItem.title = String(@"首页");
    
    reportNavi.tabBarItem.image = [UIImage imageNamed:@"tab_report"];
    reportNavi.tabBarItem.title = String(@"日报");
    
    monitorNavi.tabBarItem.image = [UIImage imageNamed:@"menu_icon_ b"];
    monitorNavi.tabBarItem.title = String(@"监控");
    
    myNavi.tabBarItem.image = [UIImage imageNamed:@"tab_me"];
    myNavi.tabBarItem.title = String(@"我的");
    
    assetsNavi.tabBarItem.image = [UIImage imageNamed:@"menu_icon_ d"];
    assetsNavi.tabBarItem.title = String(@"报告");
    
    checkUpNavi.tabBarItem.image = [UIImage imageNamed:@"menu_icon_ c"];
    checkUpNavi.tabBarItem.title = String(@"工作");
    
    workNavi.tabBarItem.image = [UIImage imageNamed:@"menu_icon_ c"];
    workNavi.tabBarItem.title = String(@"工作");
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setColors];

    self.window.rootViewController = tabC;
    
    [self CheckLogin];
    [self checkAd];
    
    return YES;
}

- (void)setColors{
    
    UINavigationBar *bar = [UINavigationBar appearance];


    
    

    
    
    //去掉透明后导航栏下边的黑边
    [bar setShadowImage:[[UIImage alloc] init]];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    
    
    bar.translucent = NO;
    //    [bar setBarTintColor:MAIN_TINIT_COLOR]; // 修改导航栏的颜色为蓝色
    //    [bar setTintColor:[UIColor whiteColor]]; // 字体的颜色为白色
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [bar setBarTintColor:[UIColor whiteColor]]; // 修改导航栏的颜色为蓝色
    [bar setTintColor:[UIColor blackColor]]; // 字体的颜色为白色
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -600)
//    forBarMetrics:UIBarMetricsDefault];
}

- (void)checkAd{
//    NSMutableDictionary * adDic = [[NSMutableDictionary alloc] init];
//    [adDic setObject:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1816451236,4243710533&fm=11&gp=0.jpg" forKey:@"path"];
//    adV = [[ADViewController alloc] initWithADDic:adDic];
//    [self.window addSubview:adV.view];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *adDic = [defaults objectForKey:@"adstring"];
    if(adDic!= NULL ){

        adV = [[ADViewController alloc] initWithADDic:adDic];
        [self.window addSubview:adV.view];
    }
    BHttpRequest * apiBlock = [BHttpRequest new];

    apiBlock.needShowHud =@0;
    [apiBlock startRequest:nil uri:API_AD result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString *adstring = [defaults objectForKey:@"adstring"];
            NSDictionary *ad = [respModel.data mj_JSONObject];
            if ([ad[@"filePath"] isKindOfClass:[NSURL class]]) {
                [defaults setObject:[respModel.data mj_JSONObject] forKey:@"adstring"];
            }
            [defaults synchronize];
        }
    }];
}

- (void)CheckLogin{
    weak_self(ws)
    if([BAPIHelper getToken].length == 0) {
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init] ];
        loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:loginNavi animated:YES completion:^{
            ws.tabC.selectedIndex = 0;
        }];
    }else{
        
    }
}

- (void)notificationLogout:(id)obj{
    [self CheckLogin];
}
- (void)notificationLogin:(id)obj{
    [self upCid];
}
- (void)adDismiss:(id)obj{
    [adV.view removeFromSuperview];
}
- (void)selectTab:(NSInteger)index{
    self.tabC.selectedIndex = index;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
 *
 * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
 * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
 * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
 *
 */
- (void)registerRemoteNotification {
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error && granted) {
                NSLog(@"[ TestDemo ] iOS request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        return;
    }

    if (iOSVersion >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

#pragma mark - 远程通知(推送)回调

/// [ 系统回调 ] 远程通知注册成功回调，获取DeviceToken成功，同步给个推服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [ GTSDK ]：（新版）向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    
    NSString *token = [Utils getHexStringForData:deviceToken];

    NSLog(@"[ TestDemo ] [ DeviceToken(NSString) ]: %@\n\n", token);
}

/// [ 系统回调:可选 ] 远程通知注册失败回调，获取DeviceToken失败，打印错误信息
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *errorMsg = [NSString stringWithFormat:@"%@: %@", NSStringFromSelector(_cmd), error.localizedDescription];

    NSLog(@"[ TestDemo ] %@", errorMsg);
}


// MARK: - iOS 10+中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
 - (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    NSLog(@"willPresentNotification [ TestDemo ] [APNs] %@：%@", NSStringFromSelector(_cmd), notification.request.content.userInfo);
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    //completionHandler(UNNotificationPresentationOptionNone); 若不显示通知，则无法点击通知
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/// [ 系统回调 ] iOS 10及以上 收到APNs推送并点击时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; //清除角标
    [GeTuiSdk setBadge:0];

    NSLog(@"didReceiveNotificationResponse [ TestDemo ] [APNs] %@ \nTime:%@ \n%@",
          NSStringFromSelector(_cmd),
          response.notification.date,
          response.notification.request.content.userInfo);
    
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
    
    [self handelPush:[response.notification.request.content.userInfo[@"payload"] mj_JSONObject] andNeedOpen:YES];
}

#endif

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/// [ 系统回调 ] 收到静默通知。iOS 10以下收到APNs推送并点击时触发、APP在前台时收到APNs推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    NSLog(@"[ TestDemo ] [APNs] %@：%@", NSStringFromSelector(_cmd), userInfo);
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - GeTuiSdkDelegate

/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[ TestDemo ] [GTSdk RegisterClient]:%@", clientId);
    self.clientId = clientId;
    [self upCid];

}

- (void)upCid{
    if (self.clientId) {
        BHttpRequest * apiBlock = [BHttpRequest new];
        NSDictionary *dic = @{@"cid":self.clientId};

        apiBlock.needShowHud =@0;
        [apiBlock startRequest:dic uri:API_CID result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {

            }
        }];
    }
}


/// [ GTSDK回调 ] SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    NSString *payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    NSString *msg = [NSString stringWithFormat:@"Receive Payload: %@, taskId: %@, messageId: %@ %@", payloadMsg, taskId, msgId, offLine ? @"<离线消息>" : @""];
    NSLog(@"[ TestDemo ] [GTSdk ReceivePayload]:%@", msg);
    if (offLine){
        
    }else{
        NSLog(@"处理消息");
        
        [self handelPush:[payloadMsg mj_JSONObject] andNeedOpen:NO];
    }
}



/// [ GTSDK回调 ] SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSString *msg = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"[ TestDemo ] [GeTuiSdk DidSendMessage]:%@\n\n",msg);

}

/// [ GTSDK回调 ] SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSdkStateNotification object:self];
}


- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"[ TestDemo ] [GeTuiSdk GeTuiSdkDidOccurError]:%@\n\n",error.localizedDescription);
}

- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    /*
     参数说明
     isSuccess: YES: 操作成功 NO: 操作失败
     aError.code:
     30001：绑定别名失败，频率过快，两次调用的间隔需大于 5s
     30002：绑定别名失败，参数错误
     30003：绑定别名请求被过滤
     30004：绑定别名失败，未知异常
     30005：绑定别名时，cid 未获取到
     30006：绑定别名时，发生网络错误
     30007：别名无效
     30008：sn 无效 */
    if([action isEqual:kGtResponseBindType]) {
        NSLog(@"[ TestDemo ] bind alias result sn = %@, code = %@", aSn, @(aError.code));
    }
    if([action isEqual:kGtResponseUnBindType]) {
        NSLog(@"[ TestDemo ] unbind alias result sn = %@, code = %@", aSn, @(aError.code));
    }
}

- (void)GeTuiSdkDidSetTagsAction:(NSString *)sequenceNum result:(BOOL)isSuccess error:(NSError *)aError {
    /*
     参数说明
     sequenceNum: 请求的序列码
     isSuccess: 操作成功 YES, 操作失败 NO
     aError.code:
     20001：tag 数量过大（单次设置的 tag 数量不超过 100)
     20002：调用次数超限（默认一天只能成功设置一次）
     20003：标签重复
     20004：服务初始化失败
     20005：setTag 异常
     20006：tag 为空
     20007：sn 为空
     20008：离线，还未登陆成功
     20009：该 appid 已经在黑名单列表（请联系技术支持处理）
     20010：已存 tag 数目超限
     20011：tag 内容格式不正确
     */
    NSLog(@"[ TestDemo ] GeTuiSdkDidSetTagAction sequenceNum:%@ isSuccess:%@ error: %@", sequenceNum, @(isSuccess), aError);
}

- (void)handelPush:(NSDictionary *)payloadDic andNeedOpen:(BOOL)needOpen{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];

    
    if (needOpen){
        //重置角标
        [GeTuiSdk resetBadge];
        //如果需要角标清空需要调用系统方法设置
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
//        [SVProgressHUD showErrorWithStatus:payloadDic[@"title"]];
//        NSString *type = payloadDic[@"action"];
        
        [self goToMsg:payloadDic];
        
    }else{
        
        UILocalNotification *ln = [[UILocalNotification alloc]init];
        
        if (ln) {
            // 设置时区
            ln.timeZone = [NSTimeZone defaultTimeZone];
            // 通知第一次发出的时间
            ln.fireDate = [[NSDate date]dateByAddingTimeInterval:0];

            // 通知的具体内容
            ln.alertBody = payloadDic[@"content"];
            ln.alertTitle = payloadDic[@"title"];
            // 锁屏界面显示的小标题，完整标题：（“滑动来”＋小标题）
            // 设置app的额外信息payloadDic
            ln.userInfo = @{@"payload":payloadDic};
            // 设置重启图片
            // 设置重复发出通知的时间间隔
            //        ln.repeatInterval = NSCalendarUnitMinute;

            // 3.调度通知（启动任务，在规定的时间发出通知）
            [[UIApplication sharedApplication]scheduleLocalNotification:ln];
            
            
        }
    }
}
+ (CGFloat )textHeight:(NSString *)str andFontSIze:(int)fs andTextwidth:(int)width
{
    if (str.length > 500) {
        str = [str substringToIndex:500];
    }
    UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
    _atest.numberOfLines = 0;
    _atest.text = str;
    _atest.lineBreakMode = NSLineBreakByWordWrapping;
    _atest.font = [UIFont systemFontOfSize:fs];
    CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize labelsize = [_atest sizeThatFits:baseSize];
    return  labelsize.height;
    

    
}
- (void)pushView:(UIViewController *)vc{
    UINavigationController *navi = self.tabC.viewControllers[self.tabC.selectedIndex];
    vc.hidesBottomBarWhenPushed = YES;
    [navi pushViewController:vc animated:YES];
}

- (void)goToMsg:(NSDictionary *)notice{
    NSInteger type = [[notice objectForKey:@"action"] intValue];
    switch (type) {
        case 0:
            {
               GGDetailViewController *vc = [[GGDetailViewController alloc] initWithNotice:notice andType:type];
                [self pushView:vc];
            }
            break;
        
        case 1:
            {
                
                BHttpRequest *requestHelper = [BHttpRequest new];
                requestHelper.needShowHud = @1;
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                parmDic[@"id"] = notice[@"id"];
                ////公告详情announcement  计划任务taskManage        故障alarmMonitor
                // toolUtensil
                // type = 2   时 todo =0 文档 document// 1隐患 hiddenDanger;   2//toolUtensil 工器具;
                [requestHelper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ object:notice[@"id"]];
                        
                        if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"6"]) {
                            //任务
                            MissionDetailViewController *vc = [[MissionDetailViewController alloc] initWithNoti:notice];
                            [self pushView:vc];
                            
                        }else if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"7"])
                        {
                            //报警任务  带id
                            AlarmsDetailViewController *detail = [[AlarmsDetailViewController alloc] initWithStationId:@{@"id":respModel.data[@"contentId"]}];
                            [self pushView:detail];

                        }else if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"8"] || [TOSTRING(respModel.data[@"todo"]) isEqualToString:@"9"])
                        {
                            
                            if (respModel.data[@"contentId"] ) {
                                AlarmsDetailViewController *detail = [[AlarmsDetailViewController alloc] initWithStationId:@{@"id":notice[@"contentId"]} ];
                                [self pushView:detail];                            }else{
                                //报警任务  liebiao
                                AlarmNewViewController *detail = [[AlarmNewViewController alloc] init];
                                [self pushView:detail];                            }
                            
                           

                        }
                        else if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"10"])
                        {
                            //故障任务
                            GZDetailViewController *detail = [[GZDetailViewController alloc] initWithStationId:@{@"id":respModel.data[@"contentId"]}];
                            
                            [self pushView:detail];

                        }else if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"11"])
                        {
                            //故障任务
                            GZDetailViewController *detail = [[GZDetailViewController alloc] initWithStationId:@{@"id":respModel.data[@"contentId"]}];
                            
                            [self pushView:detail];

                        }
                        else if ([TOSTRING(respModel.data[@"todo"]) isEqualToString:@"12"])
                        {
                            //故障任务
                            GZDetailViewController *detail = [[GZDetailViewController alloc] initWithStationId:@{@"id":respModel.data[@"contentId"]}];
                            
                            [self pushView:detail];

                        }
                        else {
                            NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                            [self pushView:vc];
                        }
                        
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }

                }];
                
                
                
              
            }
            break;
        
        case 2:
            {
                NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                [self pushView:vc];
            }
            break;
        case 4:
            {
                NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                [self pushView:vc];
            }
            break;
        case 3://报警
            {
                BHttpRequest*requestHelper = [BHttpRequest new];

                weak_self(ws);
                requestHelper.needShowHud = @0;
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                parmDic[@"id"] = notice[@"id"];
                ////公告详情announcement  计划任务taskManage        故障alarmMonitor
                [requestHelper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
                    
                    if (respModel.success) {
                        //[ws setReadNoti:[ notice[@"id"] integerValue]];
                    }else{
                    }
                }];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic[@"id"] = notice[@"contentId"];
                AlarmsDetailViewController *vc = [[AlarmsDetailViewController alloc] initWithStationId:dic];
               [self pushView:vc];
            }
            break;
        case 30://报警
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic[@"id"] = notice[@"id"];
                AlarmsDetailViewController *vc = [[AlarmsDetailViewController alloc] initWithStationId:dic];
               [self pushView:vc];
            }
            break;
        default:
        {
            
            
            
        }
            break;
    }
    
}

+ (NSString *)server{
    NSDictionary *serverDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (serverDic) {
        return serverDic[@"addrUrl"];
    }
    return API_HOST_MAIN;
//    
//    return @"http://bisolartest.boeet.com.cn/";
////
//    return @"http://127.0.0.1:8001/";

//    return @"http://127.0.0.1:8000/";
    //开发环境
//    #define API_HOST @"http://127.0.0.1:8000/"
    //#define API_FILE_HOST @"http://127.0.0.1:8000/"

    //////开发环境
    //#define API_HOST @"http://10.197.92.81:3000/"
    //#define API_FILE_HOST @"http://10.197.92.36:1000/"

    //测试环境 - 内网地址
    //#define API_HOST @"http://10.197.190.54:180/"
    //#define API_FILE_HOST @"http://10.197.190.54:180/"

    ////测试环境 -外网地址
    //#define API_FILE_HOST @"http://bisolar1.boeet.com.cn/"
    //#define API_HOST @"http://bisolar1.boeet.com.cn/"
    
}

+ (NSString *)serverName{
    NSDictionary *serverDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (serverDic) {
        return serverDic[@"name"];
    }
    return @"京东方";

    
}

+ (NSString *)tenantid{
    return @"1";
}

+ (NSString *)logoPath{
    NSDictionary *serverDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (serverDic) {
        return serverDic[@"logUrl"];
    }
    return nil;
}

@end
