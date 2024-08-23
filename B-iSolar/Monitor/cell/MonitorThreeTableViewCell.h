//
//  MonitorThreeTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSliderSegmentView.h"
#import "iOS-Echarts.h"
NS_ASSUME_NONNULL_BEGIN

@interface MonitorThreeTableViewCell : UITableViewCell<MKSliderSegmentControlDelegate>
{
    IBOutlet MKSliderSegmentView *segment;
    NSInteger index;
    NSMutableDictionary *myDic;
}

@property (nonatomic, strong) PYEchartsView *kEchartView;

- (void)setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
