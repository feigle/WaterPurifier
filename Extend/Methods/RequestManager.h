//
//  RequestManager.h
//  VideoMonitor
//
//  Created by Joblee on 14-10-15.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define kAESKey			@"bjdz@2014ABCDEFG"
#define kAESIv          @"0123456789ABCDEF"
#import "zlib.h"



#import "ASIHTTPRequest.h"

/**
 向服务器请求服务的方式：同步/异步
 */
typedef enum
{
    SynchronousType,        //同步
    AsynchronousType        //异步
}RequestType;
@protocol RequestManagerDelegate <NSObject>
@required
/**
 *  向服务器请求服务成功后调用这个委托函数
 *
 *  @param retqust    请求对象
 *  @param dic        服务器返回数据
 *  @param requestTag 请求标签（区别请求）
 */
-(void)requestFinish:(ASIHTTPRequest*)retqust Data:(NSDictionary *)data  RequestTag:(NSString*)requestTag;
@optional
/**
 *  向服务器请求服务失败后调用这个委托函数
 *
 *  @param retqust    请求对象
 *  @param requestTag 请求标签（区别请求）
 */
-(void)requestFailed:(ASIHTTPRequest*)retqust RequestTag:(NSString*)requestTag ;

/**
 *  接收请求头信息
 *
 *  @param request         请求对象
 *  @param responseHeaders 请求头
 *  @param requestTag      请求标签（区别请求)
 */
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders RequestTag:(NSString*)requestTag;
@end

@class NSURL;
@class ASIHTTPRequest;

/*******************************************************************/
@interface RequestManager : NSObject
{
    //向服务器请求的URL
    NSURL                       *_requestURL;
    //请求服务出错的信息
    NSString                    *_feedbackString;
    
}

@property(retain)           NSURL *requestURL;
@property(nonatomic,assign) id<RequestManagerDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *requestArr;


/**
 *  功能：取消所有网络请求
 */
-(void)stopAllRequest;

/**
 *  根据request的标签来取消网络请求
 *
 *  @param requstTag 标签
 */
-(void)stopRequestWithTag:(NSString*)requestTag;

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
-(NSData *)requestWithType: (RequestType)requestType RequestTag: (NSString*)requestTag Parameters: (NSDictionary *)parameters Action:(NSString*)action;

/**
 *  向服务器提交表单(post)
 *
 *  @param httpServerType     请求方式（同步/异步）
 *  @param netPhoneServerType 请求标签
 *  @param data                表单数据
 *  @param action             动作类型
 */
-(void)requestWithType: (RequestType)requestType RequestTag: (NSString*)requestTag FormData: (NSDictionary *)data Action:(NSString*)action;

/**
 *  获取单例
 *
 *  @return 单例
 */
+(RequestManager *)share;
@end

