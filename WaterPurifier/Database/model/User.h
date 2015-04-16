//
//  User.h
//  WaterPurifier
//
//  Created by bjdz on 15-4-7.
//  Copyright (c) 2015年 joblee. All rights reserved.
///

//#import <STDbKit/STDbObject.h>
#import "STDbObject.h"

enum AuthorityFlag {
    kAuthorityFlagAdmin = 1 << 0,
    kAuthorityFlagUser  = 1 << 1,
    };

enum SexType {
    kSexTypeMale = 0,
    kSexTypeFemale = 1,
    };

@interface User : STDbObject
/** 唯一标识id */
@property (assign, nonatomic) int _id;
/** 姓名 */
@property (strong, nonatomic) NSString *name;
/** 年龄 */
@property (assign, nonatomic) NSInteger age;
/** 性别 */
@property (strong, nonatomic) NSNumber *sex;
/** 电话号码 */
@property (strong, nonatomic) NSString *phone;
/** 邮箱 */
@property (strong, nonatomic) NSString *email;
/**
 *  uid
 */
@property (strong, nonatomic) NSString *uid;
/** 头像 */
@property (strong, nonatomic) NSData *image;
/** 出生日期 */
@property (strong, nonatomic) NSDate *birthday;
/** 其他信息 */
@property (strong, nonatomic) NSDictionary *info;
/** 爱好 */
@property (strong, nonatomic) NSArray *favs;

@end
