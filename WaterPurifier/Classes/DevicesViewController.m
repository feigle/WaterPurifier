//
//  DevicesViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//
#import "Macros.h"
#import "DevicesViewController.h"
#import "IndicatorViewCustom.h"
#import "FilterViewcontroller.h"

#define RTag @"getSelfDevice"
#define RAction @"user/getSelfDevice"
@interface DevicesViewController ()<UIActionSheetDelegate,RequestManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TDS1Value;
@property (weak, nonatomic) IBOutlet UILabel *before;
@property (weak, nonatomic) IBOutlet UILabel *TDS2Value;
@property (weak, nonatomic) IBOutlet UILabel *after;
@property (weak, nonatomic) IBOutlet UILabel *totalWater;

@property (weak, nonatomic) IBOutlet UIView *TDS1Content;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation DevicesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备";
    //请求信息
    [self requestInfo];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    
    //加载圆圈
    IndicatorViewCustom * indicatorView = [[IndicatorViewCustom alloc]init];
    indicatorView.frame = CGRectMake(0, 0, 320/3,self.view.frame.size.width/3);
    indicatorView.center = CGPointMake(MRScreenWidth/4, CGRectGetMaxY(self.TDS1Content.frame)+MRScreenWidth/4);
    [self.view addSubview:indicatorView];
    indicatorView.downloadedBytes = 99;
    [indicatorView startAnimation:1.5];
    
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
    NSDictionary *infoDic = [deviceArray objectAtIndex:0];
    NSArray *arr = [infoDic objectForKey:@"filter"];
    
    UIStoryboard *storyboard = self.storyboard;
    FilterViewcontroller*vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"FilterViewcontroller"];
    vc.tabBarController.view.hidden = YES;
    vc.infoArr =arr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --开关
- (IBAction)switchOnClick:(id)sender {
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid    forKey:@"openid"];
    [formData setValue:token     forKey:@"token"];
    NSString *devId = [kUD objectForKey:@"id"];
     [formData setValue:devId     forKey:@"did"];//设备id
    [request requestWithType:AsynchronousType RequestTag:@"toggleOpen" FormData:formData Action:@"user/toggleOpen"];
    
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
        if ([requestTag isEqualToString:RTag]) {//获取用户信息
            [self initDataModle:data];
        }else{
            [self showAlert:@"操作成功！"];
        }
    }else{
        if ([requestTag isEqualToString:RTag]) {//获取用户信息
            [self showAlert:@"获取设备信息失败！"];
        }else{
            [self showAlert:@"操作失败！"];
            [self.switchBtn setSelected:NO];
        }
        
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
        NSString *devId = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]];
        [kUD setValue:devId forKey:@"id"];
         NSString *mac = [infoDic objectForKey:@"mac"];
        [kUD setValue:mac forKey:@"mac"];
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
