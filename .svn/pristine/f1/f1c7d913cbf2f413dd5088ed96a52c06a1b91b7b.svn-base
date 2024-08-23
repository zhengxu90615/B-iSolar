//
//  MonitorOTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/10.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^LeftButtonClick)();

@interface MonitorOTableViewCell : UITableViewCell
{
    __weak IBOutlet UIView *bgView;
    
    __weak IBOutlet UIImageView *stationImg;
    
    __weak IBOutlet NSLayoutConstraint *leftCon;
    
    __weak IBOutlet UILabel *titleLabel;
    
    IBOutlet UIView *line0;
    
    IBOutlet SPButton *alarmBtn;
    IBOutlet SPButton *workBtn;
    
    
    
    IBOutlet UIImageView *imgV;
    IBOutlet UILabel *riFaLabel;
    IBOutlet UILabel *leftLabel0;
    IBOutlet UILabel *leftLabel1;
    
    IBOutlet UILabel *dgcDescLabel;
    IBOutlet UILabel *mwDescLabel;
    UIButton *btn;
    
    
}
- (void)setData:(NSDictionary *)data andShowNum:(NSString *)numberString andShowBtn:(BOOL)isShow andSort:(NSInteger)sort;
@property (copy, nonatomic) LeftButtonClick leftClickBlock;
- (void)hideBtn:(BOOL)isShow;

- (void)setBtn:(NSInteger)sort;

@end

NS_ASSUME_NONNULL_END
