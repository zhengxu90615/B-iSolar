//
//  CheckPointTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckPointTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UISegmentedControl *segControl;
    
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    
    IBOutlet UIView *line;
    IBOutlet UIView *bgView;
    
    NormalBlock myBlock;
    NormalBlock myBlock1;
    NormalBlock myBlock2;

    NSInteger lastSelectIndex;
}

- (IBAction)segChanged:(id)sender;
- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block andLeftClick:(NormalBlock)lefBlock andRightClick:(NormalBlock)rightBlock;
- (IBAction)leftClick:(id)sender;
- (IBAction)rightClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
