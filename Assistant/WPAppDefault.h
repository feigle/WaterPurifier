//
//  WPAppDefault.h
//  WaterPurifier
//
//  Created by 吗啡 on 16/2/2.
//  Copyright © 2016年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAppDefault : NSObject

+ (id)shareInstance;

// 保存设备绑定信息 mac地址
- (void)writeBindingDeviceMac:(NSString *)macString;

// 读取设备绑定信息 mac地址
- (NSString *)readBindingDeviceMac;

@end
