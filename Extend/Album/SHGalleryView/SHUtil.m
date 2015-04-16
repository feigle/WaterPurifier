//
//  Util.m
//  SHGalleryView
//
//  Created by SHAN UL HAQ on 8/5/14.
//  Copyright (c) 2014 com.grevolution.shgalleryview. All rights reserved.
//

#import "SHUtil.h"

@implementation SHUtil

+ (UIView *)viewFromNib:(NSString *)nibName bundle:(NSBundle *)bundle {
	if (!nibName || [nibName length] == 0) {
		return nil;
	}
	
	UIView *view = nil;
	
	if (!bundle) {
		bundle = [NSBundle mainBundle];
	}
	
	// I assume, that there is only one root view in interface file
	NSArray *loadedObjects = [bundle loadNibNamed:nibName owner:nil options:nil];
	view = [loadedObjects lastObject];
	
	return view;
}

+ (void)constrainViewEqual:(UIView *)view toParent:(UIView *)parent {
    NSLog(@"view origin.x = %f,view origin.y = %f",view.frame.origin.x,view.frame.origin.y);
    NSLog(@"view origin.width = %f,view origin.height = %f",view.frame.size.width,view.frame.size.height);

    
    NSLog(@"parent origin.x = %f,parent origin.y = %f",parent.frame.origin.x,parent.frame.origin.y);
    NSLog(@"parent origin.width = %f,parent origin.height = %f",parent.frame.size.width,parent.frame.size.height);

//    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:parent attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *con2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:parent attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *con3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:0 toItem:parent attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *con4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:0 toItem:parent attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSArray *constraints = @[con1,con2,con3,con4];
    [parent addConstraints:constraints];
}


@end
