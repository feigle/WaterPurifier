//
//  JLLoadingView.h
//  VideoMonitor
//
//  Created by Joblee on 14-11-27.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLLoadingView : UIView
{
    UIView          *contentView;
    UIImageView     *imageView;
    UILabel         *textLabel;
    UIView          *backGroundView;
}
@property (nonatomic,assign) BOOL isAnimating;
- (void)startAnimation;
- (void)stopAnimation;
@end
