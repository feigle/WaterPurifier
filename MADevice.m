//
//  MADevice.m
//  WaterPurifier
//
//  Created by 马腾飞 on 15/8/22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MADevice.h"
#import "Reachability.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "MABaseDataConfig.h"

@interface MADevice ()

@property (nonatomic, assign) NSInteger sd_tcp;

@end

@implementation MADevice
{
    // upd客户端地址
    struct sockaddr_in udp_clientAddr;
    // tcp服务端地址
    struct sockaddr_in tcp_serverAddr;
    BOOL start;
}

// 启动设备
- (void)startDevice
{
    if (!start) {
        self.sd_tcp = -1;
        self.sd_udp = -1;
        [self setUpUdpClient];
        [self tcp_connect];
        self.mode = TRANS_MODE;
        if (!start) {
            start = YES;
            [self performSelectorInBackground:(@selector(sendKeepAlive)) withObject:nil];
        }
    }
}

// 配置设备地址
- (BOOL)setUpUdpClient{
    //build up udp socket,act as a udp client
    if  ([self.ip isEqualToString:@"0.0.0.0"]) {
        return 0;
    }
    char server[255];
    bzero(server,255);
    struct hostent *hostp_udp = NULL;
    //udp socket
    /*if udp setup ok than change mode to command_mode*/
    strcpy(server,[self.ip UTF8String]);
    memset(&udp_clientAddr, 0x00, sizeof(struct sockaddr_in));
    udp_clientAddr.sin_family = AF_INET;
    udp_clientAddr.sin_port = htons(HF11A_SOCKET_PORT);
    if((udp_clientAddr.sin_addr.s_addr = inet_addr(server)) == (unsigned long)INADDR_NONE) {
        memcpy(&udp_clientAddr.sin_addr, hostp_udp->h_addr, sizeof(udp_clientAddr.sin_addr));
    }
    
    // 创建一个ip4，数据报，UDP协议的socket
    if (self.sd_udp > 0) {
        close(self.sd_udp);
        self.sd_udp = -1;
    }
    self.sd_udp = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (self.sd_udp < 0) {
        NSLog(@"socket init failer!");
        self.sd_udp = -1;
        if ([self.delegate respondsToSelector:@selector(deviceConnectFailed:withError:)]) {
            [self.delegate deviceConnectFailed:self withError:@"UDP soket create failed"];
        }
        return NO;
    }
    // If we don't call bind() here, the system decides on the port for us, which is not we want.So below code is to set local port to 48899
    struct sockaddr_in sin;
    memset(&sin,0,sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(HF11A_SOCKET_PORT);
    sin.sin_addr.s_addr = INADDR_ANY;
    if (-1 == bind(self.sd_udp,(struct sockaddr *)&sin,sizeof(struct sockaddr_in)))
    {
        NSLog(@"upd socket bind error!");
        if ([self.delegate respondsToSelector:@selector(deviceConnectFailed:withError:)]) {
            [self.delegate deviceConnectFailed:self withError:@"UDP soket bind port failed"];
        }
        // 关闭socket
        close(self.sd_udp);
        self.sd_udp = -1;
        return NO;
    }else {
        if ([self.delegate respondsToSelector:@selector(deviceConnectSuccess:)]) {
            [self.delegate deviceConnectSuccess:self];
        }
        [self performSelectorInBackground:(@selector(receivePacketFromDevice)) withObject:nil];
    }

    return YES;
}

// 保持设备心跳
- (void)sendKeepAlive{
    while(1){
        sleep(30000000);
        char cmd[256];
        bzero(cmd,256);
        NSString * commandToSend = @"AT+W";
        const char * command = [commandToSend UTF8String];
        strcpy(cmd,command);
        if ((strcmp(cmd,"+ok") != 0) && (strcmp(cmd,"HF-A11ASSISTHREAD") != 0)) {
            // if the command is not "+ok", than add 0x0d to the end.
            strcat(cmd,"a");
            //set last byte (a)  0x0d return to end.
            memset(cmd + strlen(cmd) - 1, 0x0d, 1);
        }
        
        NSInteger size = sendto(self.sd_udp, cmd, strlen(cmd), 0, (struct sockaddr *)&udp_clientAddr, sizeof(udp_clientAddr));
        
        if(size < 0)
        {
            NSLog(@"udp client - sendto() error!");
            break;
        }else {
            NSLog(@"send %s\n",cmd);
        }
    }
}

- (int)receivePacketFromDevice{
    char buffer[COMMAND_OUTPUT_BUF];
    char *bufptr = buffer;
    int buflen = sizeof(buffer);
    // receive
    struct sockaddr_in udp_serveraddr;
    int server_addr_len = sizeof(udp_serveraddr);

    if (self.sd_udp <= 0) {
        NSLog(@"this is receving socket, sd_udp <0");
        return 1;
    }

    while(1) {
        bzero(bufptr,COMMAND_OUTPUT_BUF);
        int size = recvfrom(self.sd_udp, bufptr, buflen, 0, (struct sockaddr *)&udp_serveraddr, (socklen_t *)&server_addr_len);
        if(size < 0) {
            perror("UDP Server - recvfrom() error");
            if ([self.delegate respondsToSelector:@selector(deviceSendMsgFailed:)]) {
                [self.delegate deviceSendMsgFailed:self];
            }
            break;
        }else {
            printf("UDP Server - recvfrom() is OK...\n");
            // recevice data
            // add code here
            typeof(self) __weakSelf = self;
            NSString *retStr = nil;
            if (strlen(buffer) > 0) {
                retStr = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(deviceSendMsgSuccess:withReturnStr:)]) {
                    [__weakSelf.delegate deviceSendMsgSuccess:__weakSelf withReturnStr:retStr];
                }
                NSLog(@"data : %@", retStr);
            });
            
        }
    }
    return 0;
}
// 13824473816
-(int)receiveTCPPacketFromDevice{
    //wait TCP server (HF A11) response
    char rec_buf[2048];
    while(1) {
        bzero (rec_buf,2048);
        ssize_t size = read(self.sd_tcp,rec_buf,sizeof(rec_buf));
        if(size < 0)
        {
            NSLog(@"sd_tcp read data error!");
            close(self.sd_tcp);
            self.sd_tcp = -1;
            break;
        }
        //parse recevied string,   "ip,mac,model id"
        NSString* string = [NSString stringWithFormat:@"%s" , rec_buf];
        //remove \n
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        // recevie data
        // add code here
        NSLog(@"tcp: %@", string);
    }
    return 0;
}


