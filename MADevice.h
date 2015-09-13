//
//  MADevice.h
//  WaterPurifier
//
//  Created by 马腾飞 on 15/8/22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DEVICE_MODE) {
    // 命令模式
    COMMAND_MODE,
    // 透传模式
    TRANS_MODE,
};
@interface MADevice : NSObject

// 设备IP
@property (nonatomic, strong) NSString *ip;
// 设备mac地址
@property (nonatomic, strong) NSString *mac;
// 设备模块ID
@property (nonatomic, strong) NSString *model_Id;
// 设备返回信息
@property (nonatomic, strong) NSString *message;
// 设备通信对应的socket描述符(公用设备管理器广播socket)
@property (nonatomic, assign) NSInteger sd_udp;
@property (nonatomic, assign) DEVICE_MODE mode;

// （这两个接口一定要调用，设备才能正常使用）
// 启动设备  跟endDevice要配对使用
- (void)startDevice;
// 结束设备
- (void)endDevice;

// 设置进入命令模式
- (void)enterCommandMode;

// 设置进入透传模式
- (void)enterTransMode;

// 发送透传数据
- (int)sendTransString:(NSString*)commandString;

// 发送命令接口
- (int)sendCommandToDevice:(NSString*)commandToSend;


@end
