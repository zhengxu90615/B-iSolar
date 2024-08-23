//
//  ReportDetailChartsCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/26.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportDetailChartsCell.h"

@implementation ReportDetailChartsCell

@synthesize lineCharView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
     lineCharView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 88*3)];
    lineCharView.delegate = self;
    
    lineCharView.scaleYEnabled = NO;//取消Y轴缩放
    
    lineCharView.doubleTapToZoomEnabled = NO;//取消双击缩放
    
    lineCharView.dragEnabled = YES;//启用拖拽图标
    
    lineCharView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    
    lineCharView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    [self addSubview:lineCharView];
    
    ChartXAxis *xAxis = lineCharView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.axisMaxLabels = 5;
    //    xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    
    //    leftAxisFormatter.negativeSuffix = @" $";
    //    leftAxisFormatter.positiveSuffix = @" $";
    // Y轴（左y轴）
    ChartYAxis *leftAxis = lineCharView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 5;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    {
        ChartYAxis *leftAxis = lineCharView.rightAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 5;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.spaceTop = 0.15;
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    }
    
    ChartLegend *l = lineCharView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
   
    
    lineCharView.drawMarkers = YES;
//    ChartMarkerView * makerView = [[ChartMarkerView alloc]init];
//    makerView.offset = CGPointMake(-self.subPriceView.frame.size.width,-self.subPriceView.frame.size.height/2);
//    makerView.chartView = _lineChartView;_lineChartView.marker = makerView;
//    [makerView addSubview:self.subPriceView];
    
    
}
- (void)setData:(BResponseModel*)model{
    NSDictionary *dailyLoadCurve =model.data[@"dailyLoadCurve"];
    NSArray *xArr = dailyLoadCurve[@"xaisList"];
    NSArray *yArr = dailyLoadCurve[@"yaisReal"]; //yaisReal   yaisRadiation yaisBase
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < yArr.count; i++){
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
    }
    
    /*
     values : yVals数组
     label : 图例名字
     */
    NSMutableArray *setArr = [[NSMutableArray alloc] init];
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"实际功率"];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:COLOR_CHARTS_COLOR1];
    set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
    set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    set.drawIconsEnabled = NO;
    set.drawCircleHoleEnabled = NO;//是否画空心圆
    set.circleRadius = 0;//折线点的宽度
    
    [setArr addObject:set];
    
    {
        NSArray *yArr = dailyLoadCurve[@"yaisBase"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"基准功率"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR3];
        set.colors = colors;
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        
        [setArr addObject:set];
    }
    
    {
        NSArray *yArr = dailyLoadCurve[@"yaisRadiation"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"辐射强度"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR2];
        set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        set.axisDependency = AxisDependencyRight;
        [setArr addObject:set];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:setArr];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;//小数点形式
    numFormatter.maximumFractionDigits = 2; // 小数位最多位数
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [data setValueFormatter:formatter];// 更改柱状显示格式
    [data setValueFont:[UIFont systemFontOfSize:10]];// 更改柱状字体显示大小
    [data setValueTextColor:UIColorFromHex(0x515254)];// 更改柱状字体颜色
    
    ChartXAxis *xAxis = lineCharView.xAxis;
    xAxis.labelCount = xArr.count;//X轴文字描述的个数
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xArr];//X轴文字描述的内容
    lineCharView.data = data;
    
    
}

