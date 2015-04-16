//
//  CommonFunc.h
//  WaterPurifier
//
//  Created by bjdz on 15-2-5.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

// 电话当前网络类型
typedef enum
{
    PNT_UNKNOWN = 0,    // 未知,无网络
    PNT_WIFI    = 1,    // WIFI
    PNT_2G3G           // 2G/3G
}PhoneNetType;

// 公共函数定义
@interface CommonFunc : NSObject


// 字节码转换为十六进制字符串
+ (char*) ByteToHex:(const unsigned char*) vByte length:(const int)vLen;

// 十六进制字符串转换为字节码(注意要大写字母)
+ (unsigned char*) HexToByte:(const char*) szHex;

// 获取电话当前网络类型
+ (PhoneNetType) GetCurrentPhoneNetType;

// 判断字符串是否包含汉字
+ (BOOL)IsContainChinese:(NSString*)string;

// 字符串是否是纯数字
+ (BOOL) IsNSStringPureInt:(NSString *) string;

//时间转换
+ (NSString *) intervalSinceNow: (NSString *) theDate;

//获取手机的MAC地址
+(NSString *)getMacAddress;
//
+(void)pushViewController:(UINavigationController*)nv andControllerID:(NSString*)vcID andStoryBoard:(UIStoryboard*)storyboard;

//隐藏tableView底部多余分隔线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
@end

