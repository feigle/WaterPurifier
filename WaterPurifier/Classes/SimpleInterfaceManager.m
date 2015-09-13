//
//  SimpleInterfaceManager.m
//  WaterPurifier
//
//  Created by 李剑波 on 15/5/9.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "SimpleInterfaceManager.h"

@implementation SimpleInterfaceManager
-(void)resetPassWord
{
//url:http://localhost/user/resetPassword
//post:{"account":xxxxxxxxxx}
//    return:
//    right=>{"activationid":1}
//    wrong=>{"state":xxxxxxxxxxxxxxxx,"Msg":xxxxxxxxxxxxxxx}
    RequestManager *request = [RequestManager share];
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *account = [kUD objectForKey:@"account"];
    [formData setValue:account    forKey:@"account"];
    
    [request requestWithType:AsynchronousType RequestTag:@"resetPassword" FormData:formData Action:@"resetPassword"];
    
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders RequestTag:(NSString *)requestTag
{

}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{

}

@end
