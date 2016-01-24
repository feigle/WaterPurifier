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

@interface RegisterViewController ()<RequestManagerDelegate,UIAlertViewDelegate>
{
    RequestManager *request;
}
@property (strong, nonatomic)  UITextField *userNameTF;
@property (strong, nonatomic)  UITextField *inputPwdTF;
@property (strong, nonatomic)  UITextField *inputAgainTf;
@property (strong, nonatomic)  UITextField *VerificationCodeTf;
@property (strong, nonatomic)  UIButton *getCodeBtn;
@property (strong, nonatomic)  UIButton *registBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.userNameTF.text = @"ckh";
//    self.inputPwdTF.text = @"test";
//    self.inputAgainTf.text = @"test";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.userNameTF performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.4];
    [self initSubViews];
    // Do any additional setup after loading the view.
}
- (void)initSubViews
{
    self.userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 64+20, SCREEN_WIDTH-40, 44)];
    self.userNameTF.placeholder = @"用户名";
    self.userNameTF.layer.borderWidth = 1;
    self.userNameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.userNameTF];
    
    
    
    self.inputPwdTF = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.userNameTF.frame)+20, SCREEN_WIDTH-40, 44)];
    self.inputPwdTF.layer.borderWidth = 1;
    self.inputPwdTF.placeholder = @"密码";
    self.inputPwdTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputPwdTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.inputPwdTF];
    
    self.inputAgainTf = [[UITextField alloc]initWithFrame:CGRectMake(20,  CGRectGetMaxY(self.inputPwdTF.frame)+20, SCREEN_WIDTH-40, 44)];
    self.inputAgainTf.layer.borderWidth = 1;
    self.inputAgainTf.placeholder = @"验证密码";
    self.inputAgainTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputAgainTf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.inputAgainTf];
    
    self.VerificationCodeTf = [[UITextField alloc]initWithFrame:CGRectMake(20,  CGRectGetMaxY(self.inputAgainTf.frame)+20, (SCREEN_WIDTH-60)/2, 44)];
    self.VerificationCodeTf.layer.borderWidth = 1;
    self.VerificationCodeTf.placeholder = @"验证码";
    self.VerificationCodeTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.VerificationCodeTf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.VerificationCodeTf];
    
    
    CGRect frame = [self.inputAgainTf frame];
    frame.size.width = 10.0f;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    UIView *leftview2 = [[UIView alloc] initWithFrame:frame];
    UIView *leftview3 = [[UIView alloc] initWithFrame:frame];
    UIView *leftview4 = [[UIView alloc] initWithFrame:frame];
    
    self.userNameTF.leftView = leftview1;
    self.inputPwdTF.leftView = leftview2;
    self.inputAgainTf.leftView = leftview3;
    self.VerificationCodeTf.leftView = leftview4;
    
    
    self.getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeBtn.frame =CGRectMake(CGRectGetMaxX(self.VerificationCodeTf.frame)+10,  self.VerificationCodeTf.frame.origin.y, self.VerificationCodeTf.frame.size.width, 44);
    [self.getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    self.getCodeBtn.backgroundColor = [UIColor colorWithRed:11/255.0f green:151/255.0f blue:235/255.0f alpha:1];
    [self.getCodeBtn addTarget:self  action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBtn];
    
    
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registBtn.frame =CGRectMake(20,  CGRectGetMaxY(self.VerificationCodeTf.frame)+60, SCREEN_WIDTH-40, 44);
    [self.registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    self.registBtn.backgroundColor = [UIColor colorWithRed:11/255.0f green:151/255.0f blue:235/255.0f alpha:1];
    [self.registBtn addTarget:self  action:@selector(didRegistBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registBtn];
    
    
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
//    [UIView animateWithDuration:0.2 animations:^{
//        self.contentView.frame = CGRectMake(0, origin_y, MRScreenWidth, MRScreenHeight);
//    }];
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
- (void)getVerificationCode:(id)sender {
    
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
- (void)didRegistBtnClicked:(id)sender {
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
            //激活
            [request requestWithType:AsynchronousType RequestTag:Active FormData:formData Action:ActiveAction];
        }else{//激活
            [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"注册成功并激活" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"返回登录页面",nil] show];
           
        }
    }else//失败
    {
        NSString *msg = [data objectForKey:@"Msg"];
         [[[UIAlertView alloc]initWithTitle:@"注册失败" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self goback];
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
