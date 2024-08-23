//
//  AssestOTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/2.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssestOTableViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UIView *bgV;
    IBOutlet UIImageView *stationImg;
}

- (void)setTitle:(NSString *)titles;

@end

NS_ASSUME_NONNULL_END
