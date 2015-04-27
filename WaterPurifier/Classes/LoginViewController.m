//
//  LoginViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Macros.h"
#import "user.h"
#import "Device.h"
#define LOGIN @"login"
#define LOGIN_ACTION    @"user/login"
@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,RequestManagerDelegate>
{
    RequestManager *request;
    BOOL isRecord;
    BOOL isAutoLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *PwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//记住密码
@property (weak, nonatomic) IBOutlet UIImageView *recordImg;
//自动登录
@property (weak, nonatomic) IBOutlet UIImageView *autoLoginImg;
//忘记密码
@property (weak, nonatomic) IBOutlet UIView *forgetView;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.view setUserInteractionEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavingationController) name:@"hideNavingationController" object:nil];
    [self hideNavingationController];
    
}
- (void)hideNVC
{
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    } completion:^(BOOL isFinish){
        self.navigationController.navigationBar.hidden = NO;
    }];
}
- (void)hideNavingationController
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
        } completion:^(BOOL isFinish){
            
        }];
    });
}
-(void)viewDidAppear:(BOOL)animated
{
    
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.05 animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, 45);
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self performSelector:@selector(hideNVC) withObject:nil afterDelay:1];
    
    isRecord = [kUD boolForKey:@"isRecord"];
    isAutoLogin = [kUD boolForKey:@"isAutoLogin"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [XDKAirMenuController sharedMenu].moveEnable = NO;
    self.scrollView.contentSize = CGSizeMake(MRScreenWidth, MRScreenHeight);
    self.scrollView.scrollEnabled = NO;
    self.userNameTF.text = @"ckh";
    if (isRecord)
        self.PwdTF.text = @"test";
    else
        self.PwdTF.text = nil;
    
    self.userNameTF.delegate = self;
    self.PwdTF.delegate = self;
    
    CGPoint point = CGPointMake(MRScreenWidth/2, MRScreenHeight-80);
    self.forgetView.center = point;
    
    if (isRecord)
        [self.recordImg setImage:[UIImage imageNamed:@"login_checked"]];
    else
        [self.recordImg setImage:[UIImage imageNamed:@"login_uncheck"]];
    
    if (isAutoLogin)
        [self.autoLoginImg setImage:[UIImage imageNamed:@"login_checked"]];
    else
        [self.autoLoginImg setImage:[UIImage imageNamed:@"login_uncheck"]];

    
    // Do any additional setup after loading the view.
}
#pragma mark -- 收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidKeyboard];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hidKeyboard];
    return YES;
}
-(void)hidKeyboard
{
    [self.userNameTF resignFirstResponder];
    [self.PwdTF resignFirstResponder];
}
#pragma mark -- 登录按钮
- (IBAction)didLoginBtnClicked:(id)sender {
//    [self hidKeyboard];
//    [self toIndexPage];
//    return;
    if (self.userNameTF.text.length <1) {
        [self showNotice:@"请输入用户名!"];
        return;
    }else if (self.PwdTF.text.length <1)
    {
        [self showNotice:@"请输入密码!"];
        return;
    }
   request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:self.userNameTF.text    forKey:@"account"];
    [formData setValue:self.PwdTF.text      forKey:@"password"];
//    [formData setValue:@"8a6d98d6a0b3f55a45d0dd72b07b332eb741871d7f77dedf2e320042977a1939" forKey:@"token"];
    [request requestWithType:AsynchronousType RequestTag:LOGIN FormData:formData Action:LOGIN_ACTION];
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders RequestTag:(NSString *)requestTag
{

}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
        NSString *openid = [data objectForKey:@"openid"];
        NSString *token = [data objectForKey:@"token"];
////        保存用户信息
//        NSString *uid = [infoDic objectForKey:@"id"];
//
        [kUD setObject:self.userNameTF.text forKey:@"account"];
        [kUD setObject:self.PwdTF.text forKey:@"password"];
        [kUD setObject:openid forKey:@"openid"];
        [kUD setObject:token forKey:@"token"];
//
////        是否保存密码
//        [kUD setBool:isRecord forKey:@"isRecord"];
////        是否自动登录
//        [kUD setBool:isAutoLogin forKey:@"isAutoLogin"];
//        User *user = [[User alloc]init];
//        user.name = self.userNameTF.text;
//        user.phone = self.PwdTF.text;
//        user.uid = uid;
//        [user insertToDb];

//        跳转到首页
        [self toIndexPage];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{

}
-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
}
- (void)toIndexPage
{
    

    [self.view setUserInteractionEnabled:NO];
    [XDKAirMenuController sharedMenu].moveEnable = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ToDefaultVC" object:nil];
}
#pragma mark --跳转注册页面
- (IBAction)toRegistVC:(id)sender {

    [CommonFunc pushViewController:self.navigationController andControllerID:@"RegisterVc" andStoryBoard:self.storyboard];
        
}
- (IBAction)recordBtnClicked:(id)sender {
    isRecord = !isRecord;
    
    if (isRecord)
        [self.recordImg setImage:[UIImage imageNamed:@"login_checked"]];
    else
        [self.recordImg setImage:[UIImage imageNamed:@"login_uncheck.png"]];
}

- (IBAction)autoLoginBtnClicked:(id)sender {
    
    isAutoLogin = !isAutoLogin;
    
    if (isAutoLogin)
        [self.autoLoginImg setImage:[UIImage imageNamed:@"login_checked"]];
    else
        [self.autoLoginImg setImage:[UIImage imageNamed:@"login_uncheck.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
