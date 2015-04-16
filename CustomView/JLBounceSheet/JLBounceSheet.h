//
//  JLBounceSheet.h
//  WaterPurifier
//
//  Created by bjdz on 15-2-7.
//  Copyright (c) 2015年 joblee. All rights reserved.
//
/**
 * 底部弹出的选择器
 **/
#import <UIKit/UIKit.h>

@interface JLBounceSheet : UIView
- (id) initWithBgColor:(UIColor*) color vc:(UIViewController*)vc height:(float)height;
-(void) addView:(UIView*) view;
-(void) show;
-(void) hide;
-(void) toggle;
@end
