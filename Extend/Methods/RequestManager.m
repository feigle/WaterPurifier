//
//  RequestManager.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-15.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "RequestManager.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "CJSONSerializer.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
#import "Macros.h"
#define DATA_STORE_PUBLIC_KEY       @"kPublicKey"   //Public_Key
#define TOKEN_FOR_TEST              @"47036906 0ba688df 56df339e 68d9cfcb b4553cfc 0b130d0c 875675d1 ebdaee69"


#define isSec 0
@implementation RequestManager

@synthesize requestURL      = _requestURL;
@synthesize delegate        = _delegate;
@synthesize requestArr      = _requestArr;
#pragma mark --创建一个单例
/**
 *  创建一个单例
 *
 *  @return 返回一个单例
 */
+(RequestManager *)share
{
    static RequestManager *_requestManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _requestManager = [[self alloc] init];
        _requestManager.requestArr = [[NSMutableArray alloc]init];
    });
    return _requestManager;
}
#pragma mark --向服务器请求服务(get)
/**
 *  向服务器请求服务(get)
 *
 *  @param requestType 请求服务的方式（同步/异步）
 *  @param requestTag  请求标签（区别请求)
 *  @param Parameters  请求参数
 *  @param action      请求动作
 *
 *  @return
 */
-(NSData *)requestWithType: (RequestType)requestType RequestTag: (NSString*)requestTag Parameters: (NSDictionary *)parameters Action:(NSString*)action
{
    [[ActivityIndicatorView share]startAnimation];
    //组装请求参数
    CLog(@"Get--URL:\n%@",[self spliceAllAttribute:parameters Action:action]);
    
    //初始化request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithStringEncode: [self spliceAllAttribute:parameters Action:action]]];
    //传递一个标签
    request.requestTag = requestTag;
    //委托
    [request setDelegate: self];
    //集中管理request
    [self.requestArr addObject:request];
    
    if(SynchronousType == requestType)             //同步请求
    {
        
        [request startSynchronous];
        [[ActivityIndicatorView share]stopAnimation];
        return [request responseData];
        
    }
    else if(AsynchronousType == requestType)       //异步请求
    {
        // 禁用持久连接
        [request setShouldAttemptPersistentConnection: NO];
        [request setTimeOutSeconds: 40];
        [request startAsynchronous];
    }
    
    return nil;
}
#pragma mark --向服务器提交表单(post)
/**
 *  向服务器提交表单(post)
 *
 *  @param httpServerType     请求方式（同步/异步）
 *  @param netPhoneServerType 请求标签
 *  @param data               表单数据
 *  @param action             动作类型
 */
-(void)requestWithType:(RequestType)requestType RequestTag:(NSString *)requestTag FormData:(NSDictionary *)data Action:(NSString *)action
{
    
    [[ActivityIndicatorView share]startAnimation];
    
//    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSESSIONID"];
    //URL
    NSURL *URL = nil;
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",HOST,action]];
    CLog(@"Post——requestURL :%@",URL);
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:URL];
    //标签
    request.requestTag = requestTag;
    //委托
    [request setDelegate: self];
    [request setUseCookiePersistence:YES];
    //集中管理request
    [self.requestArr addObject:request];
    //post表单数据
    NSArray *allKeys = [data allKeys];
//    RSA *rsa = [[RSA alloc] init];
    for (NSString *key in allKeys) {
        NSString *values = [data objectForKey:key];
        //RSA加密
//        NSData *encodeData = [rsa encryptWithString:values];
//       values =  [[NSString alloc]initWithData:encodeData encoding:NSUTF8StringEncoding];
        [request setPostValue:values forKey:key];
    }
    //请求方式
    if(SynchronousType == requestType)             //同步请求
    {
        [request startSynchronous];
    }
    else if(AsynchronousType == requestType)       //异步请求
    {
        [request setShouldAttemptPersistentConnection: NO];
        [request setTimeOutSeconds:40];
        [request startAsynchronous];
    }
}
#pragma mark --拼接请求参数
/**
 *  拼接请求参数
 *
 *  @param dic    参数
 *  @param action 动作
 *
 *  @return 拼接后的参数字符串
 */
