//
//  JLBlurView.m
//  WaterPurifier
//
//  Created by bjdz on 15-2-7.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "JLBlurView.h"

#import <QuartzCore/QuartzCore.h>

@interface JLBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation JLBlurView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self setClipsToBounds:YES];
    
    if (![self toolbar]) {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolbar setFrame:[self bounds]];
}

@end
