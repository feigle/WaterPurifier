//
//  MADeviceManager.m
//  WaterPurifier
//
//  Created by 马腾飞 on 15/8/22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MADeviceManager.h"
#import "MADevice.h"
#import "Reachability.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "MABaseDataConfig.h"

@interface MADeviceManager ()

@property (nonatomic, assign) NSInteger SD_Broadcast;
@property (nonatomic, strong) NSTimer *timer;

@end

static MADeviceManager *deviceManager = nil;

@implementation MADeviceManager
{
    // 广播地址
    struct sockaddr_in broadcastAddr;
}

+ (MADeviceManager*)shareInstance
{
    @synchronized(self){
        if (deviceManager == nil) {
            deviceManager = [[MADeviceManager alloc] init];
            // 设置socket des 默认值为 -1
            deviceManager.SD_Broadcast = -1;
        }
    }
    return deviceManager;
}

#pragma mark 配置UDP客户端广播地址
- (BOOL)setupUDPClient {
    if (self.SD_Broadcast != -1) {
        close(self.SD_Broadcast);
    }
    // 创建一个ip4，数据报，UDP协议的socket
    self.SD_Broadcast = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (self.SD_Broadcast < 0) {
        NSLog(@"Error: Could not open socket");
        self.SD_Broadcast = -1;
        if ([self.delegate respondsToSelector:@selector(deviceManagerSetConfigFailer)]) {
            [self.delegate deviceManagerSetConfigFailer];
        }
        return NO;
    }
    // Set socket options
    // Enable broadcast
    int broadcastEnable = 1;
    int ret = setsockopt(self.SD_Broadcast, SOL_SOCKET, SO_BROADCAST, &broadcastEnable, sizeof(broadcastEnable));
    if (ret) {
        NSLog(@"Error: Could not open set socket to broadcast mode");
        // 关闭socket
        close(self.SD_Broadcast);
        self.SD_Broadcast = -1;
        if ([self.delegate respondsToSelector:@selector(deviceManagerSetConfigFailer)]) {
            [self.delegate deviceManagerSetConfigFailer];
        }
        return NO;
    }
    // 配置广播地址ip及端口
    memset(&broadcastAddr, 0, sizeof broadcastAddr);
    broadcastAddr.sin_family = AF_INET;
    inet_pton(AF_INET, "255.255.255.255", &broadcastAddr.sin_addr);
    broadcastAddr.sin_port = htons(HF11A_SOCKET_PORT); // Set dst port
    
    // If we don't call bind() here, the system decides on the port for us, which is not we want.So below code is to set local port to 48899
    struct sockaddr_in sin;
    memset(&sin,0,sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(HF11A_SOCKET_PORT);
    sin.sin_addr.s_addr = INADDR_ANY;
    if (-1 == bind(self.SD_Broadcast,(struct sockaddr *)&sin,sizeof(struct sockaddr_in)))
    {
        // 关闭socket
        close(self.SD_Broadcast);
        self.SD_Broadcast = -1;
        if ([self.delegate respondsToSelector:@selector(deviceManagerSetConfigFailer)]) {
            [self.delegate deviceManagerSetConfigFailer];
        }
        return NO;
    }else {
        [self performSelectorInBackground:(@selector(receivePacketFromDevice)) withObject:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceManagerSetConfigSuccess)]) {
        [self.delegate deviceManagerSetConfigSuccess];
    }
    return  YES;
}

#pragma mark 接收UDP数据包
- (void)receivePacketFromDevice {
    char buffer[10240];
    char *bufptr = buffer;
    int buflen = sizeof(buffer);
    
    struct sockaddr_in udp_client_addr;
    int udp_client_addr_len = sizeof(udp_client_addr);
    
    while(1) {
        bzero(buffer,10240);
        NSInteger size = recvfrom(self.SD_Broadcast, bufptr, buflen, 0, (struct sockaddr *)&udp_client_addr, (socklen_t *)&udp_client_addr_len);
        // size = -1接收数据不成功， 如果接受数据成功status表示接收数据大小
        if(size < 0) {
            NSLog(@"UDP数据接收出错!");
            break;
        }else {
            NSLog(@"UDP数据接收成功!");
            // 解析字符串格式。 正确格式："ip,mac,model_Id"
            NSString* string = [NSString stringWithFormat:@"%s" , bufptr];
            // 如果字符串不匹配“*，*，*”格式
            NSString *regEx = @"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(.?)){4},[0-9A-Z]{12},[0-9A-Z]*";
            NSRange myRange = [string rangeOfString:regEx options:NSRegularExpressionSearch];
            if (myRange.location != NSNotFound) {
                NSArray *listItems = [string componentsSeparatedByString:@","];
                NSLog(@"成功解析到设备!");
                //add in exception handling here!
                MADevice *current_device = [MADevice new];
                [current_device setMessage:string];
                [current_device setIp:[listItems objectAtIndex:0]];
                [current_device setMac:[listItems objectAtIndex:1]];
                [current_device setModel_Id:[listItems objectAtIndex:2]];
//                [current_device setSd_udp:self.SD_Broadcast];
                // 发现新设备后，回调给委托对象
                if ([self.delegate respondsToSelector:@selector(deviceManager:didDiscoveredDevice:)]) {
                    [self.delegate deviceManager:self didDiscoveredDevice:current_device];
                }
            }
        }
    }
    NSLog(@"break");
}

#pragma mark 发送广播数据包
// 发送广播数据"HF-A11ASSISTHREAD"
- (BOOL)sendBroadcastPacket:(NSString*)cmdString  {
    char buffer[255];
    bzero(buffer,255);
    char request[100];
    bzero(request,100);
    strcpy(request, [cmdString UTF8String]);//"HF-A11ASSISTHREAD";
    int size = sendto(self.SD_Broadcast, request, strlen(request), 0, (struct sockaddr*)&broadcastAddr, sizeof broadcastAddr);
    // 发送失败关闭广播socket
    if (size < 0) {
        NSLog(@"Error:Send broadcast error");
        return NO;
    }
    return YES;
}

// 搜索设备
- (void)scan
{
    // 检查网络状态
    Reachability *wifiReach = [Reachability reachabilityForLocalWiFi] ;
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    if(netStatus == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"This feature requires an WiFI connection,please enable WIFI firstly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    // 配置广播地址
    if ([self setupUDPClient]) {
        // 启动定时器
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scanTimeout) userInfo:nil repeats:NO];
        // 广播数据
        [self sendBroadcastPacket:@"HF-A11ASSISTHREAD"];
    }
}

- (void)scanTimeout
{
    [_timer invalidate];
    _timer = nil;
    // 超时关闭广播socket
    close(self.SD_Broadcast);
    self.SD_Broadcast = -1;
}


@end
