//
//  MonitorOneTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MonitorOneTableViewCell.h"

@implementation MonitorOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    bgV.layer.masksToBounds = YES;
    bgV.layer.cornerRadius = LAYER_CORNERRADIUS;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    label0.text = TOFLOATSTRING(data[@"on_all"]);
    label1.text = TOFLOATSTRING(data[@"hour_all"]);
    label2.text = TOSTRING(data[@"alarmNum"]);

}

@end
