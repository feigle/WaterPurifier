//
//  BreatheAnimationView.m
//  VideoMonitor
//
//  Created by Joblee on 14-9-18.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "BreatheAnimationView.h"

@implementation BreatheAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.animationView.backgroundColor = [UIColor redColor];
        self.animationView.alpha = 0;
        [self addSubview:self.animationView];
        [self performSelector:@selector(breathToUnClear) withObject:nil afterDelay:0];
        // Initialization code
    }
    return self;
}
/**
 *  @brief 呼吸灯可视
 */
- (void)breathToUnClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[self.animationView setAlpha:1.0f];
	[UIView commitAnimations];
    [self performSelector:@selector(breathToClear) withObject:nil afterDelay:1];
}
/**
 *  @brief 呼吸灯不可视
 */
- (void)breathToClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[self.animationView setAlpha:0.0f];
	[UIView commitAnimations];
    [self performSelector:@selector(breathToUnClear) withObject:nil afterDelay:1];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
