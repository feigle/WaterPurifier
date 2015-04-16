//
//  MyCamaraViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MyCamaraViewController.h"
#import "TimeControlView.h"
#import "PRTween.h"
#import "JLBlurView.h"
#import "PlaySystemSoundManager.h"

#define snapViewTag 550
#define intercomViewTag 551
#define voiceSwitchViewTag 552
#define button_h 46
#define nomalSpace 20
#define largeSpace 35

@interface MyCamaraViewController ()<timeChangeDelegate>

{
    TimeControlView *timeCVPort;//竖屏时间轴
    TimeControlView *timeCVLandsp;//横屏时间轴
    float scOffet_x;
    CGRect videoViewFrame;//装载视图
    
    CGRect controlBarViewFrame;//半透明控制条
    CGRect liveLabelFrame;//直播
    CGRect qualyLabelFrame;//均衡
    CGRect curTimeLabelFrame;//播放时间
    CGRect fullscreenBtnFrame;//全屏
    
    CGRect timeBarViewFrame;//时间滚动条
    
    CGRect toolsBarViewFrame;//工具条
    CGRect snapshootBtnFrame;//抓拍
    CGRect sayBtnFrame;//全屏
    CGRect voiceBtnFrame;//声音
    
    PRTweenOperation *activeTweenOperation;
    
}
//抓拍按钮
@property (weak, nonatomic) IBOutlet UIButton           *snapshootBtn;
//对讲按钮
@property (weak, nonatomic) IBOutlet UIButton           *sayBtn;
//声音按钮
@property (weak, nonatomic) IBOutlet UIButton           *voiceBtn;
#pragma mark -- 横屏适配视图
//装载视频的视图
@property (weak, nonatomic) IBOutlet UIView             *videoView;
//控制条
@property (weak, nonatomic) IBOutlet UIView             *controlBarView;
//时间轴
@property (weak, nonatomic) IBOutlet UIView             *timeBarView;
//对讲/抓拍/声音栏
@property (weak, nonatomic) IBOutlet UIView             *toolsBarView;
//时间label
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;
//直播
@property (weak, nonatomic) IBOutlet UILabel  *liveLabel;
//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel  *curTimeLabel;
//画质
@property (weak, nonatomic) IBOutlet UILabel  *qualyLabel;
//全屏按钮
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;

@property (assign, nonatomic) BOOL speakEnable;
@property (assign, nonatomic) BOOL voiceOpen;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) BOOL isShowing;

@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@end

@implementation MyCamaraViewController



-(void)viewWillAppear:(BOOL)animated
{
    [XDKAirMenuController sharedMenu].moveEnable = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [XDKAirMenuController sharedMenu].moveEnable = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"canReloadtion" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingButton.hidden = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];

    self.videoView.backgroundColor = [UIColor cyanColor];
    
    //通知根视图可以选中
    [[NSNotificationCenter defaultCenter]postNotificationName:@"canReloadtion" object:nil];
    //设置标题
    //设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    self.timeBarView.backgroundColor = [UIColor clearColor];
    //时间轴横屏
    timeCVLandsp = [[TimeControlView alloc] initWithFrame:CGRectMake(0, 0, MRScreenHeight, self.timeBarView.frame.size.height)];
    timeCVLandsp.delegate = self;
    timeCVLandsp.hidden = YES;
    timeCVLandsp.shuldCallBack = NO;
    [self.timeBarView addSubview:timeCVLandsp];
    //时间轴竖屏
    timeCVPort = [[TimeControlView alloc] initWithFrame:CGRectMake(0, 0, self.timeBarView.frame.size.width, self.timeBarView.frame.size.height)];
    timeCVPort.delegate = self;
    [self.timeBarView addSubview:timeCVPort];
    
    self.speakEnable = YES;
    self.voiceOpen = YES;
    self.isPlaying = YES;

    self.tabBarController.tabBar.hidden = YES;
    self.toolsBarView.center = CGPointMake(MRScreenWidth/2, CGRectGetMaxY(self.timeBarView.frame)+(MRScreenHeight-CGRectGetMaxY(self.timeBarView.frame))/2);
    //保存frame
    [self saveFames];
    
    //controlBarView/liveLabel/qualyLabel/fullscreenBtn
    
}

