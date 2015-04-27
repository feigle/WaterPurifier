//
//  MessagesViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//
#import "Macros.h"
#import "MessagesViewController.h"
#import "CustomTableViewCell.h"
#import "TestTableViewCell.h"
#define cell_h 60
#define cellSpace 30
#define camaraLabel_tag 5554
#define titleLabel_tag 5555
#define weekLabel_tag 5556
#define detailLabel_tag 5557
#define pointImg_tag 3243
#define line_tag 65567
@interface MessagesViewController ()<UITableViewDelegate,UITableViewDataSource,CustomTableViewCellDelegate,UIActionSheetDelegate>
{
    NSArray * arrTest;
    NSMutableArray *muArr;
    BOOL isSelected[20];
    BOOL isEdit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MessagesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [CommonFunc setExtraCellLineHidden:self.tableView];
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    
    arrTest = [NSArray arrayWithObjects:@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",@"设备 1092",nil];
    muArr = [[NSMutableArray alloc]init];
    for (NSString *text in arrTest) {
        float height = [self heightForString:text fontSize:13 andWidth:SCREEN_WIDTH-cellSpace-20]+30;
        if (height<cellHeight) {
            height = cellHeight;
        }
        [muArr addObject:[NSNumber numberWithFloat:height]];
    }
//    [self.tableView reloadData];
//    [self performSelector:@selector(tast) withObject:nil afterDelay:2];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}
#pragma mark - UITableDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[muArr objectAtIndex:indexPath.row] floatValue];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return muArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell-identity";
    TestTableViewCell* cell=(TestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell){
        cell=[[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identity
                                             delegate:self
                                          inTableView:tableView withRightButtonTitles:@[@"更多",@"删除"]];
        
    }

  
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[arrTest objectAtIndex:indexPath.row]];
    
    
    return cell;
}

#pragma mark - CustomTableViewCellDelegate
-(void)buttonTouchedOnCell:(CustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
    if (buttonIndex==1){
        [muArr removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomTableViewCellNotificationChangeToUnexpanded object:nil];
    }
    else if (buttonIndex==0){
        UIActionSheet* actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看" otherButtonTitles:@"解除绑定",@"编辑", nil];
        [actionSheet showInView:self.view];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSNotificationCenter defaultCenter] postNotificationName:CustomTableViewCellNotificationChangeToUnexpanded object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self toMessageDetailViewcontroller];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    isSelected[indexPath.row]  = YES;
}



- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (void)toMessageDetailViewcontroller
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailViewcontroller"];
    vc.tabBarController.view.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  字符串高度计算方法
 *
 *  @param value    需要计算的字符串
 *  @param fontSize 字体大小
 *  @param width    宽度
 *
 *  @return 高度
 */
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
