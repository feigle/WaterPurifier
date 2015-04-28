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

@interface MyDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,RequestManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    //请求信息
    [self requestInfo];
    //初始化表示图
    [self initTableView];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MRScreenWidth, self.view.frame.size.height)];
        view.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:view];
        
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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
        [self.tableView reloadData];//刷新
    }
}
#pragma mark --初始化tableview
- (void)initTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, MRScreenWidth, SCREEN_HEIGHT);
    self.tableView.backgroundColor = ColorFromRGB(0xf0f0f6);
    
    //添加头部及尾部拉动刷新
    [self.tableView addHeaderWithCallback:^{
#pragma mark --下拉放开回调
        [self requestInfo];
    }];
    
    
    [self.tableView reloadData];
    self.tableView.contentSize = CGSizeMake(MRScreenWidth, (cell_h+kSpace)*5);
    
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
