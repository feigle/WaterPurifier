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

@interface SettingViewController ()<MADeviceManagerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *deviceListView;
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;
@property (nonatomic, weak) IBOutlet UITextField *ssidTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;

@end

@implementation SettingViewController
{
    NSMutableArray *devices;
    MADevice *currentDevice;
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


//  设置AP服务器模式命令： AT+NETP=TCP,Server,8899,10.10.10.254
//       设置wifi用户名：AT+WSSSID=用户名(用户名)
//         设置wifi密码：AT+WSKEY=WPA2PSK,TKIP/AES,密码(用户名)
- (IBAction)sendCmd:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - 1000;
    if (currentDevice.mode == COMMAND_MODE) {
        NSString *commandStr = nil;
        if (tag == 0) {
            commandStr = @"AT+NETP=TCP,Server,8899,10.10.10.254";
//            commandStr = self.keyTextField.text;
        }else if (tag == 1) {
            commandStr = self.ssidTextField.text;
        }else if (tag == 3) {
            commandStr = @"AT+Z";
        }
        [currentDevice sendCommandToDevice:commandStr];
    }else {
        NSString *commandStr = nil;
        if (tag == 2) {
            commandStr = self.phoneTextField.text;
        }
        [currentDevice sendTransString:[NSString stringWithFormat:@"ph:%@%@#", commandStr, [self handlePhoneNum:commandStr]]];
    }
}

- (IBAction)enterCommandMode:(id)sender
{
    if (currentDevice) {
        [currentDevice enterCommandMode];
    }
}

- (IBAction)enterTransMode:(id)sender
{
    if (currentDevice) {
        [currentDevice enterTransMode];
    }
}


- (void)deviceManager:(MADeviceManager *)deviceManager didDiscoveredDevice:(MADevice *)device
{
    [devices addObject:device];
    [self.deviceListView reloadData];
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
    [currentDevice startDevice];
}

- (void)dealloc
{
    if (currentDevice) {
        [currentDevice endDevice];
        currentDevice = nil;
    }
}

@end
