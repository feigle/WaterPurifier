//
//  LineView.m
//  WaterPurifier
//
//  Created by bjdz on 15-1-28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "LineView.h"

@implementation LineView
- (UIView*)initWithColor:(UIColor*)color andFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.backgroundColor = color;
        self.frame = frame;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
