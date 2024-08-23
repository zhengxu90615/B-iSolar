//
//  NoticeTyleTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTyleTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *imageV;
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UIView *dot;
}
- (void)setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
