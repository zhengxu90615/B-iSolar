//
//  HomeTableChartsCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"
#import "MKSegmentControl.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^ChartCellBlock)(NSInteger type, NSString *data);



@interface WorkCell1 : UITableViewCell<MKSegmentControlDelegate>
{
    BResponseModel *dataModel;
    NSInteger currentIndex;
    IBOutlet UILabel *deLabel;
    IBOutlet UILabel *elecLabel;
    IBOutlet UILabel *titleLabel;
}
@property (strong, nonatomic) IBOutlet MKSegmentControl *segComtrol;

@property (nonatomic, strong) PYEchartsView *kEchartView;
@property (copy, nonatomic) ChartCellBlock clickBlock;
- (void)reloadV;
- (void)setData:(BResponseModel*)model andType:(int)type;

@end

NS_ASSUME_NONNULL_END
