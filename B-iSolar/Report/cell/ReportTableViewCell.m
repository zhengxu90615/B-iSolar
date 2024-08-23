//
//  ReportTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/24.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportTableViewCell.h"

@implementation ReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    bgView.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
//    bgView.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
//    bgView.layer.shadowOffset = CGSizeMake(0,0);
//    // 设置阴影透明度
//    bgView.layer.shadowOpacity = 1;
//    // 设置阴影半径
//    bgView.layer.shadowRadius = 2;
    bgView.clipsToBounds = NO;
    
    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    label0.font = label1.font = label2.font = label3.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    desc0.font = desc1.font = desc2.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    line0.backgroundColor = line1.backgroundColor = line2.backgroundColor = COLOR_TABLE_SEP;
    
    stationImg.image = [stationImg.image imageChangeColor:MAIN_TINIT_COLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(nonnull NSDictionary *)data andIsStation:(BOOL)isStation{
    if (isStation) {
        bgView.backgroundColor = [UIColor whiteColor];
        leftCon.constant = 5;
        stationImg.hidden = NO;
        titleLabel.textColor = label0.textColor = label1.textColor = label2.textColor = label3.textColor = COLOR_TABLE_TITLE;
        desc0.textColor = desc1.textColor = desc2.textColor = COLOR_TABLE_DES;
        
        titleLabel.text = [NSString stringWithFormat:@"%@ | %@MW",data[@"name"],data[@"capacity"]];
        label0.text = TOSTRING(data[@"hours"]);
        label1.text = TOSTRING(data[@"ongridEnergy"]);
        label2.text = [NSString stringWithFormat:@"%@",data[@"weather"]];
        label3.text = @"";

        desc0.text = String(@"等效小时数(h)");
        desc1.text = String(@"上网电量(万kWh)");
        desc2.text = String(@"天气");

    }else{
        NSString *noConfirmColor = [NSString stringWithFormat:@"%@",data[@"noConfirmColor"]] ;
       
        UIColor *color = [UIColor colorWithHexString:noConfirmColor];
        
        bgView.backgroundColor = color;
        stationImg.hidden = YES;
        leftCon.constant = -20;
        titleLabel.textColor = label0.textColor = label1.textColor = label2.textColor =
        desc0.textColor = desc1.textColor = desc2.textColor = label3.textColor = [UIColor whiteColor];
        
        titleLabel.text = [NSString stringWithFormat:@"%@",data[@"name"]];

        label0.text = TOSTRING(data[@"capacity"]);
        label1.text = TOSTRING(data[@"hours"]);
        label2.text = TOSTRING(data[@"ongridEnergy"]);
        label3.text = TOSTRING(data[@"damage"]);
        
        desc0.text = String(@"总装机容量(MW)");
        desc1.text = String(@"等效小时数(h)");
        desc2.text = String(@"上网电量(万kWh)");
    }
}


@end
