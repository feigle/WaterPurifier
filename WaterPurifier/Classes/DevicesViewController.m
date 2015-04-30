//
//  DevicesViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//
#import "Macros.h"
#import "DevicesViewController.h"

#import "MessageDetailViewcontroller.h"
#define cell_h 60
#define cellSpace 30
#define camaraLabel_tag 5554
#define titleLabel_tag 5555
#define weekLabel_tag 5556
#define detailLabel_tag 5557
#define pointImg_tag 3243
#define line_tag 65567
#define RTag @"getSelfDevice"
#define RAction @"user/getSelfDevice"
@interface DevicesViewController ()<UIActionSheetDelegate,RequestManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TDS1Value;
@property (weak, nonatomic) IBOutlet UILabel *before;
@property (weak, nonatomic) IBOutlet UILabel *TDS2Value;
@property (weak, nonatomic) IBOutlet UILabel *after;
@property (weak, nonatomic) IBOutlet UILabel *totalWater;

@end

@implementation DevicesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备";
    //请求信息
    [self requestInfo];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    
    
}





- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}



- (IBAction)moreWaterButtonClick:(id)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    MessageDetailViewcontroller*vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailViewcontroller"];
    vc.tabBarController.view.hidden = YES;
    vc.infoDic = [deviceArray objectAtIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --请求设备信息
- (void)requestInfo
{
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid    forKey:@"openid"];
    [formData setValue:token     forKey:@"token"];
    
    [request requestWithType:AsynchronousType RequestTag:RTag FormData:formData Action:RAction];
}

-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
        [self initDataModle:data];
        
    }else{
        [self showAlert:@"获取设备信息失败！"];
    }
}
#pragma mark --建立数据模型
- (void)initDataModle:(NSDictionary *)dic
{
    deviceArray = [dic objectForKey:@"devices"];
    
    if ([deviceArray count]<1) {
        [self showAlert:@"您还未添加设备，请添加!"];
    }else{
        NSDictionary *infoDic = [deviceArray objectAtIndex:0];
        self.TDS1Value.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"tds1"]];
        self.TDS2Value.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"tds2"]];
//        self.before.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@""]];
//        self.after.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@""]];
        self.totalWater.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"water"]];
    }
}
#pragma mark --初始化tableview

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
