//
//  IndicatorViewCustom.h
//  WaterPurifier
//
//  Created by bjdz on 15-3-6.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorViewCustom : UIView
@property (assign, nonatomic)CGFloat downloadedBytes;
/**
 *  开始加载动画
 *
 *  @param dur 动画执行时间
 */
- (void)startAnimation:(float)dur;
@end
