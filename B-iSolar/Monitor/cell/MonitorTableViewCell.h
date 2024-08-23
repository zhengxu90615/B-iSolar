//
//  MonitorTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/8.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^LeftButtonClick)();
typedef void (^RightButtonClick)();

@interface MonitorTableViewCell : UITableViewCell
{
    __weak IBOutlet UIView *bgView;
              
       __weak IBOutlet UILabel *titleLabel;
       
       IBOutlet UIView *line0;
       
       IBOutlet SPButton *alarmBtn;
       
    IBOutlet UILabel *fushe;
    IBOutlet UILabel *fusheDesc;
    
    IBOutlet UILabel *gonglv;
    IBOutlet UILabel *gonglvDesc;
    IBOutlet UILabel *tem;
    
       
       IBOutlet UIImageView *imgV;
       IBOutlet UILabel *riFaLabel;
    IBOutlet UILabel *rifaDesc;
    
    IBOutlet UILabel *leftLabel0;
    
       IBOutlet UILabel *leftLabel1;
    IBOutlet UILabel *label1Desc;
    
    UIButton *xBtn;
    
}
@property (copy, nonatomic) LeftButtonClick leftClickBlock;
@property (copy, nonatomic) RightButtonClick rightClickBlock;

- (void)setData:(NSDictionary *)data;


@end

NS_ASSUME_NONNULL_END
