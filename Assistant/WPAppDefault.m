//
//  WPAppDefault.m
//  WaterPurifier
//
//  Created by 吗啡 on 16/2/2.
//  Copyright © 2016年 joblee. All rights reserved.
//

#import "WPAppDefault.h"

@implementation WPAppDefault

+ (id)shareInstance
{
    static WPAppDefault *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[WPAppDefault alloc] init];
    });
    
    return instance;
}

// 保存设备绑定信息 mac地址
- (void)writeBindingDeviceMac:(NSString *)macString
{
    if (macString.length <= 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:macString forKey:@"BIND_DEVICE_MAC_INFO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取设备绑定信息 mac地址
- (NSString *)readBindingDeviceMac
{
    NSString *macStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BIND_DEVICE_MAC_INFO"];
    return macStr;
}

@end
