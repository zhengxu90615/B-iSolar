//
//  ErrorTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ErrorTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *nameLabel;
    IBOutlet CustomLabel *detailLabel;
    NormalBlock myBlock;
    UIButton *button;
}
- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block;
@end

NS_ASSUME_NONNULL_END
