//
//  AppDelegate.m
//  wxsl
//
//  Created by 刘冬 on 16/6/24.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "AppDelegate.h"
#import "SLHomeVC.h"
#import "JPUSHService.h"
#import "SLUserViewController.h"
#import "SLEmpowerVC.h"
#import "SLProgrammeVC.h"
static NSString *appKey = @"371933acd386e02ae6cd65ef";
static NSString *channel = @"";
static BOOL isProduction = YES;


@interface AppDelegate ()
@property(retain,nonatomic)CLLocationManager *locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    
    [self checkNewVersion];
    
    [MyFounctions setUserlanguage:lA_CHINESE];
    //注册定位权限
    [MyFounctions registerLocationPermissions:self.locationManager];
    //注册通知权限
    [MyFounctions registerNotificationCompetence];
    //监听网络状态
    [self monitoringNetWorkStatus];
    
    // 初始化极光推送
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    //[HttpApi testSuccessBlock:nil FailureBlock:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    if (self.window == nil) {
        self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, MainScreenFrame_Height)];
    }
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    SLHomeVC *mHomeVC = [[SLHomeVC alloc]init];
    UINavigationController *mHomeNavi = [[UINavigationController alloc]initWithRootViewController:mHomeVC];
    mHomeNavi.tabBarItem.title = @"首页";
    mHomeNavi.tabBarItem.image = [UIImage imageNamed:@"tab_home"];
  
    SLUserViewController*mUserVC = [[SLUserViewController alloc]init];
    UINavigationController *mUsetNavi = [[UINavigationController alloc]initWithRootViewController:mUserVC];
    mUsetNavi.tabBarItem.title = @"我的";
    mUsetNavi.tabBarItem.image = [UIImage imageNamed:@"tab_user"];
    
    SLEmpowerVC*mEmpowerVC = [[SLEmpowerVC alloc]init];
    UINavigationController *mEmpowerNavi = [[UINavigationController alloc]initWithRootViewController:mEmpowerVC];
    mEmpowerNavi.navigationItem.leftBarButtonItem = nil;
    mEmpowerNavi.tabBarItem.title = @"授权";
    mEmpowerNavi.tabBarItem.image = [UIImage imageNamed:@"tab_empower"];
    
    SLProgrammeVC*mOrderVC = [[SLProgrammeVC alloc]init];
    UINavigationController *mOrderNavi = [[UINavigationController alloc]initWithRootViewController:mOrderVC];
    mOrderNavi.tabBarItem.title = @"日程";
    mOrderNavi.tabBarItem.image = [UIImage imageNamed:@"tab_0rder"];
    
    UITabBarController *mRootVC = [[UITabBarController alloc]init];
    [mRootVC setViewControllers:@[mHomeNavi,mEmpowerNavi,mOrderNavi,mUsetNavi]];
    
    [self.window setRootViewController:mRootVC];
    [self.window makeKeyAndVisible];
    
    return YES;
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
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *regId = [JPUSHService registrationID];
    
    if (sl_userID && regId && regId.length>0) {
        NSDictionary *paramDic = @{@"userId":sl_userID,@"regid":[JPUSHService registrationID]};
        
        [HttpApi putRegJpush:paramDic SuccessBlock:^(id responseBody) {
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
   
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 通知内容
    notification.alertBody =  userInfo[@"aps"][@"alert"];
    //    notification.applicationIconBadgeNumber = 0;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"出去玩了" forKey:@"key"];
    notification.userInfo = userDict;
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 通知内容
    notification.alertBody =  userInfo[@"aps"][@"alert"];
    notification.applicationIconBadgeNumber = 0;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
//    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"出去玩了" forKey:@"key"];
//    notification.userInfo = userDict;
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
#pragma  mark private
-(void)checkNewVersion{
    if (sl_userID) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
         NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
        [[SLNetWorkingHelper shareNetWork]getVersionUpdate:@{@"userId":sl_userID,@"version":v} SuccessBlock:^(id responseBody) {
            
            NSString *tempv = responseBody[@"version"];
            if (![v isEqual:[NSNull null]]) {
                if (v.length>0 && v) {
                    if ([tempv isEqualToString:v]) {
                        [[NSUserDefaults standardUserDefaults]setObject:@"已经是最新版本" forKey:@"vv"];
                    }else{
                        [[NSUserDefaults standardUserDefaults]setObject:@"有版本可更新" forKey:@"vv"];
                    }
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            
            UIAlertController *alertController;
            NSString *mTitle = responseBody[@"content"];
            if([mTitle isEqual:[NSNull null]]){
                return ;
            }
            
            if (mTitle == nil  || [mTitle length]>0) {
               mTitle = @"为了保证您的使用,请更新到最新版本";
            }
            
            NSInteger tempIsforce = [responseBody[@"isforce"] integerValue];
            
            if ( tempIsforce == 0) {
               alertController = [UIAlertController alertControllerWithTitle:APPName message:mTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *urlStr = responseBody[@"downloadUrl"];
                    if([urlStr isEqual:[NSNull null]]){
                        return ;
                    }
                    if (urlStr && urlStr.length>0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                    
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
            }else if(tempIsforce == 1 ){
             //强制更新
                alertController = [UIAlertController alertControllerWithTitle:APPName message:mTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *urlStr = responseBody[@"downloadUrl"];
                    if([urlStr isEqual:[NSNull null]]){
                        return ;
                    }
                    if (urlStr && urlStr.length>0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
                [alertController addAction:okAction];

            }
            
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}
-(void)monitoringNetWorkStatus{
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                ShowMSG(@"网络已断开");
                break;
            case AFNetworkReachabilityStatusUnknown:
                ShowMSG(@"网络已断开");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark getter
-(CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager =  [[CLLocationManager alloc]init];
    }
    return _locationManager;
}
@end
