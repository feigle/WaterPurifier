//
//  ViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "ViewController.h"
#import "PRTween.h"
#import "IndicatorViewCustom.h"
#import "Macros.h"

@interface ViewController ()<XDKAirMenuDelegate>
{
    NSArray *arr;
    NSArray *imgArr;
    IndicatorViewCustom *indicatorView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL rotateEnable;

@end

@implementation ViewController

-(BOOL)shouldAutorotate

{
    return self.rotateEnable;
    
}
- (void)setTheRotate
{
    self.rotateEnable = !self.rotateEnable;
}
/**
 *  左边菜单将要打开时调用
 *  添加弹跳动画
 */
- (void)menuWillOpen
{
    for (int i=1; i<10; i++) {
         NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        if (cell) {
            [PRTween performSelector:@selector(animationLikeAlertView:) withObject:cell.imageView afterDelay:0.1+0.05*i];
            [PRTween performSelector:@selector(animationLikeAlertView:) withObject:cell.textLabel afterDelay:0.1+0.05*i];
        }
    }
    [PRTween performSelector:@selector(animationLikeAlertView:) withObject:headImage afterDelay:0.2];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册接收改变头像的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHeadViewImage) name:@"changeHeadImage" object:nil];
    //返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //设置导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:ColorFromRGB(0x004a80)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTheRotate) name:@"canReloadtion" object:nil];
    
    UIImageView *bacImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    bacImage.image = [UIImage imageNamed:@"userInfoBG"];
    [self.view addSubview:bacImage];
    
    arr = [NSArray arrayWithObjects:@"主页",@"密码重置",@"帮助",@"关于我们", nil];
    imgArr = [NSArray arrayWithObjects:@"iconDev",@"iconDev",@"iconDev",@"iconMore",@"iconDev", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MRScreenHeight, MRScreenHeight)];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.airMenuController = [XDKAirMenuController sharedMenu];
    self.airMenuController.airDelegate = self;
    
    [self.view addSubview:self.airMenuController.view];
    
    [self addChildViewController:self.airMenuController];
	// Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell=nil;
    cell= [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showsReorderControl =YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        if (indexPath.row==0) {//头像
            
//            indicatorView = [[IndicatorViewCustom alloc]init];
//            indicatorView.frame = CGRectMake(0, 0, 108, 1078);
//            [cell addSubview:indicatorView];
//            [indicatorView startAnimation:0.1];
            
            [cell addSubview:[self getHeadImage]];
//            indicatorView.center = headImage.center;
            
            UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake((MRScreenWidth-150)/2, 100+50, 100, 30)];
            NameLabel.textAlignment = NSTextAlignmentCenter;
            NameLabel.font = [UIFont systemFontOfSize:14];
            NameLabel.text = [kUD objectForKey:@"account"];
            NameLabel.textColor = [UIColor whiteColor];
            [cell addSubview:NameLabel];
        }
        else{
            CGFloat cell_w = cell.frame.size.width;
            CGFloat cell_h = cell.frame.size.height;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell_h-1, cell_w, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:0/255.0f green:105/255.0f blue:163/255.0f alpha:1];
            [cell addSubview:lineView];
            NSString *imgName = [imgArr objectAtIndex:0];
            cell.imageView.image = [UIImage imageNamed:imgName];
        }
        if (indexPath.row>0 && indexPath.row<5) {
            cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        }
        
    }else{
        
    }
    
    return cell;
}
-(UIImageView *)getHeadImage
{
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake((MRScreenWidth-150)/2, 50, 100, 100)];
    [self setHeadViewImage];
    
    headImage.layer.cornerRadius = (headImage.frame.size.width)/2;
    headImage.layer.masksToBounds = YES;
    return headImage;
}
- (void)setHeadViewImage
{
    ///根据时间，创建当天的路径 用于保存照片
    NSString *strPhoto = @"HeadImages/headImage.png";
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:strPhoto];
    
    NSData*data = [NSData dataWithContentsOfFile:path];
    UIImage *img = [UIImage imageWithData:data];
    if (img) {
        [headImage setImage:img];
    }else{//不存在则用默认图片
        [headImage setImage:[UIImage imageNamed:@"userLOGO"]];
    }
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
#pragma mark -- 向下一个controller传送数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableViewSegue"])
    {
//        self.tableView = ((UITableViewController*)segue.destinationViewController).tableView;
        
    }
}

#pragma mark - XDKAirMenuDelegate

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (indexPath.row == 0)
        vc = [storyboard instantiateViewControllerWithIdentifier:@"userInfoRootVC"];
    
    else if (indexPath.row == 1)
        vc = [storyboard instantiateViewControllerWithIdentifier:@"DevicesNC"];
    else if (indexPath.row == 2){
        vc = [storyboard instantiateViewControllerWithIdentifier:@"moreNV"];
    }else{
        vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginNV"];
    }
    return vc;
}

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu
{
    return self.tableView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
