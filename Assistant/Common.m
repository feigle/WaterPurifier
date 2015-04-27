//
//  Common.m
//  WaterPurifier
//
//  Created by bjdz on 15-2-5.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#define LOADINGTAG  987
#import "Macros.h"
#import "Common.h"
#import "MBProgressHUD.h"
//#import "RegexKitLite.h"
//#import "CJSONDeserializer.h"


@implementation Common
+(void)showMessage:(NSString*)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}
+(void)showTagAlert:(NSString*)message Delegate:(id)delegate Tag:(NSInteger)tag{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
    [alertView release];
}
+(void)showSelectAlert:(NSString*)title Message:(NSString*)msg Delegate:(id)delegate Tag:(NSInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=tag;
    [alertView show];
    [alertView release];
}

+(void)showEditTipAlert:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"温馨提示"
                              message:@"是否放弃当前编辑数据？"
                              delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag=EditTipAlertTag;
    [alertView show];
    [alertView release];
}

+(UIColor*)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+(NSString*)randomRGBColor
{
    const CGFloat *cs=CGColorGetComponents([Common randomColor].CGColor);
    
    NSString *r = [NSString stringWithFormat:@"%@",[Common  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[Common  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[Common  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

//十进制转十六进制
+(NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[[NSString alloc]initWithFormat:@"%i",ttmpig] autorelease];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[[NSString alloc]initWithFormat:@"%i",tmp] autorelease];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return [endtmp autorelease];
}


+(id)JsonResultFromFileName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    
    NSString *jsonString = [[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] autorelease];
    NSData *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //    return [[CJSONDeserializer deserializer] deserialize:data error:nil];
    return nil;
}
+(MBProgressHUD*)showLoadingWithInView:(UIView*)iv{
    MBProgressHUD *progressHUD = (MBProgressHUD*)[iv viewWithTag:LOADINGTAG];
    if (nil == progressHUD) {
        progressHUD=[[MBProgressHUD alloc] initWithView:iv];
        progressHUD.labelText = @"加载中...";
        [progressHUD show:YES];
        progressHUD.tag = 987;
        progressHUD.center = [iv convertPoint:[[UIApplication sharedApplication].delegate window].center fromView:[[UIApplication sharedApplication].delegate window] ];
        [iv addSubview:progressHUD];
        [iv bringSubviewToFront:progressHUD];
        [progressHUD release];
    }
    
    return progressHUD;
}

+(void)hideLoadingFromView:(UIView*)iv{
    MBProgressHUD *progressHUD = (MBProgressHUD*)[iv viewWithTag:LOADINGTAG];
    if(progressHUD)
    {
        [progressHUD removeFromSuperview];
        progressHUD = nil;
    }
}

+(UIImage*)imageFromBundleWithName:(NSString *)name
{
    NSString *path= [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    return [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
}

+(BOOL)judgeExistProName:(NSString *)proName
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray *parentMenuArray = [userDefault objectForKey:@"parentmenuList"];
    for (int i=0; i<[parentMenuArray count]; i++) {
        NSDictionary *dict = [parentMenuArray objectAtIndex:i];
        
        if ([proName isEqualToString:[dict objectForKey:@"menuname"]])
            return YES;
        
        NSString *isList = [dict objectForKey:@"isList"];
        if ([isList isEqualToString:@"1"]) {
            NSArray *childMenuArray = [dict objectForKey:@"childmenuname"];
            for (int i=0; i<[childMenuArray count]; i++) {
                NSDictionary *dictionary = [childMenuArray objectAtIndex:i];
                if ([proName isEqualToString:[dictionary objectForKey:@"menuname"]])
                    return YES;
            }
        }
    }
    return NO;
}

+(BOOL)judgeEmailFormat:(NSString *)eamil
{
    if ([eamil isMatchedByRegex:@"([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"])
        return YES;
    return NO;
}

+(BOOL)judgeTelNumFormat:(NSString *)telnum
{
    if ([telnum isMatchedByRegex:@"^0?\\d{11}$"])
        return YES;
    return NO;
}


#pragma mark-
#pragma Be in Common Used Metnod
+(void)changeTableViewSeparatorLine:(UITableView*)table Cell:(UITableViewCell*)cell IndexPath:(NSIndexPath*)indexPath
{
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSUInteger height = [table rectForRowAtIndexPath:indexPath].size.height;
    UIImageView* darkline = (UIImageView*)[cell.contentView viewWithTag:14];
    if (darkline == nil) {
        darkline = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-1, MRScreenWidth, 1)];
        darkline.image = [Common imageFromBundleWithName:@"tableline"];
        [cell.contentView addSubview:darkline];
        darkline.tag = 14;
        [darkline release];
    }
}

+(BOOL)compareOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    [dateFormatter release];
    if (result == NSOrderedDescending) {
        return YES;
    }
    else if (result == NSOrderedAscending){
        return NO;
    }
    return NO;
}

@end
@implementation NSString(ex_methods)
- (NSString*)UTF_8{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSObject (ex_methods)
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig)
    {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        [invo setArgument:&p1 atIndex:2];
        [invo setArgument:&p2 atIndex:3];
        [invo setArgument:&p3 atIndex:4];
        [invo invoke];
        if (sig.methodReturnLength) {
            id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}
@end

@implementation NSURL (ex_methods)
+ (NSURL*)URLWithStringEncode:(NSString*)urlString{
    NSString *decodeString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:decodeString];
}
@end

/************************************适配iphone5******************************************/
@implementation  NSObject(Adaptation_Methods)

-(CGFloat)getHeight:(CGFloat)originHeight{
    
    CGFloat height = originHeight;
    if (1) {
        height+=88;
    }
    return height;
    
}
@end

