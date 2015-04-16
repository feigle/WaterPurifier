//
//  JLAES+JLAdditions.h
//  VideoMonitor
//
//  Created by Joblee on 14-10-21.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData(JLAES)
+(NSData *)AESDecryptWithString:(NSString *)targetString;
/**
 *  AES加密并进行16进制转换
 *
 *  @param targetString 目标字符串
 *
 *  @return 十六进制字符串
 */
+(NSData *)AESEncryptWithString:(NSString *)targetString;
+(NSData *)AESDecryptWithData:(NSData *)targetData;
+(NSData *)AESEncryptWithData:(NSData *)targetData;
+(void)test;
@end
