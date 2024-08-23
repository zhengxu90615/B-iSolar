//
//  CheckSthCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/11.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckSthCell : UITableViewCell
{
    IBOutlet UILabel *label;
    IBOutlet UISegmentedControl *seg;
    NormalBlock myBlock;

    IBOutlet UIView *bgV;
}
- (IBAction)segChanged:(id)sender;

- (void)setData:(NSDictionary *)dic  canEdit:(BOOL)canEdit andBlock:(NormalBlock)block;
@end

NS_ASSUME_NONNULL_END
