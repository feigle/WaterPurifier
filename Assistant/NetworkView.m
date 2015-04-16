//
//  NetworkView.m
//  MerchantsOA
//
//  Created by Loong on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkView.h"

@implementation NetworkView
@synthesize alertView;

- (id)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, MRScreenWidth, 460);
    self = [super initWithFrame:rect];
    if(self)
    {
        NSString *title = @"正在获取数据，请稍候...";
        alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        [alertView show];
        
        CGRect frame = CGRectMake(0.0, 0.0, 32, 32);
        UIActivityIndicatorView *progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];

        //判断系统是否高于5.0
        NSString* version =[[UIDevice currentDevice] systemVersion];
        if([version compare:@"5.0"]!=NSOrderedAscending){
            progressInd.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }
        
        /*progressInd.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;*/
        
        progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

        CGPoint point = CGPointMake(142,73);

        [progressInd setCenter:point];
        [progressInd startAnimating];

        [alertView addSubview:progressInd];
        [progressInd release];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reMove)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
       [alertView addGestureRecognizer:tap];
        [tap release];

    }
    
    return self;
}

-(void)reMove
{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    [self removeFromSuperview];
}

- (void)dealloc
{
    [alertView release];
    [super dealloc];
}


@end
