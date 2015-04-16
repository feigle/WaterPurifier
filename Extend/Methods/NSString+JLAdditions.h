//
//  NSString+JLAdditions.h
//  VideoMonitor
//
//  Created by Joblee on 14-10-20.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
@interface NSString (Additions)
+ (NSString *)HexStringFromData:(NSData *)data;

+ (NSString *)stringFromHexString:(NSString *)hexString;

+ (CGSize)sizeForString:(NSString *)string fontSize:(UIFont*)fontSize withLabelWidth:(float)width;
+ (CGSize)sizeForString:(NSString *)string fontSize:(UIFont*)fontSize withLabelHeight:(float)height;

+ (NSString*)encodeBase64String:(NSString * )input;

+ (NSString*)decodeBase64String:(NSString * )input;

+ (NSString*)encodeBase64Data:(NSData *)data;

+ (NSString*)decodeBase64Data:(NSData *)data;
@end