#pragma mark -- 保存控件的frame
-(void)saveFames
{
    videoViewFrame      = self.videoView.frame;
    controlBarViewFrame = self.controlBarView.frame;
    liveLabelFrame      = self.liveLabel.frame;
    qualyLabelFrame     = self.qualyLabel.frame;
    curTimeLabelFrame   = self.curTimeLabel.frame;
    fullscreenBtnFrame  = self.fullscreenBtn.frame;

    timeBarViewFrame    = self.timeBarView.frame;

    toolsBarViewFrame   = self.toolsBarView.frame;
    snapshootBtnFrame   = self.snapshootBtn.frame;
    sayBtnFrame         = self.sayBtn.frame;
    voiceBtnFrame       = self.voiceBtn.frame;
    
}
#pragma mark -- 竖屏还原frame
-(void)toPortrait
{
    [UIView animateWithDuration:0.3 animations:^{

        self.timeBarView.frame   = timeBarViewFrame;
        
    }];
    self.toolsBarView.frame = toolsBarViewFrame;
    self.snapshootBtn.frame = snapshootBtnFrame;
    self.sayBtn.frame       = sayBtnFrame;
    self.voiceBtn.frame     = voiceBtnFrame;
}
-(void)changeTime:(NSString *)time andScrollOffet_x:(float)offet_x
{
    time                   = [time substringFromIndex:10];
    self.curTimeLabel.text = time;
    scOffet_x              = offet_x;
    
}
#pragma mark -- 播放/暂停

- (IBAction)playTouchUpInside:(id)sender {
    if (self.isPlaying) {
        [self setImg:sender img:@"stop"];
        self.isPlaying = NO;
    }else{
        [self setImg:sender img:@"play"];
        self.isPlaying = YES;
    }
    
}

#pragma mark --  屏幕旋转
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {//竖屏
        shuldStatusbarHidden(NO);
        self.videoView.frame       = videoViewFrame;
        [self toFullScrenn:NO];
        self.isFullScreen          = NO;
        [self.timeBarView bringSubviewToFront:timeCVPort];
        timeCVPort.shuldCallBack   = YES;
        timeCVLandsp.shuldCallBack = NO;
        timeCVLandsp.hidden = YES;
        timeCVPort.hidden = NO;
        
    }
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {//横屏
        shuldStatusbarHidden(YES);
        [self toFullScrenn:YES];
        
        self.isFullScreen          = YES;
        [self.timeBarView bringSubviewToFront:timeCVLandsp];
        timeCVLandsp.shuldCallBack = YES;
        timeCVPort.shuldCallBack   = NO;
        timeCVLandsp.hidden = NO;
        timeCVPort.hidden = YES;
    }
}
#pragma mark --一些动画用到
- (void)update:(PRTweenPeriod*)period {
    if ([period isKindOfClass:[PRTweenCGPointLerpPeriod class]]) {
        period.targetView.center = [(PRTweenCGPointLerpPeriod*)period tweenedCGPoint];
    } else {
        period.targetView.frame  = CGRectMake(0, period.tweenedValue, 100, 100);
    }
}
//videoView/controlBarView/timeBarView/toolsBarView
- (void)toFullScrenn:(BOOL)fullScreen
{
    if (fullScreen) {
        float sw = MRScreenWidth;
        float sh = MRScreenHeight-20;
        if (!isRetina) {
            sw = MRScreenWidth;
            sh = MRScreenHeight-20;
        }
        [self setImg:self.fullscreenBtn img:@"smallScreen"];
        self.videoView.frame = CGRectMake(0, 0, sw, sh);
        self.timeLabel.frame = CGRectMake(sw-self.timeLabel.frame.size.width-40, 5, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
        self.navigationController.navigationBar.hidden = YES;
        
    }else{//转为竖屏
        [self setImg:self.fullscreenBtn img:@"fullScreen"];
        self.navigationController.navigationBar.hidden = NO;
        [self toPortrait];
        [UIView animateWithDuration:0.3 animations:^{
            self.controlBarView.frame = controlBarViewFrame;
            self.qualyLabel.frame    = qualyLabelFrame;
            self.curTimeLabel.frame  = curTimeLabelFrame;
            self.fullscreenBtn.frame = fullscreenBtnFrame;
            self.liveLabel.frame = liveLabelFrame;
        }];
        self.isShowing = NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.isFullScreen)
        return;

    if (!self.isShowing) {//显示控件
                float sw = MRScreenWidth;
        float sh = MRScreenHeight-20;
        if (!isRetina) {
            sw = MRScreenWidth;
            sh = MRScreenHeight-20;
        }
        self.settingButton.hidden = NO;
        self.settingButton.center = CGPointMake(sw-60, 50);
        self.toolsBarView.frame  = CGRectMake(0, sh/2, sw, self.toolsBarView.frame.size.height);
        self.sayBtn.center       = CGPointMake(sw/2, self.sayBtn.center.y);

        self.snapshootBtn.center = CGPointMake(sw/2, self.snapshootBtn.center.y);

        self.voiceBtn.center     = CGPointMake(sw/2, self.voiceBtn.center.y);
        
        [PRTween animationLikeAlertView:self.sayBtn];
        [UIView animateWithDuration:0.3 animations:^{
            //控制条
            self.controlBarView.frame = CGRectMake(0, sh-self.controlBarView.frame.size.height-self.timeBarView.frame.size.height, sw, self.controlBarView.frame.size.height);
            float conCenterY          = self.controlBarView.frame.size.height/2;
            //controlBarView/liveLabel/qualyLabel/fullscreenBtn
            //直播
            self.liveLabel.center     = CGPointMake(sw/4, conCenterY);
            self.curTimeLabel.center  = CGPointMake(sw/2, conCenterY);
            self.qualyLabel.center    = CGPointMake(sw*3/4, conCenterY);
            self.fullscreenBtn.center = CGPointMake(sw*9/10, conCenterY);


            self.timeBarView.frame    = CGRectMake(0, sh - self.timeBarView.frame.size.height, sw,  self.timeBarView.frame.size.height);
            self.snapshootBtn.center  = CGPointMake(sw/4, self.snapshootBtn.center.y);

            self.voiceBtn.center      = CGPointMake(sw*3/4, self.voiceBtn.center.y);
            
        }];
        self.isShowing = YES;
    }else{//隐藏控件
        self.settingButton.hidden = YES;
        [self toPortrait];
        [UIView animateWithDuration:0.3 animations:^{
            self.controlBarView.frame =CGRectMake(0, MRScreenWidth, MRScreenHeight, self.controlBarView.frame.size.height);
            
        }];
        self.isShowing = NO;
    }
}
#pragma mark -- 全屏按钮

- (IBAction)fullScreenTouchUpInside:(id)sender {
    
    if (self.isFullScreen) {

        self.isFullScreen = NO;
        self.navigationController.navigationBar.hidden = NO;
#pragma mark -- 强制横屏
        [self changeScreen:UIInterfaceOrientationPortrait];
    }else{//全屏
#pragma mark -- 强制横屏
        [self changeScreen:UIInterfaceOrientationLandscapeLeft];
        self.isFullScreen = YES;
    }
    
}
- (void)changeScreen:(int)val
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark -- 分享
- (IBAction)share:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:@"该功能暂未开放"  closeButtonTitle:@"确定" duration:2.0f];
}

