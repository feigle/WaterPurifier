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
        view.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:view];
        
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
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
