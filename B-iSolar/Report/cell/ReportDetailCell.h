//
//  ReportDetailCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/1.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportDetailCell : UITableViewCell
{
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;

    
    IBOutlet UIView *line0;
    IBOutlet UIView *line1;
    IBOutlet UIView *line2;
    IBOutlet UIView *line3;
}
- (void)setData:(BResponseModel*)model andIndex:(NSIndexPath*)indexPath;
- (void)setDataDetailV:(BResponseModel*)model andIndex:(NSIndexPath*)indexPath andType:(NSInteger)type;


@end

NS_ASSUME_NONNULL_END