-(NSString*)spliceAllAttribute:(NSDictionary*)dic Action:(NSString *)action
{
    NSString *attributes = nil;
    NSArray *allKeys = [dic allKeys];
    for (NSString *key in allKeys) {
        if (attributes) {
            attributes = [NSString stringWithFormat:@"%@%@=%@&",attributes,key,[dic objectForKey:key]];
        }else{
            attributes = [NSString stringWithFormat:@"%@=%@&",key,[dic objectForKey:key]];
        }
    }
    //去掉末尾的&
    attributes = [attributes substringToIndex:[attributes length]-1];
    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSESSIONID"];
    NSString *strRequest = [NSString stringWithFormat: @"%@/%@;jsessionids=%@?%@",HOST,action, sessionID,attributes];
    return strRequest;
}

#pragma mark --请求成功
/**
 *  请求成功
 *
 *  @param request
 */
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self removeRequest:request];
    if ([self.requestArr count]<1) {
        [[ActivityIndicatorView share]stopAnimation];
    }
    
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    //获取数据
    NSData *responseData = [request responseData];
    if (isSec) {
        //base64解码
        NSData *infoAES = [GTMBase64 decodeData:responseData];
        //AES128解密
        NSData *tempData = [NSData AESDecryptWithData:infoAES];
        
        NSString *String = [[NSString alloc] initWithData: tempData encoding: NSUTF8StringEncoding];
        returnDic = [[String JSONValue]copy];
    }else{
        NSString *String = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
        if ([request.requestTag isEqualToString:@"getSelfDevice"]) {
            NSString*filePath=[[NSBundle mainBundle] pathForResource:@"testData副本"ofType:@"txt"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
           String = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

            
        }
        NSLog(@"\n\nrequest.url---****---->%@\n\n",request.url);
        NSLog(@"\n\nString-----*******-------->%@\n\n",String);
        returnDic = [[String JSONValue]copy];
    }

    if(_delegate && [_delegate respondsToSelector: @selector(requestFinish:Data:RequestTag:)])
    {
        [_delegate requestFinish:request Data:returnDic RequestTag:request.requestTag];
    }
}
#pragma mark --请求失败
/**
 *  请求失败
 *
 *  @param request
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self removeRequest:request];
    if ([self.requestArr count]<1) {
        [[ActivityIndicatorView share]stopAnimation];
    }
    if(_delegate != nil && [_delegate respondsToSelector: @selector(requestFailed:RequestTag:)])
    {
        [_delegate requestFailed:request RequestTag:request.requestTag];
    }
    [self showNotice:@"网络异常，请稍后重试!"];
//    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络异常，请重试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}
#pragma mark --接收响应头
/**
 *  接收响应头
 *
 *  @param request
 *  @param responseHeaders 响应头
 */
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if(_delegate != nil && [_delegate respondsToSelector: @selector(request:didReceiveResponseHeaders:RequestTag:)])
    {
        [_delegate request:request didReceiveResponseHeaders:responseHeaders RequestTag:request.requestTag ];
    }
}
#pragma mark --从数组中移除request
/**
 *  从数组中移除request
 *
 *  @param request 目标request
 */
-(void)removeRequest:(ASIHTTPRequest*)request
{
    for (int i=0; i<[self.requestArr count]; i++) {
        ASIHTTPRequest *temp = [self.requestArr objectAtIndex:i];
        if ([temp.requestTag isEqualToString:request.requestTag]) {
            [self.requestArr removeObject:temp];
        }
    }
}
#pragma mark --取消网络请求
/**
 *  取消网络请求
 */
-(void)stopAllRequest
{
    for (ASIHTTPRequest *request in self.requestArr) {
        [request clearDelegatesAndCancel];
    }
}
#pragma mark --根据request的标签来取消网络请求
/**
 *  根据request的标签来取消网络请求
 *
 *  @param requstTag 标签
 */
-(void)stopRequestWithTag:(NSString*)requestTag
{
    for (ASIHTTPRequest *request in self.requestArr) {
        if ([request.requestTag isEqualToString:requestTag]) {
            [request clearDelegatesAndCancel];
            [self.requestArr removeObject:request];
            if ([self.requestArr count]<1) {
                [[ActivityIndicatorView share]stopAnimation];
            }
        }
    }
    
}
-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:[UIApplication sharedApplication].keyWindow.rootViewController title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
}
@end

