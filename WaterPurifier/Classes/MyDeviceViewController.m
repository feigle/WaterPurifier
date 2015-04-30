//
//  MyDeviceViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "Macros.h"

#define kSpace 10
#define cell_h 200
#define RTag @"getSelfDevice"
#define RAction @"user/getSelfDevice"

@interface MyDeviceViewController ()
@end

@implementation MyDeviceViewController



-(void)viewWillAppear:(BOOL)animated
{
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.tabBarController.tabBar.hidden = NO;
    shuldStatusbarHidden(NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self requestInfo];
}

#pragma mark --菜单
- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

#pragma mark --显示删除相关的视图
- (void)showDleleView
{

}
#pragma mark --请求设备信息
- (void)requestInfo
{

}

-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
        [self initDataModle:data];//建立数据模型
        
    }else{
        [self showAlert:@"获取设备信息失败！"];
    }
}
#pragma mark --建立数据模型
- (void)initDataModle:(NSDictionary *)dic
{
    NSArray *arry = [dic objectForKey:@"devices"];
    
    if ([arry count]<1) {
        [self showAlert:@"您还未添加设备，请添加!"];
    }else{
    }
}
#pragma mark --初始化tableview
- (void)initTableView
{
    

}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{
    [self showAlert:@"网络有误，请稍后重试！"];
}
- (void)showAlert:(NSString*)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
