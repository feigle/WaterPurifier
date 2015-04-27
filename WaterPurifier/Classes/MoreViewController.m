//
//  MoreViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-25.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "MoreViewController.h"
#import "CommonFunc.h"
#import "UserInfoViewController.h"
#import "Macros.h"
@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *cellTextArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    cellTextArr = [NSArray arrayWithObjects:@"功能设置",@"帮助",@"意见反馈",@"关于我们",@"检查更新", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
    [CommonFunc setExtraCellLineHidden:self.tableView];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        NSInteger index = 0;
        if (indexPath.section == 0) {
            index = indexPath.row;
        }else if (indexPath.section == 1){
            index = 1 + indexPath.row;
        }
        
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [cellTextArr objectAtIndex:index];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showNotice:@"本功能暂未开放,敬请期待!"];
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 1:
                [CommonFunc pushViewController:self.navigationController andControllerID:@"feedback" andStoryBoard:self.storyboard];
                break;
            case 3:
                [self showNotice:@"已是最新版本!"];
                break;
                
            default:
                [self showNotice:@"本功能暂未开放,敬请期待!"];
                break;
        }
    }else
        [self showNotice:@"本功能暂未开放,敬请期待!"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:2.0f];

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
