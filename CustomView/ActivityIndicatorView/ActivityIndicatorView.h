//
//  ActivityIndicatorView.h
//  VideoMonitor
//
//  Created by Joblee on 14-10-17.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView
{
    UIView          *contentView;
    UIImageView     *imageView;
    UILabel         *textLabel;
    UIView          *backGroundView;
}
+ (id)share;
- (void)startAnimation;
- (void)startAnimationWithText:(NSString*)text;
- (void)startAnimationWithInterval:(NSTimeInterval)seconds;
- (void)startAnimationWithText:(NSString*)text andInterval:(NSTimeInterval)seconds;
- (void)stopAnimation;
@end
