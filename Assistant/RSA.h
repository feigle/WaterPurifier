//
//  RSA.h
//  WaterPurifier
//
//  Created by 李剑波 on 15/4/27.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;

@end