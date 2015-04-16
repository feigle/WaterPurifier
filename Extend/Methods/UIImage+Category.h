//
//  UIImage+Category.h
//  WaterPurifier
//
//  Created by bjdz on 15-1-28.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(category)
/**
 * 取视频的缩略图（视频当中的某一帧图像）
 */
+(UIImage *)getImage:(NSString *)videoURL;
/**
 *  取图片中最多的颜色
 *
 *  @return
 */
-(UIColor*)mostColor;
/**
 *  自动缩放到指定大小
 *
 *  @param image
 *  @param asize 返回图片的比例（width/height），指定大小
 *
 *  @return
 */
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
/**
 *  保持原来的长宽比，生成缩略图
 *
 *  @param image
 *  @param asize 返回图片的大小
 *
 *  @return
 */
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
