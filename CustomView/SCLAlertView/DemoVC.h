//
//  ViewController.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014 AnyKey Entertainment. All rights reserved.
//

/**
 * 弹出警告框
 **/

#import <UIKit/UIKit.h>

@interface DemoVC : UIViewController

- (IBAction)showSuccess:(id)sender;
- (IBAction)showError:(id)sender;
- (IBAction)showNotice:(id)sender;
- (IBAction)showWarning:(id)sender;
- (IBAction)showInfo:(id)sender;
- (IBAction)showEdit:(id)sender;

@end

