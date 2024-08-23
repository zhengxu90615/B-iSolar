//
//  MonitorTwoTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSliderSegmentView.h"
#import "MKLineChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonitorTwoTableViewCell : UITableViewCell<MKSliderSegmentControlDelegate>
{
    IBOutlet MKSliderSegmentView *segment;
    MKLineChartView *chartView;
    NSMutableDictionary *myDic;
}
- (void)setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
