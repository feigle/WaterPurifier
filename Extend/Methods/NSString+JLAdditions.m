//
//  NSString+JLAdditions.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-20.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "NSString+JLAdditions.h"

@implementation NSString(Additions)
#pragma mark --进行16进制转换
/**
 *  进行16进制转换
 *
 *  @param data 目标数据
 *
 *  @return 转换后的字符串
 */
+(NSString *)HexStringFromData:(NSData *)data
{
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff]; ///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
#pragma mark --十六进制转字符串
/**
 *  十六进制转字符串
 *
 *  @param hexString 十六进制字符串
 *
 *  @return
 */
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
}

#pragma mark --数据进行base64Encode编码解码

+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
#pragma mark 根据文字计算大小
/**
 *  根据文字及宽度计算Label高度
 *
 *  @param string   需要计算的字符串
 *  @param fontSize 文字大小
 *  @param width    固定的宽度
 *
 *  @return 尺寸
 */
+ (CGSize)sizeForString:(NSString *)string fontSize:(UIFont*)fontSize withLabelWidth:(float)width
{
    CGSize sizeToFit = [string sizeWithFont:fontSize constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
    return sizeToFit;
}
/**
 *  根据文字及高度计算Label宽度
 *
 *  @param string   需要计算的字符串
 *  @param fontSize 文字大小
 *  @param height   固定的高度
 *
 *  @return 尺寸
 */
+ (CGSize)sizeForString:(NSString *)string fontSize:(UIFont*)fontSize withLabelHeight:(float)height
{
    CGSize sizeToFit = [string sizeWithFont:fontSize constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByClipping];
    return sizeToFit;
}

@end
