//
//  MonitorThreeTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MonitorThreeTableViewCell.h"

@implementation MonitorThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    segment.delegate = self;
    [segment setSegFrame:CGRectMake(10, 0, MAINSCREENWIDTH-40, 44)];
    [segment setSegTitles:@[@"发电量曲线", @"报警设备类型分析"]];
    
    self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(30 , 44  , MAINSCREENWIDTH-60, 265-44-20)];
    [self.contentView addSubview:self.kEchartView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data{
    index = 0;
    myDic = [data copy];
    [segment setSelectedIndex:0];
    [self drawCharts];
}

- (void)drawCharts{
    PYOption *option =  index==0?[self stackedAreaOption]:[self doughnutPieOption];
    if (option != nil) {
       [_kEchartView setOption:option];
    }
    [_kEchartView loadEcharts];
}

- (void)segmentControl:(MKSliderSegmentView *)segment didSelectedIndex:(NSInteger)ind{
    index = ind;
    [self drawCharts];
}


- (PYOption *)stackedAreaOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option
        .titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"").subtextEqual(@"万Kwh")
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
            .addDataArr(myDic[@"ListOnX"])
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
            .dataEqual(myDic[@"ListOnY"]);
        }])
        ;
    }];
}



/**  标准环形饼图 */
- (PYOption *)doughnutPieOption{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
            option
//        .titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
//                title.textEqual(@"某站点访问来源")
//                .subtextEqual(@"纯属虚构")
//                .xEqual(PYPositionCenter);
//            }])
            .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
                tooltip.triggerEqual(PYTooltipTriggerItem)
                .formatterEqual(@"{a} <br/>{b} : {c} ({d}%)");
            }])

//            .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
//                toolbox.showEqual(YES)
//                .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
//                    feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
//                        mark.showEqual(YES);
//                    }])
//                    .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
//                        dataView.showEqual(YES).readOnlyEqual(NO);
//                    }])
//                    .magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
//                        magicType.showEqual(YES).typeEqual(@[PYSeriesTypePie, PYSeriesTypeFunnel]).optionEqual(@{@"funnel":@{@"x":@"25%",@"width":@"50%",@"funnelAlign":PYPositionLeft,@"max":@(1548)}});
//
//                    }])
//                    .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
//                        restore.showEqual(YES);
//                    }])
//                    ;
//                }]);
//            }])
            .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
    //            series.radiusEqual(@"55%")
                series.radiusEqual(@[@"50%",@"80%"])

                .centerEqual(@[@"50%",@"50%"])
                .nameEqual(@"设备类型")
                .typeEqual(PYSeriesTypePie)
                .dataEqual(myDic[@"dev_alarm_list"]);
            }]);
        }];

}



@end
