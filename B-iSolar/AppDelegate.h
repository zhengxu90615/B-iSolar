//
//  AppDelegate.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ADViewController.h"

#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
{
    UITabBarController *tabC;
    UINavigationController *homeNavi,*reportNavi,*monitorNavi,*myNavi,*assetsNavi, *checkUpNavi,*workNavi;
    
    ADViewController *adV;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADViewController *adV;
@property (strong, nonatomic) UITabBarController *tabC;
@property (strong, nonatomic) UINavigationController *homeNavi,*reportNavi,*monitorNavi,*myNavi,*assetsNavi,*checkUpNavi,*workNavi;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSMutableDictionary *lastSelect;

- (void)pushView:(UIViewController *)vc;
+ (AppDelegate*)App;
- (void)CheckLogin;
- (void)selectTab:(NSInteger)index;
+ (UIColor*)defaultTinitColor;
+ (UIColor*)defaultTitleColor;
- (void)setColors;

+ (NSString *)server;
+ (NSString *)serverName;
+ (NSString *)tenantid;
+ (NSString *)logoPath;
+ (CGFloat )textHeight:(NSString *)str andFontSIze:(int)fs andTextwidth:(int)width;
@end

