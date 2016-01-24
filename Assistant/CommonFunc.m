//
//  CommonFunc.m
//  WaterPurifier
//
//  Created by bjdz on 15-2-5.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "CommonFunc.h"
#import "Reachability.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation CommonFunc





// 字节码转换为十六进制字符串
// vByte    :   字节码地址
// vLen     :   长度
// 返回值，char*，返回转换后的16进制字符串，空间新分配，需手动释放
+ (char*) ByteToHex:(const unsigned char*) vByte length:(const int)vLen
{
    if(!vByte)
        return NULL;
    
    char* tmp = (char *)malloc(vLen * 2 + 1); // 一个字节两个十六进制码，最后多一个'\0'
    
    int tmp2;
    for (int i = 0; i < vLen; ++i)
    {
        tmp2 = (int)(vByte[i]) / 16;
        tmp[i * 2] = (char)(tmp2 + ((tmp2 > 9) ? 'A'-10 : '0'));
        tmp2 = (int)(vByte[i]) % 16;
        tmp[i * 2 + 1] = (char)(tmp2 + ((tmp2 > 9) ? 'A' -10 : '0'));
    }
    
    tmp[vLen * 2] = '\0';
    return tmp;
}

// 十六进制字符串转换为字节码(注意要大写字母)
// szHex    :   十六进制字符串
// 返回值，unsigned char*，返回转换后的字节码地址，空间新分配，需手动释放
+ (unsigned char*) HexToByte:(const char*) szHex
{
    if(!szHex)
        return NULL;
    
    int iLen = (int)strlen(szHex);
    
    if (iLen <= 0 || 0 != iLen % 2)
        return NULL;
    
    unsigned char* pbBuf = (unsigned char *)malloc(iLen / 2);  // 数据缓冲区
    
    int tmp1,tmp2;
    for (int i = 0; i < iLen / 2; ++i)
    {
        tmp1 = (int)szHex[i * 2] - (((int)szHex[i * 2] >= 'A') ? 'A' - 10 : '0');
        
        if(tmp1 >= 16)
            return NULL;
        
        tmp2 = (int)szHex[i * 2 + 1] - (((int)szHex[i * 2 + 1] >= 'A') ? 'A' - 10 : '0');
        
        if(tmp2 >= 16)
            return NULL;
        
        pbBuf[i] = (tmp1 * 16 + tmp2);
    }
    
    return pbBuf;
}

// 获取电话当前网络类型
+ (PhoneNetType) GetCurrentPhoneNetType
{
    PhoneNetType nPhoneNetType = PNT_UNKNOWN;
    
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_WIFI;
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_2G3G;
    }
    
    return nPhoneNetType;
}

// 判断字符串是否包含汉字
// string : 需要判断的字符串
+ (BOOL) IsContainChinese:(NSString*)string;
{
    for(int i = 0; i < [string length]; ++i)
    {
        unichar a = [string characterAtIndex:i];
        if(a >= 0x4e00 && a <= 0x9fff)
        {
            return YES;
        }
    }
    
    return NO;
}

// 字符串是否是纯数字
+ (BOOL) IsNSStringPureInt:(NSString *) string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

// 时间转换
+ (NSString *) intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    [date setDateFormat:@"H"];
    int today =   [[date stringFromDate:dat] intValue] *3600;
    
    [date setDateFormat:@"m"];
    
    today +=  [[date stringFromDate:dat] intValue]*60;
    
    NSTimeInterval cha= now - late;
    
    if (cha < today)
    {
        [date setDateFormat:@"HH:mm"];
        
        timeString=[date stringFromDate:d];
    }
    else if (cha >today &&cha< today +24*3600)
    {
        timeString=@"昨天";
    }
    else
    {
        [date setDateFormat:@"M月d日"];
        
        timeString=[date stringFromDate:d];
    }
    [date release];
    return timeString;
}

//获取手机的MAC地址
+(NSString *)getMacAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
+(void)pushViewController:(UINavigationController*)nv andControllerID:(NSString*)vcID andStoryBoard:(UIStoryboard*)storyboard
{
    
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:vcID];
    
    [nv pushViewController:vc animated:YES];
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}
@end

