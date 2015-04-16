

#import "TestTableViewCell.h"

@implementation TestTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
          delegate:(id<CustomTableViewCellDelegate>)delegate
       inTableView:(UITableView *)tableView
withRightButtonTitles:(NSArray *)rightButtonTitles{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self){
        _cView=[[UILabel alloc]initWithFrame:self.bounds];
        _cView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        //_contentView.backgroundColor=[UIColor grayColor];
        [self.cellContentView addSubview:_cView];
    }
    return self;
}

@end
