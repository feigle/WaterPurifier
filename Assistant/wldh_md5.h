//
//  wldh_md5.h
//  UXinClient
//
//  Created by Liam on 11-7-22.
//  Copyright 2011 D-TONG-TELECOM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface wldh_md5 : NSObject
{

}

+(wldh_md5*)shareUtility;

- (NSString *) md5:(NSString *)str ;

@end
