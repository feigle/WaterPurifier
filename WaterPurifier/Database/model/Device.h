//
//  Device.h
//  WaterPurifier
//
//  Created by bjdz on 15-4-7.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "STDbObject.h"
@interface Device : STDbObject
@property (strong, nonatomic) NSString *name;  /** 电话号码 */
@property (strong, nonatomic) NSString *devId;  /** 邮箱 */
@end
