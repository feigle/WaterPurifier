//
//  JLAES+JLAdditions.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-21.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "JLAES+JLAdditions.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define kAESKey			@"bjdz@2014ABCDEFG"
#define kAESIv          @"0123456789ABCDEF"
#import "zlib.h"
@implementation NSData(JLAES)
#pragma mark --AES128加解密
/**
 *  AES128加解密
 *
 *  @param operation 操作类型（加密/解密）
 *  @param key       密钥
 *  @param iv        加密向量
 *
 *  @return 加密后的数据
 */
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128Operation:kCCEncrypt key:key iv:iv];
}

- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128Operation:kCCDecrypt key:key iv:iv];
}
+(void)test
{
    NSData *data = [self AESEncryptWithString:@"123"];
//    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSData *deData = [data AES128DecryptWithKey:kAESKey iv:kAESIv];
    NSString *deString = [[NSString alloc]initWithData:deData encoding:NSUTF8StringEncoding];
}
#pragma mark --AES加密并进行16进制转换

/**
 *  AES加密
 *
 *  @param targetString 目标字符串
 *
 *  @return 加密后数据
 */
+(NSData *)AESEncryptWithString:(NSString *)targetString
{
    
    NSData *data_sec = [targetString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *en_data = [data_sec AES128EncryptWithKey:kAESKey iv:kAESIv];//加密
    return en_data;
}
#pragma mark --AES加密并进行16进制转换
/**
 *  AES解密
 *
 *  @param targetString 目标字符串
 *
 *  @return 解密后数据
 */
+(NSData *)AESDecryptWithString:(NSString *)targetString
{
    NSData *data_sec = [targetString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *en_data = [data_sec AES128DecryptWithKey:kAESKey iv:kAESIv];//解密
    return en_data;
}
+(NSData *)AESDecryptWithData:(NSData *)targetData
{
    return [targetData AES128DecryptWithKey:kAESKey iv:kAESIv];;
}
+(NSData *)AESEncryptWithData:(NSData *)targetData
{
    return [targetData AES128EncryptWithKey:kAESKey iv:kAESIv];
}
@end
