//
//  HomeComTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "HomeComTableViewCell.h"
#import "iOS-Echarts.h"

@implementation HomeComTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    _kEchartView.frame = CGRectMake(10, 84, MAINSCREENWIDTH-20, 218);
    // Initialization code
    currentIndex = 0;
    isYuce = 0;
    [button0 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button1 setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
    
    [self.segComtrol setTitleColor:UIColorFromHex(0x909399)];
    [self.segComtrol setTinitColor:MAIN_TINIT_COLOR];
    [self.segComtrol setTitleSelectColor:[UIColor whiteColor]];
    [self.segComtrol setTitles:@[@"月",@"年"]];
    self.segComtrol.delegate = self;
    
    inV.frame = CGRectMake(MAINSCREENWIDTH/2 - 49 - 52, 41, 49, 3);
    inV.layer.masksToBounds = YES;
    inV.layer.cornerRadius = 1.5f;
    inV.backgroundColor = MAIN_TINIT_COLOR;
    [_mkchartView setNeedsLayout];
    
    
//    _kEchartView = [PYEchartsView alloc] initWithFrame:<#(CGRect)#>
    
}


- (void)segmentControl:(MKSegmentControl *)segment didSelectedIndex:(NSInteger)index{
 
    currentIndex = index;
    [self drawPic];
}

- (void)drawPic{
    NSNumber *rate = @0;
    
    if (isYuce) {

        la1.hidden = la2.hidden = tongbiImg.hidden = huanbiImg.hidden = tongbiLabel.hidden = huanbiLabel.hidden = YES;
        
        NSDictionary *dic = dataModel.data[@"plan_month_rate"];

        rate = @([dic[@"value"] intValue]);
        
        huanbiImg.image = [UIImage imageNamed:@"icon_rise"];
        tongbiImg.image = [UIImage imageNamed:@"icon_drop"];
        
        
        tongbiLabel.text =@"";
        huanbiLabel.text =@"";

    }else{
        if (currentIndex == 0) {
            la1.hidden = la2.hidden = tongbiImg.hidden = huanbiImg.hidden = tongbiLabel.hidden = huanbiLabel.hidden = NO;
            
            NSDictionary *dic = dataModel.data[@"on_month_rate"];
            rate = @([dic[@"value"] intValue]);

            huanbiImg.image = [dic[@"hbfh"] intValue] == 1?[UIImage imageNamed:@"icon_drop"]:[UIImage imageNamed:@"icon_rise"];
            tongbiImg.image = [dic[@"tbfh"] intValue] == 1?[UIImage imageNamed:@"icon_drop"]:[UIImage imageNamed:@"icon_rise"];

            tongbiLabel.text = [NSString stringWithFormat:@"%@%%",dic[@"tb"] ];
            huanbiLabel.text = [NSString stringWithFormat:@"%@%%",dic[@"hb"] ];
        }else{
            la1.hidden = la2.hidden = tongbiImg.hidden = huanbiImg.hidden = tongbiLabel.hidden = huanbiLabel.hidden = NO;
            la2.hidden = huanbiImg.hidden = huanbiLabel.hidden = YES;

            NSDictionary *dic = dataModel.data[@"on_year_rate"];

            rate = @([dic[@"value"] intValue]);

           huanbiImg.image = [dic[@"hbfh"] intValue] == 1?[UIImage imageNamed:@"icon_drop"]:[UIImage imageNamed:@"icon_rise"];
           tongbiImg.image = [dic[@"tbfh"] intValue] == 1?[UIImage imageNamed:@"icon_drop"]:[UIImage imageNamed:@"icon_rise"];

           tongbiLabel.text = [NSString stringWithFormat:@"%@%%",dic[@"tb"] ];
           huanbiLabel.text = [NSString stringWithFormat:@"%@%%",dic[@"hb"] ];
        }
    }
    
    PYOption *option = [self basicColumnOption:rate andName:isYuce?@"月发电量预计完成率":(currentIndex==0?@"月发电量实际完成率":@"年发电量实际完成率")];
    
    [_mkchartView setTitle:isYuce?@"月发电量预计完成率":(currentIndex==0?@"月发电量实际完成率":@"年发电量实际完成率") andNum:rate];
    
     if (option != nil) {
        [_kEchartView setOption:option];
    }
    [_kEchartView loadEcharts];
//    _kEchartView.backgroundColor = [UIColor grayColor];
}



