

/**
 *类似一个有弹簧效果的tableview
 **/


#import <UIKit/UIKit.h>

@interface SpringCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat springFrequency;
@property (nonatomic, assign) CGFloat resistanceFactor;
@end
