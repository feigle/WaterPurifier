//
//  AlbumViewController.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "AlbumViewController.h"



@interface AlbumViewController (){

}

@property (weak, nonatomic) IBOutlet UITableView *tableImage;
@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BarRight;
@property (weak, nonatomic) IBOutlet UIView *viewControl;
@property (weak, nonatomic) IBOutlet UINavigationItem *navingationItem;
@property (strong, nonatomic)  NSMutableDictionary *dicImageDel;
@property (nonatomic,retain) NSArray *docList;

@property (weak, nonatomic)UIButton *deleteBtn;

@end

@implementation AlbumViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.title = @"帮助";
    // Do any additional setup after loading the view.
}



@end
