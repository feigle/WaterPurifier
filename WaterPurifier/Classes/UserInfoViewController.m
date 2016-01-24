//
//  UserInfoViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-23.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LineView.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "IndicatorViewCustom.h"
#import "Macros.h"
#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return nil;}
#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"

#define space 15
#define cameraTag 53454
#define ambulTag 4343
#define button_h 46
#define nomalSpace 20
#define largeSpace 35

#define BtnSpace
#define Logout @"logout"
#define LogoutAction @"user/logout"
#define GetUserInfo @"getSelfProfile"
#define GetUserInfoAction @"user/getSelfProfile"

@interface UserInfoViewController ()<TGCameraDelegate>
{
    UIImagePickerController * picker;
    IndicatorViewCustom *indicatorView;
    NSDictionary *userInfoDic;

}
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic,retain)NSArray *titleArr;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong) UIView *editBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation UserInfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self getUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:ColorFromRGB(0x004a80)];
    
    self.userNameLabel.text  = [kUD objectForKey:@"account"];
    self.titleArr = [NSArray arrayWithObjects:@"121057750@qq.com",@"address",@"name",@"注销", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), MRScreenWidth, MRScreenHeight-stanavh-CGRectGetHeight(self.headView.frame));
    //TODO:
    //    设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //加载圆圈
    indicatorView = [[IndicatorViewCustom alloc]init];
    indicatorView.frame = self.contentView.bounds;
    indicatorView.center = self.headImageView.center;
    indicatorView.hidden = YES;
    [self.contentView addSubview:indicatorView];
    
    //头像
    self.headImageView.layer.cornerRadius = (self.headImageView.frame.size.width)/2;
    self.headImageView.layer.masksToBounds = YES;
    [self setHeadViewImage];
    self.tabBarController.view.hidden = YES;
    
    [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:[NSNumber numberWithBool:YES]];
    self.headImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}


- (IBAction)EditUserInfo:(id)sender {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"ModifyUserInfoViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 设置头像
- (void)setHeadViewImage
{
    // 获取Documents目录路径
    NSArray *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    headImage.png
    NSString *docDir = [NSString stringWithFormat:@"%@/HeadImages/headImage.png",[paths objectAtIndex:0]];
    NSData*data = [NSData dataWithContentsOfFile:docDir];
    if (data) {
        [self.headImageView setImage:[UIImage imageWithData:data]];
    }
   
}

#pragma mark -
#pragma mark - TGCameraDelegate required
/**
 *  取消
 */
- (void)cameraDidCancel
{
    shuldStatusbarHidden(NO);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma  mark --完成从拍照
/**
 *  拍照
 *
 *  @param image
 */
- (void)cameraDidTakePhoto:(UIImage *)image
{
    [self finishTokenPhoto:image];
}
#pragma  mark --完成从相册选取
/**
 *  从相册选取
 *
 *  @param image
 */
- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [self finishTokenPhoto:image];
}

- (void)finishTokenPhoto:(UIImage*)image
{
    self.headImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    indicatorView.hidden = NO;
#pragma mark --转圈动画
    
    [self performSelector:@selector(hideIndicatorView) withObject:nil afterDelay:7.0];
    [indicatorView startAnimation:0];
    //异步上传头像
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self saveImageToLocal:image];
    });
    
    shuldStatusbarHidden(NO);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //异步上传头像
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newThread,^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [self UpLoading:dic andUrl:nil IMG:image];
    });

    
}
- (void)hideIndicatorView
{
    indicatorView.hidden = YES;
}
#pragma mark -
#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark -
#pragma mark - Private methods

- (IBAction)tapOnHeadImage:(id)sender {//点击头像
//    [self showActionsheet];
}
#pragma mark --修改头像按钮
- (void)showActionsheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改头像", nil];
    [sheet showInView:self.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        [self actionSheetBtnClick];
    }
}

#pragma mark --修改头像
//修改头像
- (void)actionSheetBtnClick
{
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor= [UIColor whiteColor];
    button.layer.cornerRadius=23;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color(0, 175, 240) forState:UIControlStateNormal];
    return button;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
    
    [cell.textLabel setTextColor:[UIColor grayColor]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init] ;
    [headView setBackgroundColor:[UIColor whiteColor]];
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
     if (indexPath.section == 1){//注销
//         [self requestLogout];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)requestLogout:(id)sender
{
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid    forKey:@"openid"];
    [formData setValue:token     forKey:@"token"];

    [request requestWithType:AsynchronousType RequestTag:Logout FormData:formData Action:LogoutAction];
}
- (void)getUserInfo
{
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid    forKey:@"openid"];
    [formData setValue:token     forKey:@"token"];
    
    [request requestWithType:AsynchronousType RequestTag:GetUserInfo FormData:formData Action:GetUserInfoAction];
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([requestTag isEqualToString:@"getSelfProfile"]) {//获取用户信息
//        if ([[data objectForKey:@"state"] boolValue]) {
            self.titleArr  = nil;
             self.titleArr = [NSArray arrayWithObjects:[data objectForKey:@"address"],[data objectForKey:@"name"],[data objectForKey:@"email"],@"注销", nil];
            [self.tableView reloadData];
//        }else{
//            [self showAlert:@"获取用户信息失败！"];
//        }
    }else{//注销
        if ([[data objectForKey:@"state"] boolValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ToLoginVC" object:nil];
        }else{
            [self showAlert:@"注销失败"];
        }
    }
   
}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{
    [self showAlert:@"网络有误，请稍后重试！"];
}
- (IBAction)backup:(id)sender {
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

/**
 *  保存照片到本地
 *
 *  @param img
 */
-(void)saveImageToLocal:(UIImage*)img
{
    //根据时间，创建当天的路径 用于保存照片
    NSString *strPhoto = @"HeadImages";
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:strPhoto];
    //判断Photo文件夹是否存在,不存在则创建
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    path = [NSString stringWithFormat:@"%@/headImage.png",path];
    //日期命名，保存到文件夹下
    BOOL result = NO;
    //名字相同则会直接覆盖
    result = [UIImagePNGRepresentation(img) writeToFile:path atomically:YES];
    if (result) {
        //通知其它页面改变头像
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeHeadImage" object:nil];
    }
}
#pragma mark --上传图片
/**@brief 上传图片
 */
- (NSString *) UpLoading:(NSMutableDictionary*)postDic andUrl:(NSString *)baseurl IMG:(UIImage *)img
{
    [postDic setObject:@"file" forKey:@"name"];
    [postDic setObject:UIImageJPEGRepresentation(img, 0.75f) forKey:@"file"];
    NSData *postData = [self generateFormDataFromPostDictionary:postDic];
    
    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSESSIONID"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload;jsessionids=%@",HOST,sessionID]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setHTTPBody:postData];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    //设置接受response的data
    NSMutableData *receiveData = [NSMutableData data] ;
    NSString *outstring = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"outstring%@",outstring);
    return outstring;
}
/**@brief 获取图片
 */
- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // 添加数据
            NSString *theKey = [keys objectAtIndex:i];
            NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT,theKey];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
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
