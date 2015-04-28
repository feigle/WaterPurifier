//
//  ForgetPwdViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "Macros.h"
#define fristTF 1000
#define secondTF 1001
#define thirdTF 1002
#define forthTF 1003

@interface ForgetPwdViewController ()<UITextFieldDelegate,RequestManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *intputNewPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *inputAgainTF;
@property (weak, nonatomic) IBOutlet UIButton *summitBtn;

@end

@implementation ForgetPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    // Do any additional setup after loading the view.
}
- (IBAction)summit:(id)sender {
    [self scrollContentView:0];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (MRScreenHeight<500) {
        [self scrollView:textField];
    }
    
    return YES;
}
- (void)scrollView:(UITextField*)textfield
{
    float origin_y = 0;
    switch (textfield.tag) {
        case fristTF:
            origin_y = 0;
            break;
        case secondTF:
            origin_y = 0;
            break;
        case thirdTF:
            origin_y = 0;
            break;
        case forthTF:
            origin_y = -100;
            break;
            
        default:
            break;
    }
    [self scrollContentView:origin_y];
    
}
- (void)scrollContentView:(float)origin_y
{
    float orig = CGRectGetMaxY(self.summitBtn.frame);
    float space = MRScreenHeight-keyBoardHeight-orig-stanavh;
    //判断键盘是否遮挡最低视图
    if (space<0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.frame = CGRectMake(0, origin_y, MRScreenWidth, MRScreenHeight);
        }];
    }
    
}
#pragma mark --重置密码
- (void)resetPassword
{
    //post:{"password":xxxxxxxxxxx,"code":xxxxxxxxx}
    if (self.inputAgainTF.text.length<1||self.intputNewPwdTF.text.length<1) {
        
    }
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:self.inputAgainTF.text    forKey:@"password"];
    [formData setValue:@"123456"     forKey:@"code"];
    
    [request requestWithType:AsynchronousType RequestTag:@"resetPwd" FormData:formData Action:@"user/resetPassword"];
    
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
        [self showAlert:@"密码改成功！"];;
    }else{
        [self showAlert:@"密码修改失败！"];
    }
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBorad];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1000:
//            [self.codeTF becomeFirstResponder];
            break;
        case 1001:
            [self.intputNewPwdTF becomeFirstResponder];
            break;
        case 1002:
            [self.inputAgainTF becomeFirstResponder];
            break;
        case 1003:
            [self hideKeyBorad];
            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark -- 隐藏键盘
- (void)hideKeyBorad
{
    [self scrollContentView:0];
    
    [self.inputAgainTF resignFirstResponder];
    [self.intputNewPwdTF resignFirstResponder];
}

#pragma mark -- 提交
- (IBAction)didSummitBtnClicked:(id)sender {
    [self resetPassword];
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
