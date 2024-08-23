//
//  RuleTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/1.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuleTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    NormalBlock myBlock;
    IBOutlet UISwitch *sw;
    IBOutlet UIImageView *imageV;
}
- (void)setData:(NSDictionary *)title andBlock:(NormalBlock)block;
- (void)selected:(BOOL)selected;
- (void)hlightBg:(BOOL)selected;
@end


NS_ASSUME_NONNULL_END
