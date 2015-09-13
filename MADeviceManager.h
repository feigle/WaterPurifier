//
//  MADeviceManager.h
//  WaterPurifier
//
//  Created by 马腾飞 on 15/8/22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MADevice;
@class MADeviceManager;
@protocol MADeviceManagerDelegate <NSObject>

// 设备管理器设置配置失败
- (void)deviceManagerSetConfigSuccess;
// 设备管理器设置配置失败
- (void)deviceManagerSetConfigFailer;
// 发现新设备
- (void)deviceManager:(MADeviceManager *)deviceManager didDiscoveredDevice:(MADevice *)device;

@end

@interface MADeviceManager : NSObject

// 委托代理
@property (nonatomic, weak) id<MADeviceManagerDelegate> delegate;

+ (MADeviceManager*)shareInstance;

// 搜索设备
- (void)scan;

@end
