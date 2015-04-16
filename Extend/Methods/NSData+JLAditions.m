//
//  NSData+JLAditions.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-20.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "NSData+JLAditions.h"

#import "zlib.h"

@implementation NSData(Additions)
+(NSData*)share
{
    static NSData *_data = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _data = [[self alloc] init];
    });
    return _data;
}




#pragma mark --解压zip数据

/**
 *  解压zip数据
 *
 *  @return
 */
- (NSData *)unzipData
{
    if ([self length] == 0)
        return self;
    unsigned full_length = [self length];
    unsigned half_length = [self length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length +     half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = [self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    while (!done){
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    if (done){
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    return nil;
}

@end


