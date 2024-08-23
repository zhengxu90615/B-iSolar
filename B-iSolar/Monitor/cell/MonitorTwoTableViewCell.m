//
//  MonitorTwoTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MonitorTwoTableViewCell.h"

@implementation MonitorTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    [segment setSegFrame:CGRectMake(10, 0, MAINSCREENWIDTH-40, 44)];
    [segment setSegTitles:@[@"发电量排名", @"小时数排名"]];
    segment.delegate = self;
    chartView = [[MKLineChartView alloc] initWithFrame:CGRectMake(30 , 44 + 10 , MAINSCREENWIDTH-60, 204.5-44-20)];
    [self.contentView addSubview:chartView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)segmentControl:(MKSliderSegmentView *)segment didSelectedIndex:(NSInteger)index{
    if (index==0) {
        [chartView setData:myDic[@"on_sort_list"] andColor:MAIN_TINIT_COLOR andUnit:@"万Kwh"];

//        [chartView setData:@[@{@"name":@"绍兴光年",@"value":@330.5},@{@"name":@"绍兴光年",@"value":@330.5},@{@"name":@"绍兴光年",@"value":@330.5},@{@"name":@"绍兴光年",@"value":@330.5},@{@"name":@"绍兴光年",@"value":@320.5}] andColor:MAIN_TINIT_COLOR andUnit:@"万Kwh"];
    }else{
        [chartView setData:myDic[@"hour_sort_list"] andColor:[UIColor colorWithHexString:@"#F58940"] andUnit:@"万Kwh"];

//         [chartView setData:@[@{@"name":@"绍兴光年",@"value":@100.5},@{@"name":@"绍兴光年",@"value":@200.5},@{@"name":@"绍兴光年",@"value":@130.5},@{@"name":@"绍兴光年",@"value":@40.5},@{@"name":@"绍兴光年",@"value":@50.5}] andColor:[UIColor colorWithHexString:@"#F58940"] andUnit:@"万Kwh"];
    }
}

- (void)setData:(NSDictionary *)data{
    [segment setSelectedIndex:0];
    
    myDic = [[NSMutableDictionary alloc] initWithDictionary:data];
//    [myDic setObject:@"" forKey:@"0"];
        [chartView setData:myDic[@"on_sort_list"] andColor:MAIN_TINIT_COLOR andUnit:@"万Kwh"];
    
//    [chartView setData:@[@{@"name":@"绍兴光年",@"value":@330.5},@{@"name":@"绍兴光年",@"value":@220.5},@{@"name":@"绍兴光年",@"value":@130.5},@{@"name":@"绍兴光年",@"value":@40.5},@{@"name":@"绍兴光年",@"value":@50.5}] andColor:MAIN_TINIT_COLOR andUnit:@"万Kwh"];
    
}

@end
