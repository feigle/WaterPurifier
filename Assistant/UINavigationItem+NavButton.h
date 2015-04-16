//
//  UINavigationItem+NavButton.h
//  KuaiKuai
//
//  Created by Andy on 13-7-30.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (NavButton)


-(void)modfyNavLeftButton :(NSString *)title action :(SEL)action target:(id)atarget;
-(void)modfyNavRightButton :(NSString *)titleOrImage secondString:(NSString *)secondImage  action :(SEL)action target:(id)atarget;
@end
