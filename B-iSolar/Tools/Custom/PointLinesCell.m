//
//  MonitorThreeTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "PointLinesCell.h"

@implementation PointLinesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(30 , 0  , MAINSCREENWIDTH-60, 265-20-44)];
    [self.contentView addSubview:self.kEchartView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data{
    index = 0;
    myDic = [data copy];
    [self drawCharts];
}

- (void)drawCharts{
    PYOption *option = [self stackedAreaOption];
    if (option != nil) {
       [_kEchartView setOption:option];
    }
    [_kEchartView loadEcharts];
}

- (PYOption *)stackedAreaOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option
        .titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"").subtextEqual(@"")
            .subtextStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual([PYColor colorWithHexString:@"#909399"])
                .fontSizeEqual(@12);
            }])
            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual([PYColor colorWithHexString:@"#909399"])
                .fontSizeEqual(@12);
            }]);           
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@30).x2Equal(@20).yEqual(@40).y2Equal(@30);      // 左右上下
            grid.borderColor = [PYColor colorWithHexString:@"#00000000"];

        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);

             PYTextStyle *sty = [[PYTextStyle alloc] init];
             sty.fontSize = @(12);
             tooltip.textStyle = sty;
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.xEqual(@(MAINSCREENWIDTH-180))
            .itemWidthEqual(@20)
//            .dataEqual(@[@"AI预测",@"实际"])
            ;
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(false);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#909399"])
                    .fontSizeEqual(@12);
                }])
                ;
            }])
            .addDataArr(myDic[@"x"])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *axisSpliteLine) {
                axisSpliteLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.typeEqual(PYLineStyleTypeDashed);
                }])
                .showEqual(false);
            }])
            .axisLine.showEqual(false)
            ;
            
//            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis
            .typeEqual(PYAxisTypeValue)
            .nameEqual(@"xxx")
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#909399"])
                    .fontSizeEqual(@12);
                }])
                
                ;
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *axisSpliteLine) {
                axisSpliteLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.typeEqual(PYLineStyleTypeDashed);
                }])
                .showEqual(true);
            }])
            .axisLine.showEqual(false)
            ;
        }])
//        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            series.smoothEqual(YES)
//            .nameEqual(@"AI预测")
//            .typeEqual(PYSeriesTypeLine)
//            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
//                    normal.colorEqual([PYColor colorWithHexString:@"#F97E2C"])
//                    .areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
//                        areaStyle.typeEqual(PYAreaStyleTypeDefault)
//                        .colorEqual(@"(function (){var zrColor = zrender.tool.color;return zrColor.getLinearGradient(0, 140, 0, 280,[[0, 'rgba(249,126,44,0.25)'],[0.8, 'rgba(255,255,255,0.25)']])})()")
//                        ;
//                        ;
//                    }]);
//                }]);
//            }])
//
//            .dataEqual(@[@(10),@(12),@(21),@(54),@(60),@(80),@(99)]);
//        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"实际")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.colorEqual([PYColor colorWithHexString:@"#019AD8"])
                    .areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault)
                        .colorEqual(@"(function (){var zrColor = zrender.tool.color;return zrColor.getLinearGradient(0, 140, 0, 280,[[0, 'rgba(1,154,216,0.25)'],[0.8, 'rgba(255,255,255,0.25)']])})()")
                        ;
                    }]);
                }]);
            }])
            .dataEqual(myDic[@"y"]);
        }])
        ;
    }];
}




@end
