//
//  CheckModelTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/1.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckModelTableViewCell : UITableViewCell
{
    IBOutlet UIView *line0;
    IBOutlet UIView *line1;
    IBOutlet UIView *line2;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *ruleNameLabel;
    IBOutlet UILabel *ruleLabel;
    IBOutlet UIView *bgView;
    IBOutlet UILabel *decLabel;
    IBOutlet UILabel *selectLabel;
    NormalBlock myBlock;
    IBOutlet UISegmentedControl *segmentCrl;
}
- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block;
- (IBAction)segChanged:(UISegmentedControl *)sender;

@end

NS_ASSUME_NONNULL_END
