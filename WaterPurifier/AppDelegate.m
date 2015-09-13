//
//  AppDelegate.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioToolbox/AudioToolbox.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    //推送
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
    
    
    // Override point for customization after application launch.
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

}
//<8a6d98d6 a0b3f55a 45d0dd72 b07b332e b741871d 7f77dedf 2e320042 977a1939>

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}
//处理收到的消息推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    [self playSound];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"flushNotification" object:nil];
    application.applicationIconBadgeNumber -= 1;
    NSDictionary *dic = [userInfo objectForKey:@"aps"];
    //执行删除动作人的ID
    NSString *alertStr = [dic objectForKey:@"alert"];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:alertStr
                                                   delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)playSound
{
    SystemSoundID sound;
    NSString *path = @"/System/Library/Audio/UISounds/sms-received1.caf";//三全音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    AudioServicesPlaySystemSound(sound);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    ActivityIndicatorView *ai =[ActivityIndicatorView share];
    [ai stopAnimation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideNavingationController" object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    ActivityIndicatorView *ai =[ActivityIndicatorView share];
    RequestManager *request = [RequestManager share];
    if ([request.requestArr count]>0) {
        [ai startAnimation];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
