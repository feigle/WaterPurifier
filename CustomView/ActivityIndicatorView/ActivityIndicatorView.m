//
//  ActivityIndicatorView.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-17.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "ActivityIndicatorView.h"
#import "Additions.h"
#define MainScrenSize_W CGRectGetWidth([UIScreen mainScreen].bounds)
#define MainScrenSize_H CGRectGetHeight([UIScreen mainScreen].bounds)
#define Image_Size 60
#define ImageSpace_Top 20
#define Height 130
#define Font_Size [UIFont systemFontOfSize:15]
#define Text @"正在加载..."
#define Internal 0.5
static ActivityIndicatorView *AIV = nil;
@implementation ActivityIndicatorView
+(id)share
{
    @synchronized(self){
        if (!AIV) {
            AIV = [[self alloc]init];
            [AIV initImageView];
        }
    }
    return AIV;
}
-(void)initImageView
{

    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MainScrenSize_W, MainScrenSize_H-64)];
//    contentView.backgroundColor = [UIColor blackColor];
//    contentView.alpha = 0.8;
    backGroundView = [[UIView alloc]initWithFrame:[self BGViewFrameWithText:Text]];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.8;
    backGroundView.layer.cornerRadius = 8;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.autoresizesSubviews = YES;
    backGroundView.contentMode = UIViewContentModeCenter;
    [contentView addSubview:backGroundView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(backGroundView.bounds)-Image_Size)/2, ImageSpace_Top, Image_Size, Image_Size)];
    imageView.image = [UIImage imageNamed:@"loading"];
    imageView.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:imageView];
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(backGroundView.bounds), CGRectGetHeight(backGroundView.bounds)-CGRectGetMaxY(imageView.frame))];
    textLabel.text = Text;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 5;
    textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = Font_Size;
    textLabel.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:textLabel];
    
}
/**
 *  imageView Size
 *
 *  @return size
 */
-(CGRect)imageFrame
{
    return CGRectMake((CGRectGetWidth(backGroundView.bounds)-Image_Size)/2, ImageSpace_Top, Image_Size, Image_Size);
}
/**
 *  Label Size
 *
 *  @return size
 */
-(CGRect)labelFrame
{

    return CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(backGroundView.bounds), CGRectGetHeight(backGroundView.bounds)-CGRectGetMaxY(imageView.frame));
}
/**
 *  根据文字来返回视图大小
 *
 *  @param text 文字
 *
 *  @returnsize
 */
-(CGRect)BGViewFrameWithText:(NSString*)text
{
    CGSize size = [NSString sizeForString:text fontSize:Font_Size withLabelHeight:CGRectGetHeight(textLabel.bounds)];
    size.width = size.width+20;
    if (size.width<120) {
        size.width = 120;
    }
    return CGRectMake((MainScrenSize_W-size.width)/2, (MainScrenSize_H-64-Height)/2, size.width, Height);
}
/**
 *  开始动画
 */
- (void)startAnimation
{
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [self addAnimation];
}
/**
 *  开始动画，并设定动画时间长度
 *
 *  @param seconds 时间
 */
- (void)startAnimationWithInterval:(NSTimeInterval)seconds
{
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:seconds];
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [self addAnimation];
}

/**
 *  开始动画，并且自定义文字
 *
 *  @param text 自定义文字
 */
-(void)startAnimationWithText:(NSString*)text
{
    
    backGroundView.frame = [self BGViewFrameWithText:text];
    imageView.frame = [self imageFrame];
    textLabel.text = text;
    textLabel.frame = [self labelFrame];
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [self addAnimation];
}
/**
 *  开始动画，并且自定义文字及设定动画时间长度
 *
 *  @param text    自定义文字
 *  @param seconds 时间
 */
-(void)startAnimationWithText:(NSString*)text andInterval:(NSTimeInterval)seconds
{
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:seconds];
    backGroundView.frame = [self BGViewFrameWithText:text];
    imageView.frame = [self imageFrame];
    textLabel.text = text;
    textLabel.frame = [self labelFrame];
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [self addAnimation];
}
/**
 *  停止动画
 */
-(void)stopAnimation
{
    [self breathToClear];
    [imageView.layer performSelector:@selector(removeAllAnimations) withObject:nil afterDelay:Internal];
    [contentView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:Internal];
}
/**
 *  imageView 添加旋转动画
 */
-(void)addAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self breathToUnClear];
}
/**
 *  可视
 */
- (void)breathToUnClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:Internal];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[contentView setAlpha:1.0f];
	[UIView commitAnimations];
//    [self performSelector:@selector(breathToClear) withObject:nil afterDelay:1];
}
/**
 *  不可视
 */
- (void)breathToClear{
    [UIView beginAnimations:@"flash screen" context:nil];
	[UIView setAnimationDuration:Internal];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[contentView setAlpha:0.0f];
	[UIView commitAnimations];
//    [self performSelector:@selector(breathToUnClear) withObject:nil afterDelay:1];
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
