//
//  addDevManuallyViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-2-2.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "addDevManuallyViewController.h"
#define MoveUp 0
@interface addDevManuallyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation addDevManuallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.targetTF.leftViewMode = UITextFieldViewModeAlways;
    self.targetTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.targetTF.delegate = self;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self sendContentViewUp:YES];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.targetTF resignFirstResponder];
    [self sendContentViewUp:NO];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.targetTF resignFirstResponder];
    [self sendContentViewUp:NO];
    return YES;
}
- (void)sendContentViewUp:(BOOL)up
{
    if (up) {
        float orig = CGRectGetMaxY(self.targetTF.frame);
        float space = MRScreenHeight-keyBoardHeight-orig-stanavh;
        if(space<0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.contentView.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
            }];
        }

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = CGRectMake(0, stanavh, MRScreenWidth, MRScreenHeight);
        }];
        
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.targetTF resignFirstResponder];
    [self sendContentViewUp:NO];
}
- (IBAction)commit:(id)sender {
    
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [ud objectForKey:@"uid"];
    
    [formData setValue:self.targetTF forKey:@"code"];
    [formData setValue:uid forKey:@"uid"];
    [request requestWithType:AsynchronousType RequestTag:@"addDev" FormData:formData Action:@"saveQRDevice.do"];
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    if ([[data objectForKey:@"success"]boolValue]) {
        [alert showInfo:self title:@"温馨提示" subTitle:@"设备添加成功"  closeButtonTitle:@"确定" duration:3.0f];
    }else{
        NSString *detail = [data objectForKey:@"error"];
        [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    [alert showInfo:self title:@"温馨提示" subTitle:@"设备添加失败"  closeButtonTitle:@"确定" duration:3.0f];
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
