//
//  DetailViewController.h
//  AlbumDemo
//
//  Created by bjdz on 15-3-3.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomScrollView.h"
@interface DetailViewController : UIViewController<UIGestureRecognizerDelegate,
UIScrollViewDelegate,UIAlertViewDelegate,videoPlayDelegate>
{
    CGFloat lastScale;
}
@property (nonatomic, retain) ZoomScrollView  *zoomScrollView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *imagesArr;
@property (nonatomic,assign) int imgNumber;
//进入页面前点击的图片的tag
@property (nonatomic,assign) int curTag;
@property (nonatomic)        BOOL scaleEnable;
@end
