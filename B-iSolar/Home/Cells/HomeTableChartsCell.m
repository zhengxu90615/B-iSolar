//
//  HomeTableChartsCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "HomeTableChartsCell.h"
#import "iOS-Echarts.h"

@implementation HomeTableChartsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(10, 84, MAINSCREENWIDTH-20, 218)];
    [self addSubview:_kEchartView];
    _kEchartView.backgroundColor = [UIColor clearColor];
    // Initialization code
    currentIndex = 0;
    
    [self.segComtrol setTitleColor:UIColorFromHex(0x909399)];
    [self.segComtrol setTinitColor:MAIN_TINIT_COLOR];
    [self.segComtrol setTitleSelectColor:[UIColor whiteColor]];
    [self.segComtrol setTitles:@[@"日",@"月",@"年",@"总"]];
    self.segComtrol.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 100, 12)];
    label.text = @"W KWH";
    label.textColor = UIColorFromRGB0xFFFFFF(0x909399);
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    
 
}

- (void)segmentControl:(MKSegmentControl *)segment didSelectedIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            deLabel.text = String(@"日发电量（万Kwh）");
            elecLabel.text = TOSTRING(dataModel.data[@"today_ongrid_energy"]);
        }
            break;
        case 1:
        {
            deLabel.text = String(@"月发电量（万Kwh）");
            elecLabel.text = TOSTRING(dataModel.data[@"month_ongrid_energy"]);
        }
            break;
        case 2:
        {
            deLabel.text = String(@"年发电量（万Kwh）");
            elecLabel.text = TOSTRING(dataModel.data[@"year_ongrid_energy"]);
        }
            break;
        case 3:
        {
            deLabel.text = String(@"总发电量（万Kwh）");
            elecLabel.text = TOSTRING(dataModel.data[@"total_ongrid_energy"]);
        }
            break;
        default:
            break;
    }
    
    if (index<3) {
        currentIndex = index;
        [self drawPic];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEG_CHANGED object:@(index)];
}
- (void)reloadV{
    [self.segComtrol setSelectedIndex:0];
    [self segmentControl:self.segComtrol didSelectedIndex:0];
}
- (void)setData:(BResponseModel*)model{
    dataModel = model;
    elecLabel.text = TOSTRING(dataModel.data[@"today_ongrid_energy"]);
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
            title.textEqual(@"日发电量柱状图");
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
            series.nameEqual(@"发电量")
            .typeEqual(PYSeriesTypeBar)
            .addDataArr(newYArr)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.color = @"#019AD8";
                    itemStyleProp.barBorderRadius = @[@5, @5, @0, @0];    ////（顺时针左上，右上，右下，左下）
                }]);
            }])
//            .markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *line) {
//                line
//                .addData(@{@"type":@"min", @"name":@"最小值"});
//
//            }])
            
//            .markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
//                point
//                .addData(@{@"type":@"max", @"name":@"最大值"})
//                .addData(@{@"type":@"min", @"name":@"最小值"});
//            }])

            ;
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
    switch (currentIndex) {
        case 0:
        {
            xArr =dataModel.data[@"listX"];
            yArr =dataModel.data[@"listY"];
        }
            break;
        case 1:
        {
            xArr =dataModel.data[@"listX_month"];
            yArr =dataModel.data[@"listY_month"];
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
    

    PYOption *option = [self basicColumnOption:xArr andYArr:yArr];

    if (option != nil) {
       [_kEchartView setOption:option];
   }
   [_kEchartView loadEcharts];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ChartViewDelegate
//
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//
//
//    if ([AppDelegate App].lastSelect[@"s"] == [NSString stringWithFormat:@"%f",entry.x]) {
//        if ([[NSDate date] timeIntervalSince1970] - [[AppDelegate App].lastSelect[@"t"] intValue]  > 1){
//
//            [AppDelegate App].lastSelect[@"t"] = @([[NSDate date] timeIntervalSince1970]);
//
//        }else{
////            if (currentIndex == 0) {
////                    if (self.clickBlock)
////                    {
////                        NSMutableArray *arr = [NSMutableArray array];
////                        for (int i =0 ; i<[dataModel.data[@"listX"] count]; i++) {
////                            [arr addObject:[NSString stringWithFormat:@"%d",[dataModel.data[@"listX"][i] intValue]]];
////                        }
////                        NSInteger index = [arr indexOfObject:[NSString stringWithFormat:@"%d",(int)entry.x+1]];
////
////                        if (index == [dataModel.data[@"listX"] count] - 1) { //当日
////                            self.clickBlock(0, [NSString stringWithFormat:@"%f",entry.x]);
////                        }else
////                        {
////                            self.clickBlock(1, dataModel.data[@"listX_day"][index]);
////                        }
////                    }
////                }else{
////            //        [self.superview makeToast:[NSString stringWithFormat:@"%.2f万kw/h",entry.y]];
////                }
//        }
//    }else{
//        [AppDelegate App].lastSelect[@"s"] =[NSString stringWithFormat:@"%f",entry.x];
//        [AppDelegate App].lastSelect[@"t"] = @([[NSDate date] timeIntervalSince1970]);
//    }
////    [BHttpRequest hideToast];
////    [self.superview hideToasts];
//
//    NSLog(@"chartValueSelected");
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    NSLog(@"chartValueNothingSelected");
//    NSTimeInterval now =[[NSDate date] timeIntervalSince1970];
//
//    if (now - [[AppDelegate App].lastSelect[@"t"] doubleValue]  >0.5){
//            [AppDelegate App].lastSelect[@"t"] = @([[NSDate date] timeIntervalSince1970]);
//        }else{
//            if (currentIndex == 0) {
//                    if (self.clickBlock)
//                    {
//                        NSMutableArray *arr = [NSMutableArray array];
//                        for (int i =0 ; i<[dataModel.data[@"listX"] count]; i++) {
//                            [arr addObject:[NSString stringWithFormat:@"%d",[dataModel.data[@"listX"][i] intValue]]];
//                        }
//                        int lastSelect = [[AppDelegate App].lastSelect[@"s"] intValue];
//
//                        if (lastSelect == [dataModel.data[@"listX"] count] - 1) { //当日
//                            self.clickBlock(0, [AppDelegate App].lastSelect[@"s"]);
//                        }else
//                        {
//                            self.clickBlock(1, dataModel.data[@"listX_day"][lastSelect]);
//                        }
//                    }
//                }else{
//            //        [self.superview makeToast:[NSString stringWithFormat:@"%.2f万kw/h",entry.y]];
//                }
//        }
//
//
//}

@end
