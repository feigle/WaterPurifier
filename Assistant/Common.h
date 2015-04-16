//
//  Common.h
//  WaterPurifier
//
//  Created by bjdz on 15-2-5.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "CommonFunc.h"

#define EditTipAlertTag 777
#define SureTipAlertTag 999

@class MBProgressHUD;
@interface Common : NSObject


+(void)showMessage:(NSString*)message;//弹出框
+(void)showTagAlert:(NSString*)message Delegate:(id)delegate Tag:(NSInteger)tag;
+(void)showSelectAlert:(NSString*)title Message:(NSString*)msg Delegate:(id)delegate Tag:(NSInteger)tag;
+(void)showEditTipAlert:(id)delegate;

+(UIColor*)randomColor;//随机生成颜色
+(NSString*)randomRGBColor;//随机生成十六进制颜色
+(NSString *)ToHex:(int)tmpid;//十进制转十六进制

+(id)JsonResultFromFileName:(NSString*)name;//文件名加载json数据

+(MBProgressHUD*)showLoadingWithInView:(UIView*)iv;//加载框
+(void)hideLoadingFromView:(UIView*)iv;

+(UIImage*)imageFromBundleWithName:(NSString*)name;

+(BOOL)judgeExistProName:(NSString *)proName;
+(BOOL)judgeTelNumFormat:(NSString *)telnum;
+(BOOL)judgeEmailFormat:(NSString *)eamil;


#pragma mark-
#pragma Be in Common Used Metnod
+(void)changeTableViewSeparatorLine:(UITableView*)table Cell:(UITableViewCell*)cell IndexPath:(NSIndexPath*)indexPath;

+(BOOL)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
@end
@interface NSString(ex_methods)
- (NSString*)UTF_8;
@end

@protocol NSObjectEX <NSObject>
@optional
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
@end

@interface NSURL (ex_methods)
+ (NSURL*)URLWithStringEncode:(NSString*)urlString;
@end





/************************************适配iphone5******************************************/


@interface NSObject(Adaptation_Methods)

-(CGFloat)getHeight:(CGFloat)originHeight;

@end