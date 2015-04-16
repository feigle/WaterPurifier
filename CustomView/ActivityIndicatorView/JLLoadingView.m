//
//  JLLoadingView.m
//  VideoMonitor
//
//  Created by Joblee on 14-11-27.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "JLLoadingView.h"
#import "Additions.h"

#define Internal 0.5
@implementation JLLoadingView
@synthesize isAnimating;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"loading"];
        [self addSubview:imageView];
        // Initialization code
    }
    return self;
}


/**
 *  开始动画
 */
- (void)startAnimation
{
    isAnimating = NO;
    self.hidden = NO;
    [self drawLoadingView];
    
}
-(void)drawLoadingView
{
    if (!isAnimating) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = @(0);
        animation.toValue = @(M_PI);
        animation.duration = 0.5f;
        animation.repeatCount = INT_MAX;
        [imageView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
        [self performSelector:@selector(drawLoadingView) withObject:nil afterDelay:0.5f];
    }
    if (self.alpha <= 0) {
        [self breathToUnClear];
    }
}

/**
 *  停止动画
 */
-(void)stopAnimation
{
    if (!isAnimating) {
        self.hidden = YES;
        isAnimating = YES;
        [self breathToClear];
        [imageView.layer performSelector:@selector(removeAllAnimations) withObject:nil afterDelay:Internal];
        
    }
    
}

/**
 *  可视
 */
- (void)breathToUnClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:Internal];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[self setAlpha:1.0f];
	[UIView commitAnimations];
    self.hidden = YES;
}
/**
 *  不可视
 */
- (void)breathToClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:Internal];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}







@end
