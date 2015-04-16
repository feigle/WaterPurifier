//
//  addDevManuallyViewController.h
//  WaterPurifier
//
//  Created by bjdz on 15-2-2.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addDevManuallyViewController : UIViewController<RequestManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *targetTF;

@end
