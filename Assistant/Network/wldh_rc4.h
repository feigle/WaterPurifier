//
//  wldh_rc4.h
//  LogicLayer
//
//  Created by Teddy on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wldh_rc4 : NSObject
{
}

+(NSString *)encrypt_rc4: (NSString *)aInput key: (NSString *)aKey;

@end
