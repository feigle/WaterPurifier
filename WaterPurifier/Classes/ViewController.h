//
//  ViewController.h
//  WaterPurifier
//
//  Created by bjdz on 15-1-22.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDKAirMenuController.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *headImage;
}

@property (nonatomic, strong) XDKAirMenuController *airMenuController;

@end
