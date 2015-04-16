//
//  UserInfoViewController.h
//  WaterPurifier
//
//  Created by bjdz on 15-1-23.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoTableView.h"
@interface UserInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UserInfoTableView *tableView;

@end
