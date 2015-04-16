//
//  MyDeviceViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MyDeviceViewController.h"


#define kSpace 10
#define cell_h 200
@interface MyDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyDeviceViewController



-(void)viewWillAppear:(BOOL)animated
{
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.tabBarController.tabBar.hidden = NO;
    shuldStatusbarHidden(NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, MRScreenWidth, SCREEN_HEIGHT);
    self.tableView.backgroundColor = ColorFromRGB(0xf0f0f6);
    //添加头部及尾部拉动刷新
    [self.tableView addHeaderWithCallback:^{
        //下拉放开回调
        [self performSelector:@selector(headerEndRefresh) withObject:nil afterDelay:3];
    }];
    [self.tableView addFooterWithCallback:^{
        //上拉放开回调
        [self.tableView footerEndRefreshing];
    }];

    [self.tableView reloadData];
    self.title = @"设备";
    self.tableView.contentSize = CGSizeMake(MRScreenWidth, (cell_h+kSpace)*5);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}
- (void) headerEndRefresh
{
    [self.tableView headerEndRefreshing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_h;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kSpace, kSpace, MRScreenWidth-kSpace*2, cell_h-kSpace)];
        [cell addSubview:view];
        
        //播放按钮
        UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        videoImg.image = [UIImage imageNamed:@"camaraDemo.png"];
        [view addSubview:videoImg];
        
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 30)];
        barView.backgroundColor = [UIColor clearColor];
//        barView.alpha = 0.6;
        [view addSubview:barView];
        
        float width = (barView.frame.size.width-kSpace)/2;
        UILabel *devNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 30)];
//        devNameLabel.text = @"客厅";
        devNameLabel.font = [UIFont systemFontOfSize:13];
        devNameLabel.textColor = [UIColor whiteColor];
        [barView addSubview:devNameLabel];
        
        UILabel *devTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, 30)];
//        devTimeLabel.text = @"2015-01-27 22:00";
        devTimeLabel.font = [UIFont systemFontOfSize:13];
        devTimeLabel.textAlignment = NSTextAlignmentRight;
        devTimeLabel.textColor = [UIColor whiteColor];
        [barView addSubview:devTimeLabel];
        //播放按钮
        UIImageView *playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        playImg.image = [UIImage imageNamed:@"playButton"];
        playImg.center = view.center;
        [view addSubview:playImg];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"MyCamaraVC"];
    vc.tabBarController.view.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (IBAction)pushViewController:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加设备",@"删除设备", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self toQRCocdeViewController];//二维码页面
            break;
        case  1:
            [self showDleleView];
            break;
            
        default:
            break;
    }
}
#pragma mark -- 二维码页面
- (void)toQRCocdeViewController
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"QRCodeVC"];
    vc.tabBarController.view.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --显示删除相关的视图
- (void)showDleleView
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
