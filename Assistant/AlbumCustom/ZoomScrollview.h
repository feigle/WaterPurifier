//
//  ZoomScrollview.h
//  VideoMonitor
//
//  Created by Joblee on 14-9-17.
//  Copyright (c) 2014年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol videoPlayDelegate <NSObject>
- (void)playWithPath:(NSString*)path;
- (void)singleTap;
@end
@interface ZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UITapGestureRecognizer *doubleTapGesture;
    NSString *photoPath;
    BOOL isVideo;
}

@property (nonatomic) id<videoPlayDelegate>playDelegate;
@property (nonatomic) BOOL zoomEnable;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIView *flashView;
@property (nonatomic, retain) NSDictionary *imageDic;
//@property (nonatomic, retain)
- (void)initImgView;
/**
 *  放大至正常倍数
 */
- (void)zoomToNomal;
- (void)setImage;
@end
