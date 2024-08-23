//
//  ReportDetailTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/25.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportDetailTableViewCell.h"

@implementation ReportDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    line0.backgroundColor = line1.backgroundColor = line2.backgroundColor = COLOR_TABLE_SEP;
    line0.hidden =line2.hidden = YES;
    L0.textColor = L1.textColor = COLOR_TABLE_TITLE;
    D0.textColor = D1.textColor = COLOR_TABLE_DES;
    
    L0.font = L1.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    D0.font = D1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;

}
- (void)setData:(nonnull NSDictionary *)data andIndex:(NSInteger)index{
    if (index == 0) {
        L0.text = TOFLOATSTRING(data[@"ongridEnergy"]);
        L1.text = TOFLOATSTRING(data[@"monthlyOngridEnergy"]);
        D0.text = String(@"日上网电量(万kWh)");
        D1.text = String(@"月上网电量(万kWh)");
        
    }else{
//        line2.hidden = NO;
        L0.text = TOFLOATSTRING(data[@"yearlyOngridEnergy"]);
        L1.text = TOFLOATSTRING(data[@"planningAmount"]);
        D0.text = String(@"年上网电量(万kWh)");
        D1.text = String(@"计划电量(万kWh)");
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
