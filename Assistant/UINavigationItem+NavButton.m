//
//  UINavigationItem+NavButton.m
//  KuaiKuai
//
//  Created by Andy on 13-7-30.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import "UINavigationItem+NavButton.h"

@implementation UINavigationItem (NavButton)


-(void)modfyNavLeftButton :(NSString *)title action :(SEL)action target:(id)atarget 
{
    //设置左上角按钮
    UIButton *aLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImageNormal = [UIImage imageNamed:@"title_button_back-normal"];
    UIImage *leftImageSelect = [UIImage imageNamed:@"title_button_back-sending"];
    leftImageNormal = [leftImageNormal  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
    leftImageSelect = [leftImageSelect  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
    aLeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    aLeftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    aLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
    
    [aLeftBtn setBackgroundImage:leftImageNormal forState:UIControlStateNormal];
    [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateSelected];
    [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateHighlighted];
    [aLeftBtn setTitle:title forState:UIControlStateNormal];
    
    CGSize size=[title sizeWithFont:aLeftBtn.titleLabel.font constrainedToSize:CGSizeMake(320, aLeftBtn.bounds.size.height)];
    
    aLeftBtn.frame = CGRectMake(0.0, 0.0, size.width + 30, 30.0);
    [aLeftBtn addTarget:atarget action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc] initWithCustomView:aLeftBtn];
    self.leftBarButtonItem = leftBarBtn;
    [leftBarBtn release];

}
-(void)modfyNavRightButton :(NSString *)titleOrImage secondString:(NSString *)secondImage  action :(SEL)action target:(id)atarget
{
    //设置左上角按钮
    if ((secondImage == nil)||(secondImage.length == 0)) {
        UIButton *aLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *leftImageNormal = [UIImage imageNamed:@"right_normal"];
        UIImage *leftImageSelect = [UIImage imageNamed:@"right_sending"];
        leftImageNormal = [leftImageNormal  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
        leftImageSelect = [leftImageSelect  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
        aLeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        aLeftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        aLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        [aLeftBtn setBackgroundImage:leftImageNormal forState:UIControlStateNormal];
        [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateSelected];
        [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateHighlighted];
        [aLeftBtn setTitle:titleOrImage forState:UIControlStateNormal];
        
        CGSize size=[titleOrImage sizeWithFont:aLeftBtn.titleLabel.font constrainedToSize:CGSizeMake(320, aLeftBtn.bounds.size.height)];
        aLeftBtn.frame = CGRectMake(0.0, 0.0, size.width + 25, 30.0);
        [aLeftBtn addTarget:atarget action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc] initWithCustomView:aLeftBtn];
        self.rightBarButtonItem = leftBarBtn;
        [leftBarBtn release];

    }
    else 
    {
        UIButton *aLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *leftImageNormal = [UIImage imageNamed:titleOrImage];
        UIImage *leftImageSelect = [UIImage imageNamed:secondImage];
//        leftImageNormal = [leftImageNormal  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
//        leftImageSelect = [leftImageSelect  stretchableImageWithLeftCapWidth:25.0f topCapHeight:15.0f];
        //        aLeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        //        aLeftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        //        aLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
        
        [aLeftBtn setBackgroundImage:leftImageNormal forState:UIControlStateNormal];
        [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateSelected];
        [aLeftBtn setBackgroundImage:leftImageSelect forState:UIControlStateHighlighted];
        // [aLeftBtn setTitle:titleOrImage forState:UIControlStateNormal];
        
        aLeftBtn.frame = CGRectMake(0.0, 0.0, leftImageNormal.size.width, 30.0);
        [aLeftBtn addTarget:atarget action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc] initWithCustomView:aLeftBtn];
        self.rightBarButtonItem = leftBarBtn;
        [leftBarBtn release];

    }

}

@end
