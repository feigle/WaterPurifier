//
//  SettingViewController.m
//  WaterPurifier
//
//  Created by 马腾飞 on 15/8/24.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "SettingViewController.h"
#import "MADeviceManager.h"
#import "MADevice.h"
#import "WPAppDefault.h"
#import "action.h"
#import "UIView+Toast.h"

@interface SettingViewController ()<MADeviceManagerDelegate, deviceProtocol, UITextFieldDelegate, RequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *deviceListView;
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;
@property (nonatomic, weak) IBOutlet UITextField *ssidTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;

@end

@implementation SettingViewController
{
    NSMutableArray *devices;
    MADevice *currentDevice;
    RequestManager *request;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    devices = [NSMutableArray array];
}

- (IBAction)scan:(id)sender
{
    // 搜索前清空数组
    [devices removeAllObjects];
    if (currentDevice) {
        [currentDevice endDevice];
        currentDevice = nil;
    }
    MADeviceManager *deviceManager = [MADeviceManager shareInstance];
    deviceManager.delegate = self;
    [deviceManager scan];
}

- (NSString *)handlePhoneNum:(NSString *)phoneStr
{
    NSInteger length = phoneStr.length;
    NSInteger sum = 0;
    for (NSInteger i = 0; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *temp = [phoneStr substringWithRange:range];
        sum += [temp integerValue];
    }
    sum = sum % 10;
    return [NSString stringWithFormat:@"%d", sum];
}


- (IBAction)ConfigDevice:(id)sender
{
    
    request = [RequestManager share];
    [request setDelegate:self];
    
    WPAppDefault *appInfo = [WPAppDefault shareInstance];
    NSString *macStr = [appInfo readBindingDeviceMac];
    
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    if (openId) {
        [formData setValue:openId forKey:@"openid"];
    }
    if (token) {
        [formData setValue:token forKey:@"token"];
    }
    if (macStr) {
        [formData setValue:macStr forKey:@"mac"];
    }
    
    
    NSInteger tag = ((UIButton *)sender).tag;
    
//    NSString *action = [NSString stringWithFormat:@"%@?openid=%@&token=%@&mac=%@", BIND, openId, token, macStr];
    if (tag == 2001) {
        // 绑定设备
        [request requestWithType:AsynchronousType RequestTag:@"bind" FormData:formData Action:BIND];
    }else if(tag == 2002){
        // 解绑设备
        [request requestWithType:AsynchronousType RequestTag:@"unbind" FormData:formData Action:UNBIND];
    }
}

- (IBAction)setAT_Command:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    if (tag == 1001) {
        self.keyTextField.text = @"AT+NETP=TCP,Server,8899,10.10.10.254";
    }else if (tag == 1002) {
        self.keyTextField.text = @"AT+WSSSID=TPGuest";
    }else if (tag == 1003) {
        self.keyTextField.text = @"AT+WSKEY=WPAPSK,AES,Wsl13723781464";
    }else if (tag == 1004) {
        NSString *command = self.keyTextField.text;
        if (command.length > 0 && currentDevice.mode == COMMAND_MODE) {
            [currentDevice sendCommandToDevice:command];
        }
    }else if (tag == 1005) {
        self.keyTextField.text = @"AT+Z";
    }
}

// 命令模式
- (IBAction)enterCommandMode:(id)sender
{
    if (currentDevice) {
        [currentDevice enterCommandMode];
    }
}

// 透传模式
- (IBAction)enterTransMode:(id)sender
{
    if (currentDevice) {
        [currentDevice enterTransMode];
    }
}


- (void)deviceManager:(MADeviceManager *)deviceManager didDiscoveredDevice:(MADevice *)device
{
    [devices addObject:device];
    
    if (devices.count > 0) {
        [self.view makeToast:@"搜索到新设备"];
        [self.deviceListView reloadData];
    }
    
}

- (void)deviceManager:(MADeviceManager *)deviceManager didDiscoveredDeviceError:(NSString *)error
{
//    [self.view makeToast:@"未收到设备IP信息"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    MADevice *device = [devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.message;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentDevice) {
        [currentDevice endDevice];
        currentDevice = nil;
    }
    currentDevice = [devices objectAtIndex:indexPath.row];
    currentDevice.delegate = self;
    
    // 保存绑定设备信息
    if (currentDevice) {
        WPAppDefault *appInfo = [WPAppDefault shareInstance];
        [appInfo writeBindingDeviceMac:currentDevice.mac];
    }
    [currentDevice startDevice];
}

// deviceProtocol
- (void)deviceConnectSuccess:(MADevice *)device
{
    [self.view makeToast:@"设备连接成功"];
}

- (void)deviceConnectFailed:(MADevice *)device withError:(NSString *)errorString
{
    [self.view makeToast:errorString];
}

- (void)deviceSendMsgSuccess:(MADevice *)device withReturnStr:(NSString *)retStr
{
    [self.view makeToast:@"发送成功"];
    NSLog(@"%@", retStr);
}

- (void)deviceSendMsgFailed:(MADevice *)device
{
    [self.view makeToast:@"发送失败"];
}

- (void)dealloc
{
    if (currentDevice) {
        [currentDevice endDevice];
        currentDevice = nil;
    }
}

@end
