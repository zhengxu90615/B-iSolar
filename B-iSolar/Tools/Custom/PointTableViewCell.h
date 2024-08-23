//
//  PointTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/21.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *valueLabtl;
    IBOutlet UILabel *datelabel;
    
}
- (void)setData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
