//
//  PlayOnlineViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-25.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "PlayOnlineViewController.h"
@interface PlayOnlineViewController ()

@end

@implementation PlayOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
   [self performSelector:@selector(showNotice:) withObject:@"本功能暂未开放,敬请期待!" afterDelay:.3];
}
-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
    
}
- (IBAction)backup:(id)sender {
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
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
