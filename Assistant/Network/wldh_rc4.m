//
//  wldh_rc4.m
//  LogicLayer
//
//  Created by Teddy on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "wldh_rc4.h"
#import "rc4.h"

@implementation wldh_rc4

+(NSString *)encrypt_rc4: (NSString *)aInput key: (NSString *)aKey
{
    NSString *result = aInput;
    
    RC4_KEY key;
	unsigned char *p = NULL;
    
	p = (unsigned char *)[aKey cStringUsingEncoding:NSISOLatin1StringEncoding];
	RC4_set_key(&key, [aKey length], p);
    
    aInput = [aInput lowercaseString];
    unsigned char* src = (unsigned char *)[aInput cStringUsingEncoding:NSISOLatin1StringEncoding];
	int nLen = [aInput length];
    
	unsigned char *pStrReaultEncrypt = (unsigned char *)malloc(nLen + 1);
    
	RC4(&key, nLen, src, pStrReaultEncrypt);
	pStrReaultEncrypt[nLen] = 0;
    
    result = [NSString stringWithCString:(char *)pStrReaultEncrypt encoding:NSISOLatin1StringEncoding];
    free(pStrReaultEncrypt);
    
    return result;
}

@end