- (void)setData2:(BResponseModel*)model andType:(NSInteger)type
{
    NSDictionary *dailyLoadCurve =model.data[@"reportChart"];
    NSMutableArray *xArr = [[NSMutableArray alloc] init];
    for (id o in dailyLoadCurve[@"xaisList"]) {
        [xArr addObject:TOSTRING(o)];
    }
    
    NSArray *yArr = dailyLoadCurve[@"yaisObliqueExposure"]; //yaisReal   yaisRadiation yaisBase
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < yArr.count; i++){
        if (TOSTRING(yArr[i]).length > 0)
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
    }
    
    /*
     values : yVals数组
     label : 图例名字
     */
    NSMutableArray *setArr = [[NSMutableArray alloc] init];
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"辐射度"];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:COLOR_CHARTS_COLOR1];
    set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
    set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    set.drawIconsEnabled = NO;
    set.drawCircleHoleEnabled = NO;//是否画空心圆
    set.circleRadius = 0;//折线点的宽度
    
    [setArr addObject:set];
    
    {
        NSArray *yArr = dailyLoadCurve[@"yaisOngridEnergy"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            if (TOSTRING(yArr[i]).length > 0)
                [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"发电量"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR3];
        set.colors = colors;
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        set.axisDependency = AxisDependencyRight;
        [setArr addObject:set];
    }
//
    {
        NSArray *yArr = dailyLoadCurve[@"yaisPlanningEnergy"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            if (TOSTRING(yArr[i]).length > 0)
                [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"计划发电量"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR2];
        set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        set.axisDependency = AxisDependencyRight;
        [setArr addObject:set];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:setArr];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;//小数点形式
    numFormatter.maximumFractionDigits = 2; // 小数位最多位数
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [data setValueFormatter:formatter];// 更改柱状显示格式
    [data setValueFont:[UIFont systemFontOfSize:10]];// 更改柱状字体显示大小
    [data setValueTextColor:UIColorFromHex(0x515254)];// 更改柱状字体颜色
    
    ChartXAxis *xAxis = lineCharView.xAxis;
    xAxis.labelCount = xArr.count;//X轴文字描述的个数
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xArr];//X轴文字描述的内容
    lineCharView.data = data;
    
}



- (void)setData3:(BResponseModel*)model andType:(NSInteger)type
{
    NSDictionary *dailyLoadCurve =model.data[@"dailyLoadCurve"];
    NSMutableArray *xArr = [[NSMutableArray alloc] init];
    for (id o in dailyLoadCurve[@"xaisList"]) {
        [xArr addObject:TOSTRING(o)];
    }
    
    NSArray *yArr = dailyLoadCurve[@"yaisBase"]; //yaisReal   yaisRadiation yaisBase
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < yArr.count; i++){
        if (TOSTRING(yArr[i]).length > 0)
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
    }
    
    /*
     values : yVals数组
     label : 图例名字
     */
    NSMutableArray *setArr = [[NSMutableArray alloc] init];
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"基准功率"];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:COLOR_CHARTS_COLOR1];
    set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
    set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    set.drawIconsEnabled = NO;
    set.drawCircleHoleEnabled = NO;//是否画空心圆
    set.circleRadius = 0;//折线点的宽度
    
    [setArr addObject:set];
    
    {
        NSArray *yArr = dailyLoadCurve[@"yaisRadiation"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            if (TOSTRING(yArr[i]).length > 0)
                [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"辐射强度"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR3];
        set.colors = colors;
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        set.axisDependency = AxisDependencyRight;
        [setArr addObject:set];
    }
    //
    {
        NSArray *yArr = dailyLoadCurve[@"yaisReal"]; //yaisReal   yaisRadiation yaisBase
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yArr.count; i++){
            if (TOSTRING(yArr[i]).length > 0)
                [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[yArr[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:@"实际功率"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObject:COLOR_CHARTS_COLOR2];
        set.colors = colors;//统计图颜色,有几个颜色，图例就会显示几个标识
        set.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set.drawIconsEnabled = NO;
        set.drawCircleHoleEnabled = NO;//是否画空心圆
        set.circleRadius = 0;//折线点的宽度
        set.axisDependency = AxisDependencyRight;
        [setArr addObject:set];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:setArr];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;//小数点形式
    numFormatter.maximumFractionDigits = 2; // 小数位最多位数
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [data setValueFormatter:formatter];// 更改柱状显示格式
    [data setValueFont:[UIFont systemFontOfSize:10]];// 更改柱状字体显示大小
    [data setValueTextColor:UIColorFromHex(0x515254)];// 更改柱状字体颜色
    
    ChartXAxis *xAxis = lineCharView.xAxis;
    xAxis.labelCount = xArr.count;//X轴文字描述的个数
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xArr];//X轴文字描述的内容
    lineCharView.data = data;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
