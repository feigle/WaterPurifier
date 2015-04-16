

#import <UIKit/UIKit.h>
#define CustomTableViewCellNotificationChangeToUnexpanded @"CustomTableViewCellNotificationChangeToUnexpanded"
typedef enum CustomTableViewCellState:NSUInteger{
    CustomTableViewCellStateUnexpanded=0,
    CustomTableViewCellStateExpanded=1,
} CustomTableViewCellState;
@class CustomTableViewCell;
@protocol CustomTableViewCellDelegate <NSObject>
-(void)buttonTouchedOnCell:(CustomTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath atButtonIndex:(NSInteger)buttonIndex;
@end
@interface CustomTableViewCell : UITableViewCell{
    CustomTableViewCellState _state;
}
@property (nonatomic,assign) CustomTableViewCellState state;///当前的状态
@property (nonatomic,assign) UITableView* tableView;
@property (nonatomic,retain) UIView* buttonsView;
@property (nonatomic,retain) UIScrollView* scrollView;
@property (nonatomic,retain) UIView* cellContentView;
@property (nonatomic,assign) id<CustomTableViewCellDelegate> delegate;
@property (nonatomic,copy) NSArray* rightButtonTitles;///按钮的标题
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id<CustomTableViewCellDelegate>)delegate 
        inTableView:(UITableView*)tableView
withRightButtonTitles:(NSArray*)rightButtonTitles;
@end
