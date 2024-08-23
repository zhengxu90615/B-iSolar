//
//  MonitorDetailTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/15.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "MonitorDetailTableViewCell.h"

@implementation MonitorDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    label0.textColor = label1.textColor = label2.textColor = label3.textColor = label4.textColor = label5.textColor = COLOR_TABLE_TITLE;
    label0.font = label1.font = label2.font = label3.font = label4.font = label5.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    desc0.textColor = desc1.textColor = desc2.textColor = desc3.textColor = desc4.textColor = desc5.textColor = COLOR_TABLE_DES;
    desc0.font = desc1.font = desc2.font = desc3.font = desc4.font = desc5.font  = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    
    line0.backgroundColor = line1.backgroundColor = line2.backgroundColor = COLOR_TABLE_SEP;
    
    btn0.tag = 0;
    btn1.tag = 1;
    btn2.tag = 2;
    btn3.tag = 3;
    btn4.tag = 4;
    btn5.tag = 5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    if ([data.allKeys containsObject:@"ACP"]) {
        label0.text = TOFLOATSTRING(data[@"DCU"]);
        label1.text = TOFLOATSTRING(data[@"DCI"]);
        label2.text = TOFLOATSTRING(data[@"DCP"]);
        label3.text = TOFLOATSTRING(data[@"ACP"]);
        label4.text = TOFLOATSTRING(data[@"DGC"]);
        label5.text = TOSTRING(data[@"running_status"]);
        

        desc0.text = String(@"直流电压(V)");
        desc1.text = String(@"直流电流(A)");
        desc2.text = String(@"直流功率(KW)");
        desc3.text = String(@"交流功率(KW)");
        desc4.text = String(@"日发电量(kWh)");
        desc5.text = String(@"逆变器状态");
        
        btn0.backgroundColor = btn1.backgroundColor = btn2.backgroundColor = btn3.backgroundColor = btn4.backgroundColor = btn5.backgroundColor = [UIColor clearColor];
        
        label4.textColor = COLOR_TABLE_TITLE;
        desc4.textColor = COLOR_TABLE_DES;
        label0.textColor = label1.textColor = label2.textColor = label3.textColor = label4.textColor = label5.textColor = COLOR_TABLE_TITLE;
        desc0.textColor = desc1.textColor = desc2.textColor = desc3.textColor = desc4.textColor = desc5.textColor = COLOR_TABLE_DES;
        
        if ([label5.text isEqualToString:@"运行（正常）"]) {
            self.backgroundColor = UIColorFromHex(0xffffff);
            
        }else if ([label5.text isEqualToString:@"运行（偏低）"]) {
            self.backgroundColor = UIColorFromHex(0x64bed8);

        }else if ([label5.text isEqualToString:@"告警"]) {
            self.backgroundColor = UIColorFromHex(0xf4b04f);

        }else if ([label5.text isEqualToString:@"停机"]) {
            self.backgroundColor = UIColorFromHex(0x000000);

            label0.textColor = label1.textColor = label2.textColor = label3.textColor = label4.textColor = label5.textColor =  [UIColor whiteColor];
            desc0.textColor = desc1.textColor = desc2.textColor = desc3.textColor = desc4.textColor = desc5.textColor =  UIColorFromHex(0xeeeeee);
            
        }else if ([label5.text isEqualToString:@"中断"]) {
            self.backgroundColor = UIColorFromHex(0xb0b0b0);

        }
    }else{
        label0.text = TOSTRING(data[@"allCount"]);
        label1.text = TOSTRING(data[@"normalCount"]);
        label2.text = TOSTRING(data[@"lowerNormalCount"]);
        label3.text = TOSTRING(data[@"alarmCount"]);
        label4.text = TOSTRING(data[@"downtimeCount"]);
        label5.text = TOSTRING(data[@"breakCount"]);
        
        desc0.text = String(@"总装机(台)");
        desc1.text = String(@"正常(台)");
        desc2.text = String(@"偏低(台)");
        desc3.text = String(@"告警(台)");
        desc4.text = String(@"停机(台)");
        desc5.text = String(@"中断(台)");
        
        btn0.backgroundColor = btn1.backgroundColor = UIColorFromHex(0xffffff);
        btn2.backgroundColor = UIColorFromHex(0x64bed8);
        btn3.backgroundColor = UIColorFromHex(0xf4b04f);
        btn4.backgroundColor = UIColorFromHex(0x000000);
        btn5.backgroundColor = UIColorFromHex(0xb0b0b0);
        
        label4.textColor = [UIColor whiteColor];
        desc4.textColor = UIColorFromHex(0xeeeeee);
    }
}

- (IBAction)btn0Click:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}
@end