// 发送命令接口
- (int)sendCommandToDevice:(NSString*)commandToSend
{
    // 设备未启动
    if (!start) {
        return 0;
    }
    char cmd[256];
    bzero(cmd,256);
    const char *command=[commandToSend UTF8String];
    strcpy(cmd,command);
    if ((strcmp(cmd, "+ok") != 0) && (strcmp(cmd, "HF-A11ASSISTHREAD") != 0)){
        // if the command is not "+ok", than add 0x0d to the end.
        strcat(cmd, "a");
        printf("4  %s\n", cmd);
        //set last byte (a)  0x0d return to end.
        memset(cmd + strlen(cmd) - 1, 0x0d, 1);
    }
    NSInteger size = sendto(self.sd_udp, cmd, strlen(cmd), 0, (struct sockaddr *)&udp_clientAddr, sizeof(udp_clientAddr));
    
    if(size < 0)
    {
        NSLog(@"udp client - sendto() error");
    }else {
        NSLog(@"Send %s\n",cmd);
    }
    return 0;
}

// 发送透传数据
- (int)sendTransString:(NSString*)commandString
{
    // 设备未启动
    if (!start) {
        return 0;
    }
    if (self.sd_tcp < 0) {
        [self tcp_connect];
    }
    //write command
    char cmd[2048];
    bzero(cmd,2048);
    //trim return
    commandString = [commandString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    const char * command=[commandString UTF8String];
    strcpy(cmd,command);
    
    ssize_t size = write(self.sd_tcp, cmd, strlen(cmd));
    if(size < 0)
    {
        close(self.sd_tcp);
        self.sd_tcp = -1;
        // 重新建立tcp连接
        [self tcp_connect];
    }
    return 0;
}

- (int)tcp_connect {
    struct hostent *hostp_tcp = NULL;
    /* get a socket descriptor */
    char server_ip[100];
    bzero(server_ip,100);
    //point to device ip
    strcpy(server_ip,  [self.ip UTF8String]);
    if (strcmp(server_ip,"0.0.0.0") == 0)
    {
        return -1;
    }else {
        if (self.sd_tcp > 0) {
            close(self.sd_tcp);
            self.sd_tcp = -1;
        }
        //enable ip and port
        if((self.sd_tcp = socket(AF_INET, SOCK_STREAM, 0)) < 0)  {
            NSLog(@"tcp socket init error!");
            //*Check accessbility of target ip, if fail pop up msgbox.
            return 0;
        }else {
            NSLog(@"tcp client init success!");
        }
        
        memset(&tcp_serverAddr, 0x00, sizeof(struct sockaddr_in));
        tcp_serverAddr.sin_family = AF_INET;
        tcp_serverAddr.sin_port = htons(TCP_T_TRANS_PORT);
        if((tcp_serverAddr.sin_addr.s_addr = inet_addr(server_ip)) == (unsigned long)INADDR_NONE)
        {
            memcpy(&tcp_serverAddr.sin_addr, hostp_tcp->h_addr, sizeof(tcp_serverAddr.sin_addr));
        }
        //change the connect icon for different state
        /* connect() to server. */
        NSInteger status = connect(self.sd_tcp, (struct sockaddr *)&tcp_serverAddr, sizeof(tcp_serverAddr));
        if(status < 0) {
            close(self.sd_tcp);
            self.sd_tcp = -1;
            NSLog(@"client connect error!");
            return -1;
        }else {
            NSLog(@"Connection established......");
            if (![self.ip isEqualToString:@"0.0.0.0"])
            {
                [self performSelectorInBackground:(@selector(receiveTCPPacketFromDevice)) withObject:nil];
            }
        }
    }
    return 0;
}

#pragma mark - 进入命令模式
- (void)enterCommandMode
{
    // 设备未启动
    if (!start) {
        return;
    }
    if (self.mode == COMMAND_MODE) {
        return;
    }
    if (self.sd_udp == -1) {
        [self setUpUdpClient];
    }
    if (![self.ip isEqualToString:@"0.0.0.0"])
    {
        //send password:  HF-A11ASSISTHREAD
        [self sendCommandToDevice:@"HF-A11ASSISTHREAD"];
        //send +ok to enter command mode
        [self sendCommandToDevice:@"+ok"];
        self.mode = COMMAND_MODE;
    }
}

#pragma mark - 进入透传模式
- (void)enterTransMode
{
    // 设备未启动
    if (!start) {
        return;
    }
    if (self.mode == TRANS_MODE) {
        return;
    }
    
    if (self.sd_tcp < 0) {
        [self tcp_connect];
    }
    
    if (self.sd_tcp < 0) {
        NSLog(@"芯片未启用tcp服务器或手机未连接网络!");
        return;
    }
    if (![self.ip isEqualToString:@"0.0.0.0"])
    {
        if (self.sd_udp > 0) {
            [self sendCommandToDevice:@"AT+Q"];
            self.mode = TRANS_MODE;
        }
    }
}

// 结束设备
- (void)endDevice
{
    self.sd_tcp > 0 ? close(self.sd_tcp) : 1;
    self.sd_udp > 0 ? close(self.sd_udp) : 1;
}

@end
