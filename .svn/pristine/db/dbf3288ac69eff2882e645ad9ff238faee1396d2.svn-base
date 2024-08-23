//
//  ReportDetailCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/1.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportDetailCell.h"

@implementation ReportDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    line0.backgroundColor = line1.backgroundColor = line2.backgroundColor= line3.backgroundColor = COLOR_TABLE_SEP;
    
    label0.textColor = label1.textColor= label2.textColor= label3.textColor= label4.textColor = COLOR_TABLE_TITLE;
    label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(BResponseModel*)model andIndex:(NSIndexPath*)indexPath
{
    
    if (indexPath.row == 0) {
        label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE_BOLD;
        label0.text = String(@"电站名称");
        label1.text = String(@"计划电量");
        label2.text = String(@"上网电量");
        label3.text = String(@"发电小时");
        label4.text = String(@"完成率");

    }else{
        NSArray *orArr = model.data[@"list"];
        NSDictionary *orgaDic = orArr[indexPath.section];
        NSArray *list = orgaDic[@"list"];
        label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE;

        if (indexPath.row == list.count+1) {
            label0.text = String(@"合计/平均");
            label1.text = TOSTRING(orgaDic[@"amount"]);
            label2.text = TOSTRING(orgaDic[@"ongridEnergy"]);
            label3.text = TOSTRING(orgaDic[@"hours"]);
            label4.text = TOSTRING(orgaDic[@"rate"]);

        }else{
            NSDictionary *data =orArr[indexPath.section][@"list"][indexPath.row-1];
            label0.text = TOSTRING(data[@"name"]) ;
            label1.text = TOSTRING(data[@"amount"]);
            label2.text = TOSTRING(data[@"ongridEnergy"]);
            label3.text = TOSTRING(data[@"hours"]);
            label4.text = TOSTRING(data[@"rate"]);
        }
    }
}
- (void)setDataDetailV:(BResponseModel*)model andIndex:(NSIndexPath*)indexPath andType:(NSInteger)type{
    if (type == 2) {//年
        if (indexPath.row == 0) {
            label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE_BOLD;
            label0.text = String(@"日期");
            label1.text = String(@"计划电量");
            label2.text = String(@"上网电量");
            label3.text = String(@"完成率");
            label4.text = String(@"PR");
        }else{
            NSArray *orArr = model.data[@"dataList"];
            label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
            NSDictionary*data = orArr[indexPath.row-1];
            label0.text = TOSTRING(data[@"date"]) ;
            label1.text = TOSTRING(data[@"planningEnergy"]);
            label2.text = TOSTRING(data[@"ongridEnergy"]);
            label3.text = TOSTRING(data[@"rate"]);
            label4.text = TOSTRING(@"--");
        }
    }else{
        if (indexPath.row == 0) {
            label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE_BOLD;
            label0.text = String(@"日期");
            label1.text = String(@"日上网电量");
            label2.text = String(@"等效小时");
            label3.text = String(@"PR");
            label4.text = String(@"天气");
        }else{
            NSArray *orArr = model.data[@"dataList"];
            label0.font = label1.font= label2.font= label3.font= label4.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
            NSDictionary*data = orArr[indexPath.row-1];
            label0.text = TOSTRING(data[@"date"]) ;
            label1.text = TOSTRING(data[@"ongridEnergy"]);
            label2.text = TOSTRING(data[@"hours"]);
            label3.text = TOSTRING(@"--");
            label4.text = TOSTRING(data[@"weather"]);
        }
        
    }
    
    
}

@end
