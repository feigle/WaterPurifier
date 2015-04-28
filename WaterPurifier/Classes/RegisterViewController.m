//
//  RegisterViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-29.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "RegisterViewController.h"
#import "Macros.h"
#define REGIST @"regist"
#define REGIST_ACTION    @"user/register"
#define Active @"userActivate"
#define ActiveAction @"user/userActivate"
#define tarGetTF 1003

@interface RegisterViewController ()<RequestManagerDelegate>
{
    RequestManager *request;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *inputPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *inputAgainTf;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeTf;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameTF.text = @"ckh";
    self.inputPwdTF.text = @"test";
    self.inputAgainTf.text = @"test";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.userNameTF performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.4];
    
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (MRScreenHeight<500) {
        [self scrollView:textField];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBorad];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1000:
            [self.inputPwdTF becomeFirstResponder];
            break;
        case 1001:
            [self.inputAgainTf becomeFirstResponder];
            break;
        case 1002:
            [self.VerificationCodeTf becomeFirstResponder];
            break;
        case 1003:
            [self hideKeyBorad];
            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark -- 上移contentVie
- (void)scrollView:(UITextField*)textfield
{
    float orig = CGRectGetMaxY(self.registBtn.frame);
    float space = MRScreenHeight-keyBoardHeight-orig-stanavh;
    //判断键盘是否遮挡最低视图
    if (space<0 && textfield.tag==tarGetTF) {
        [self contentViewMove:-120];
    }
    
    
}
- (void)contentViewMove:(float)origin_y
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, origin_y, MRScreenWidth, MRScreenHeight);
    }];
}
#pragma mark -- 隐藏键盘
- (void)hideKeyBorad
{
    [self contentViewMove:0];
    [self.userNameTF resignFirstResponder];
    [self.inputPwdTF resignFirstResponder];
    [self.inputAgainTf resignFirstResponder];
    [self.VerificationCodeTf resignFirstResponder];
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    CLog(@"执行图片下载函数");
    
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}
#pragma mark -- 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    
    [self hideKeyBorad];
    request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:self.userNameTF.text     forKey:@"userName"];
    [formData setValue:self.inputPwdTF.text      forKey:@"pwd"];
    [formData setValue:@"type"     forKey:@"0"];
    [request requestWithType:AsynchronousType RequestTag:REGIST FormData:formData Action:REGIST_ACTION];
}
#pragma mark -- 注册
- (IBAction)didRegistBtnClicked:(id)sender {
    [self hideKeyBorad];
    [self contentViewMove:0];
    request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:self.userNameTF.text     forKey:@"account"];
    [formData setValue:self.inputPwdTF.text     forKey:@"password"];
    [formData setValue:@"1"    forKey:@"type"];
    [request requestWithType:AsynchronousType RequestTag:REGIST FormData:formData Action:REGIST_ACTION];
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders RequestTag:(NSString *)requestTag
{

}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {//成功
        if ([requestTag isEqualToString:@"regist"]) {//注册
            NSString *openid = [data objectForKey:@"openid"];
            NSString *token = [data objectForKey:@"token"];
            NSString *activationid = [data objectForKey:@"activationid"];
            NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
            [formData setValue:openid     forKey:@"openid"];
            [formData setValue:token     forKey:@"token"];
            [formData setValue:activationid    forKey:@"activationid"];
            [formData setValue:@"123456"    forKey:@"code"];
            [request requestWithType:AsynchronousType RequestTag:Active FormData:formData Action:ActiveAction];
        }else{//激活
            [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:3];
        }
    }else//失败
    {
        NSString *msg = [data objectForKey:@"Msg"];
         [[[UIAlertView alloc]initWithTitle:@"注册失败" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
   
}
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{

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