extern NSString *const UMShareToLWSession;
#pragma mark -- 抓拍
- (IBAction)snapshootTouchDown:(UIButton *)sender {
    [self setImg:sender img:@"snapshootPre"];
    [[PlaySystemSoundManager sharePlaySound]playSoundWithSoundName:@"photoShutter.caf"];
}

- (IBAction)snapshootTouchUpInside:(id)sender {
    [self setImg:sender img:@"snapshoot"];
    //根据时间，创建当天的路径 用于保存照片
    NSString *strPhoto = @"Photo";
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateCur = [NSDate date];
    [outputFormatter stringFromDate:dateCur];
    NSString *strCurDate = [outputFormatter stringFromDate:dateCur];
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:strPhoto];
    //判断Photo文件夹是否存在,不存在则创建
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path1 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",strPhoto,strCurDate]];
    //判断日期命名的文件夹是否存在,不存在则创建
    [[NSFileManager defaultManager] createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    

    //日期命名，保存到文件夹下
    BOOL result = NO;
    NSDate *date = [NSDate date];
    //随机数的绝对值
    int value = abs(arc4random());
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [NSString stringWithFormat:@"%@ %d",[outputFormatter stringFromDate:date],value];
    UIImageView *img = [[UIImageView alloc]init];
    img.frame = CGRectMake(0, 0, 320, 400);
    img.image = [UIImage imageNamed:@"camaraDemo"];
    result = [UIImagePNGRepresentation(img.image) writeToFile:[NSString stringWithFormat:@"%@/%@.png",path1,strDate] atomically:YES];
    //保存成功
    if (result) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hadImagesUpdate"];
    }
}

#pragma mark -- 对讲

- (IBAction)sayTouchUpInside:(id)sender {
    if (self.speakEnable) {
        [self setImg:sender img:@"fullscreenSay"];
        self.speakEnable = NO;
    }else{
        [self setImg:sender img:@"fullscreenSayPre"];
        self.speakEnable = YES;
    }
    
}
#pragma mark -- 声音

- (IBAction)voiceTouchUpInside:(id)sender {
    if (self.voiceOpen) {
        [self setImg:sender img:@"voicePre"];
        self.voiceOpen = NO;
    }else{
        [self setImg:sender img:@"voice"];
        self.voiceOpen = YES;
    }
    
}
#pragma mark -- 设置图片
-(void)setImg:(id)sender img:(NSString*)imgName
{
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (IBAction)settingButtonClicked:(id)sender {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
