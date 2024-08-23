//
//  HomeTableChartsCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "WorkCell1.h"
#import "iOS-Echarts.h"

@implementation WorkCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(10, 84-50, MAINSCREENWIDTH-20, 218)];
    [self addSubview:_kEchartView];
    _kEchartView.backgroundColor = [UIColor clearColor];
    // Initialization code
    currentIndex = 0;

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 100, 12)];
    label.text = @"个";
    label.textColor = UIColorFromRGB0xFFFFFF(0x909399);
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    
 
}



- (void)setData:(BResponseModel*)model andType:(int)type{
    dataModel = model;
    currentIndex = type;
    if (type == 0) {
        titleLabel.text = @"巡检报告（内部）";
    }else{
        titleLabel.text = @"巡检报告（外部）";
    }
    
    [self drawPic];
}


- (PYOption *)basicColumnOption:(NSArray*)xArr andYArr:(NSArray *)yArr {
    
    NSMutableArray *newYArr = [[NSMutableArray alloc] initWithArray:yArr];
    
    int maxIndex = 0;
    int minIndex = 0;
    for (int i =0; i<yArr.count; i++) {
        if ([yArr[i] floatValue] > [yArr[maxIndex] floatValue]){
            maxIndex = i;
        }
        if ([yArr[i] floatValue] < [yArr[minIndex] floatValue]){
            minIndex = i;
        }
    }
    NSNumber *left = @40;
    if ([yArr[maxIndex] floatValue] > 9999){
        left = @50;
    }
    newYArr[maxIndex] = @{@"value":yArr[maxIndex], @"itemStyle": @{@"normal": @{@"color": @"#F58236"}}};
    newYArr[minIndex] = @{@"value":yArr[minIndex], @"itemStyle": @{@"normal": @{@"color": @"#35C6A6"}}};
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option
        .titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) { //title
            title.textEqual(@"");
            PYTextStyle *sty = [[PYTextStyle alloc] init];
            sty.fontSize = @(12);
            sty.align = @"right";
            sty.color = @"#303133";
            title.textStyleEqual(sty);
            title.textAlign = @"right";
            title.x = @(MAINSCREENWIDTH-23);
            
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {            //边框
            grid.xEqual(left).x2Equal(@13).yEqual(@20).y2Equal(@30);      // 左右上下
            grid.borderColor = [PYColor colorWithHexString:@"#00000000"];
        }])
        
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {     //点击之后显示的浮框
            tooltip.triggerEqual(PYTooltipTriggerAxis);

            PYTextStyle *sty = [[PYTextStyle alloc] init];
            sty.fontSize = @(12);
            tooltip.textStyle = sty;

        }])
        
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {         // x轴
            axis.typeEqual(PYAxisTypeCategory)
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(false);
            }])
            .addDataArr(xArr).axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
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
                .showEqual(false);
            }])
            .axisLine.showEqual(false)
            ;
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {     // y轴
            axis
            .typeEqual(PYAxisTypeValue)
            .nameEqual(@"xxx").axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
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
        .addSeries([PYCartesianSeries initPYSeriesWithBlock:^(PYSeries *series) {
            series.nameEqual(@"巡检报告")
            .typeEqual(PYSeriesTypeBar)
            .addDataArr(newYArr)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.color = @"#019AD8";
                    itemStyleProp.barBorderRadius = @[@5, @5, @0, @0];    ////（顺时针左上，右上，右下，左下）
                }]);
            }]);
        }])
        ;
    }];
}


- (PYOption *)stackedAreaOption:(NSArray*)xArr andYArr:(NSArray *)yArr  {
    NSMutableArray *newYArr = [[NSMutableArray alloc] initWithArray:yArr];
    
    int maxIndex = 0;
    int minIndex = 0;
    for (int i =0; i<yArr.count; i++) {
        if ([yArr[i] floatValue] > [yArr[maxIndex] floatValue]){
            maxIndex = i;
        }
        if ([yArr[i] floatValue] < [yArr[minIndex] floatValue]){
            minIndex = i;
        }
    }
    NSNumber *left = @40;
    if ([yArr[maxIndex] floatValue] > 9999){
        left = @50;
    }
    newYArr[maxIndex] = @{@"value":yArr[maxIndex], @"itemStyle": @{@"normal": @{@"color": @"#F58236"}}};
    newYArr[minIndex] = @{@"value":yArr[minIndex], @"itemStyle": @{@"normal": @{@"color": @"#35C6A6"}}};
    
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
            .addDataArr(xArr)
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
        
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"实际")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.colorEqual([PYColor colorWithHexString:@"#F97E2C"])
                    .areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault)
                        // 径向渐变，前三个参数分别是圆心 x, y 和半径，取值同线性渐变
                        .colorEqual(@"(function (){var zrColor = zrender.tool.color;return zrColor.getLinearGradient(0, 0, 0, 280,[[0, 'rgba(249,126,44,0.35)'],[0.8, 'rgba(255,255,255,0)']])})()")
                        ;
                    }]);
                }]);
            }])
            .dataEqual(yArr);
        }])
        ;
    }];
}


- (void) drawPic{
    
    if (!dataModel) {
        return;
    }
    NSArray *xArr;
    NSArray *yArr;
    PYOption *option;
    switch (currentIndex) {
        case 0:
        {
            xArr =dataModel.data[@"in_x_axis"];
            yArr =dataModel.data[@"in_y_axis"];
            
            option = [self basicColumnOption:xArr andYArr:yArr];
        }
            break;
        case 1:
        {
            xArr =dataModel.data[@"out_listX"];
            yArr =dataModel.data[@"out_listY"];
            
            option = [self stackedAreaOption:xArr andYArr:yArr];
        }
            break;
        case 2:
        {
            xArr =dataModel.data[@"listX_year"];
            yArr =dataModel.data[@"listY_year"];
        }
            break;
        default:
            break;
    }
    


    if (option != nil) {
       [_kEchartView setOption:option];
   }
   [_kEchartView loadEcharts];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
