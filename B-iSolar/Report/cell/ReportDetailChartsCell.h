//
//  ReportDetailChartsCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/26.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@import Charts;

@interface ReportDetailChartsCell : UITableViewCell
{
    LineChartView *lineCharView;
}
@property (nonatomic, strong) LineChartView *lineCharView;

- (void)setData:(BResponseModel*)model;
- (void)setData2:(BResponseModel*)model andType:(NSInteger)type;
- (void)setData3:(BResponseModel*)model andType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
