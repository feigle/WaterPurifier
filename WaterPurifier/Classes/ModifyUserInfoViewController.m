//
//  ModifyUserInfoViewController.m
//  WaterPurifier
//
//  Created by 李剑波 on 15/4/28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "Macros.h"
#define Tag @"modifiedUserProfile"
#define RAction @"user/modifiedSelfProfile"
@interface ModifyUserInfoViewController ()<RequestManagerDelegate>

@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *addressTF;
@property (strong, nonatomic) UITextField *emailTF;

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
   
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 64+20, SCREEN_WIDTH-40, 44)];
    self.nameTF.placeholder = @"name";
    self.nameTF.layer.borderWidth = 1;
    self.nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.nameTF];
    
    
    
    self.addressTF = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameTF.frame)+20, SCREEN_WIDTH-40, 44)];
    self.addressTF.layer.borderWidth = 1;
    self.addressTF.placeholder = @"address";
    self.addressTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addressTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.addressTF];
    
    self.emailTF = [[UITextField alloc]initWithFrame:CGRectMake(20,  CGRectGetMaxY(self.addressTF.frame)+20, SCREEN_WIDTH-40, 44)];
    self.emailTF.layer.borderWidth = 1;
    self.emailTF.placeholder = @"email";
    self.emailTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.emailTF];
    
    CGRect frame = [self.nameTF frame];
    frame.size.width = 7.0f;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    UIView *leftview2 = [[UIView alloc] initWithFrame:frame];
    UIView *leftview3 = [[UIView alloc] initWithFrame:frame];
    
    self.nameTF.leftView = leftview1;
    self.addressTF.leftView = leftview2;
    self.emailTF.leftView = leftview3;
    
    NSString *name = [kUD objectForKey:@"account"];
     NSString *openid = [kUD objectForKey:@"openid"];
     NSString *token = [kUD objectForKey:@"token"];
    self.nameTF.text = name;
    self.addressTF.text = @"address";
    self.emailTF.text = @"email";
    
    UIButton *summitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    summitBtn.frame =CGRectMake(20,  CGRectGetMaxY(self.emailTF.frame)+60, SCREEN_WIDTH-40, 44);
    [summitBtn setTitle:@"提交" forState:UIControlStateNormal];
    summitBtn.backgroundColor = [UIColor colorWithRed:11/255.0f green:151/255.0f blue:235/255.0f alpha:1];
    [summitBtn addTarget:self  action:@selector(summitUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:summitBtn];
    // Do any additional setup after loading the view.
}
- (void)summitUserInfo
{
    
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid   forKey:@"openid"];
    [formData setValue:token      forKey:@"token"];
    [formData setValue:self.addressTF.text      forKey:@"address"];
    [formData setValue:self.emailTF.text      forKey:@"email"];
    [formData setValue:self.nameTF.text     forKey:@"name"];

    [request requestWithType:AsynchronousType RequestTag:Tag FormData:formData Action:RAction];
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
       [self showAlert:@"用户信息修改成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showAlert:@"用户信息修改失败！"];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
