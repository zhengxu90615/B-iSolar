//
//  ReportTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/24.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportTableViewCell : UITableViewCell
{
    __weak IBOutlet UIView *bgView;
    
    __weak IBOutlet UIImageView *stationImg;
    
    __weak IBOutlet NSLayoutConstraint *leftCon;
    
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UILabel *label0;
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UILabel *label2;

    __weak IBOutlet UILabel *desc0;
    __weak IBOutlet UILabel *desc1;
    __weak IBOutlet UILabel *desc2;
    
    __weak IBOutlet UIView *line0;
    __weak IBOutlet UIView *line1;
    __weak IBOutlet UIView *line2;
    IBOutlet UILabel *label3;
    
}
- (void)setData:(nonnull NSDictionary *)data andIsStation:(BOOL)isStation;

@end

NS_ASSUME_NONNULL_END
