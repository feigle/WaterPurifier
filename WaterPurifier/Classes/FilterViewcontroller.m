//
//  FilterViewcontroller.m
//  WaterPurifier
//
//  Created by bjdz on 15-3-31.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "FilterViewcontroller.h"
#import "IndicatorViewCustom.h"
#import "Macros.h"
@interface FilterViewcontroller ()<RequestManagerDelegate>


@end

@implementation FilterViewcontroller
-(void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.title = @"滤芯管理";
    [self testInterface];
    [self addPercentViews];
    // Do any additional setup after loading the view.
}
#pragma mark --请求设备信息
- (void)testInterface
{
    NSString *openid = [kUD objectForKey:@"openid"];
    NSString *token = [kUD objectForKey:@"token"];
    RequestManager *request = [RequestManager share];
    [request setDelegate:self];
    
    NSMutableDictionary* formData = [NSMutableDictionary dictionaryWithCapacity:0];
    [formData setValue:openid    forKey:@"openid"];
    [formData setValue:token     forKey:@"token"];
    //更新token
//url:http://localhost/user/updateToken
    [request requestWithType:AsynchronousType RequestTag:@"updateToken" FormData:formData Action:@"user/updateToken"];
//检查绑定 经测试OK
//    url:http://localhost/user/check
//    NSString *mac =  [kUD objectForKey:@"mac"];
//     [formData setValue:mac     forKey:@"mac"];
//    [request requestWithType:AsynchronousType RequestTag:@"check" FormData:formData Action:@"user/check"];
}

-(void)requestFinish:(ASIHTTPRequest *)retqust Data:(NSDictionary *)data RequestTag:(NSString *)requestTag
{
    if ([[data objectForKey:@"state"] boolValue]) {
    
    }else{

        
    }
}

- (void)addPercentViews
{
    float w= MRScreenWidth;
    for (int i=0; i<3; i++) {
        //加载圆圈
        IndicatorViewCustom * indicatorView = [[IndicatorViewCustom alloc]init];
        indicatorView.frame = CGRectMake(w/12, 64+w/10+i*(30+w/3), w/3,320/3);
        [self.view addSubview:indicatorView];
        indicatorView.downloadedBytes = 99;
        [indicatorView startAnimation:1];
    }
    for (int i=0; i<2; i++) {
        //加载圆圈
        IndicatorViewCustom * indicatorView = [[IndicatorViewCustom alloc]init];
        indicatorView.frame = CGRectMake(w/12+w/2, 64+w/10+i*(30+w/3), w/3,320/3);
        [self.view addSubview:indicatorView];
        indicatorView.downloadedBytes = 99;
        [indicatorView startAnimation:1];
    }
}

- (void)initData
{
//    [self.infoDic objectForKey:@""];
   
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
