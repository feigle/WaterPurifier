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

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *name = [kUD objectForKey:@"account"];
     NSString *openid = [kUD objectForKey:@"openid"];
     NSString *token = [kUD objectForKey:@"token"];
    self.nameTF.text = name;
    self.addressTF.text = @"address";
    self.emailTF.text = @"email";
    // Do any additional setup after loading the view.
}
- (IBAction)summitUserInfo
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
