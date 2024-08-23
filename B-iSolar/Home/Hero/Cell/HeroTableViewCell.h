//
//  HeroTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeroTableViewCell : UITableViewCell
{
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    
}
- (void)setData:(NSDictionary *)data andIndex:(int)d;

@end

NS_ASSUME_NONNULL_END