- (PYOption *)basicColumnOption:(NSNumber *)rate andName:(NSString *)name {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option
        
        .addSeries([PYGaugeSeries initPYGaugeSeriesWithBlock:^(PYGaugeSeries *series) {
            series
           .startAngleEqual(@210)
           .endAngleEqual(@-30)
            .radiusEqual(@120)//半径
            .splitNumberEqual(@10)//分几块
            
           .splitLineEqual([PYGaugeSplitLine initPYGaugeSplitLineWithBlock:^(PYGaugeSplitLine *splitLine) {
                
               splitLine
               .lengthEqual(@20)
               .lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.widthEqual(@2)
                    .colorEqual([PYColor colorWithHexString:@"#F97E2C"])
                    ;
                }]);
                    
            }])
            
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(false)
                .splitNumberEqual(@20)
                .lengthEqual(@121)
                .lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual(@"auto")
                    .widthEqual(@2)
                    .typeEqual(PYLineStyleTypeDashed);
                }]);
            }])
            
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {    //圈线
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.widthEqual(@10);
                    lineStyle.colorEqual(@[
                    @[@([rate floatValue]/100), [PYColor colorWithHexString:@"#019AD8"]],
                    @[@1, [PYColor colorWithHexString:@"cdeaf6"]]
                    ]);
                }]);
            }])

            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {   //刻度标识
                axisLabel
                
                .formatterEqual(@"(function(v){\n                    switch (v+\'\'){\n           case \'0\': return \'0\';\n                case \'20\': return \'20\';\n                        case \'40\': return \'40\';\n                        case \'60\': return \'60\';\n    case \'80\': return \'80\';\n  case \'100\': return \'100\';\n                      default: return \'\';\n                    }\n                })")
                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#606266"])
                    .fontSizeEqual(@12);
                }]);
            }])
            
            .pointerEqual([PYGaugePointer initPYGaugePointerWithBlock:^(PYGaugePointer *pointer) {  //中间指针
                pointer.widthEqual(@5)
                .lengthEqual(@"40%")
                .colorEqual([PYColor colorWithHexString:@"#F97E2C"]);
            }])
            
            .titleEqual([PYGaugeTitle initPYGaugeTitleWithBlock:^(PYGaugeTitle *title) {
                title.showEqual(YES)
                .offsetCenterEqual(@[@0, @"70%"])
                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual([PYColor colorWithHexString:@"#606266"])
                    .fontSizeEqual(@12);
                }]);
            }])
            
            .detailEqual([PYGaugeDetail initPYGaugeDetailWithBlock:^(PYGaugeDetail *detail) {
                detail.showEqual(YES)
//                .backgroundColorEqual([PYColor colorWithHexString:@"#000"])
                .borderWidthEqual(@0)
                .borderColorEqual([PYColor colorWithHexString:@"#303133"])
                .widthEqual(@75)
                
                .heightEqual(@40)
                .offsetCenterEqual(@[@0, @(40)])
                .formatterEqual(@"{value}%")
                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.fontSizeEqual(@20);
                    textStyle.fontWeightEqual(PYTextStyleFontWeightBolder);
                    textStyle.color = [PYColor colorWithHexString:@"##303133"];
                }]);
            }])
            .typeEqual(PYSeriesTypeGauge)
            .addData(@{@"value":rate, @"name":name});
           
        }]);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setData:(BResponseModel*)model{
    
    
    currentIndex = 0;
    
    [button0 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button1 setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
    
    dataModel = model;
    [self drawPic];
    
    [self buttonClick:button0];
    
//    gradientProgress2.center = CGPointMake(MAINSCREENWIDTH/2 - 1.4*44-10, 0.85*88);
//    gradientProgress.center = CGPointMake(MAINSCREENWIDTH/2 +  1.4*44+10, 0.85*88);
//
//    
//    [gradientProgress setProgress:[model.data[@"rate_float"] doubleValue]/100.0f andTitle:@"年计划电量完成率"];
//    [gradientProgress2 setProgress:[model.data[@"rate_month_float"] doubleValue]/100.0f andTitle:@"月计划电量完成率"];

}


- (IBAction)buttonClick:(UIButton *)sender {
    isYuce = (sender.tag == 1);
    self.segComtrol.hidden = isYuce;
    CGRect rect =  CGRectMake(MAINSCREENWIDTH/2 - 49 - 52, 41, 49, 3);

    if (sender.tag ==0) {
        [button0 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [button1 setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
    }else{
        rect =  CGRectMake(MAINSCREENWIDTH/2 + 50, 41, 49, 3);
        [button1 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [button0 setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:.3f animations:^{
        inV.frame = rect;
    }];
    [self drawPic];
}
@end
