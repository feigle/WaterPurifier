//
//  QEScannerViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-27.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "QEScannerViewController.h"
#import "PRTween.h"
@interface QEScannerViewController ()
{
}
@property (weak, nonatomic) IBOutlet UIView *topVIew;
@property (weak, nonatomic) IBOutlet UIView *leftViw;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIImageView *scanFrameView;

@property (weak, nonatomic) IBOutlet UIButton *addCamaraNumBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextVCBtn;

@end

@implementation QEScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.tabBarController.tabBar.hidden = YES;
    _isReading = NO;
    _captureSession = nil;
    [self loadBeepSound];
    [self startReading];
    float width = MRScreenWidth - self.leftViw.frame.size.width-self.rightView.frame.size.width;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftViw.frame.size.width, CGRectGetMaxY(self.topVIew.frame), width, 2)];
    line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:line];
    
    [PRTween animationTransitionCurlDownWithView:line endFrame:CGRectMake(self.leftViw.frame.size.width, CGRectGetMinY(self.bottomView.frame), width, 1) repeats:100 duration:2];
    // Do any additional setup after loading the view.
}
-(void)bringCoverViewToFront
{
    [self.view bringSubviewToFront:self.topVIew];
    [self.view bringSubviewToFront:self.leftViw];
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.rightView];
    [self.view bringSubviewToFront:self.scanFrameView];
    [self.view bringSubviewToFront:self.tipsLabel];
    [self.view bringSubviewToFront:self.nextVCBtn];
    
    
}
#pragma mark --停止扫描
-(void)stopReading{
    [_captureSession stopRunning];
//    _captureSession = nil;
    [self.view bringSubviewToFront:_lblStatus];
//    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark --开始扫描
- (BOOL)startReading {
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        CLog(@"%@", [error localizedDescription]);
        
        return NO;
    }
    _isReading = YES;
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    [self bringCoverViewToFront];
    return YES;
}
#pragma mark --二维码扫描回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (_isReading&&metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //停止扫描
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        
        _isReading = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //显示扫描信息
                [self sendToServer:[metadataObj stringValue]];
            });
        });
        //播放声音
        if (_audioPlayer) {
            [_audioPlayer play];
        }
    }
}
- (void)sendToServer:(NSString *)scanResult
{
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    //web版登录扫描
    if ([scanResult rangeOfString:@"|LOGIN"].location !=NSNotFound)
    {
        scanResult = [scanResult stringByReplacingOccurrencesOfString:@"|LOGIN" withString:@""];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userName = [ud objectForKey:@"userName"];
        NSString *pwd      = [ud objectForKey:@"pwd"];
        
        
        [formData setValue:userName    forKey:@"name"];
        [formData setValue:pwd      forKey:@"pwd"];
        [formData setValue:scanResult forKey:@"sessionId"];
        
        [request requestWithType:AsynchronousType RequestTag:@"QRscan_login" FormData:formData Action:[NSString stringWithFormat:@"QRlogin.do;jsessionid=%@",scanResult]];
    }else{//添加设备
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *uid = [ud objectForKey:@"uid"];
        
        [formData setValue:scanResult forKey:@"code"];
        [formData setValue:uid forKey:@"uid"];
        [request requestWithType:AsynchronousType RequestTag:@"QRscan_addDev" FormData:formData Action:@"saveQRDevice.do"];
    }
    
    
    
}
-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    _isReading = YES;
    [_captureSession startRunning];
    if([[data objectForKey:@"success"] boolValue])
    {
        if ([requestTag isEqualToString:@"QRscan_addDev"])
        {//添加设备
            
        }else if ([requestTag isEqualToString:@"QRscan_login"]){//pc登录
            
        }
    }else{
        NSString *error = [data objectForKey:@"error"];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;

        [alert showInfo:self title:@"error" subTitle:error  closeButtonTitle:@"确定" duration:3.0f];
    }
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)requestFailed:(ASIHTTPRequest *)retqust RequestTag:(NSString *)requestTag
{
    _isReading = YES;
    [_captureSession startRunning];
}
#pragma mark --播放声音
-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        CLog(@"Could not play beep file.");
        
        CLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
}


- (IBAction)push:(id)sender {
//    [CommonFunc pushViewController:self.navigationController andControllerID:@"addDevManuallyVC" andStoryBoard:self.storyboard];
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
