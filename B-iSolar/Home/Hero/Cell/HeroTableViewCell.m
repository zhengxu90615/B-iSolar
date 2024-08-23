//
//  HeroTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "HeroTableViewCell.h"

@implementation HeroTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data andIndex:(int)d{
    if (!data) {
        label0.text = @"排名";
        label0.font = [UIFont systemFontOfSize:12];
        label0.textColor = COLOR_TABLE_DES;
        
        label1.text = @"项目公司";
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = COLOR_TABLE_DES;
        
        label2.text = @"发电量";
        label2.font = [UIFont systemFontOfSize:12];
        label2.textColor = COLOR_TABLE_DES;
    }else{
        label0.text = TOINTSTRING(d);
        label0.font = [UIFont systemFontOfSize:13];
        label0.textColor = UIColorFromHex(0xF97E2C);
        
        label1.text = data[@"name"];
        label1.font = [UIFont systemFontOfSize:13];
        label1.textColor = COLOR_TABLE_TITLE;
        
        label2.text = [NSString stringWithFormat:@"%.1f%@",[data[@"value"] floatValue],data[@"unit"]];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = COLOR_TABLE_TITLE;
    }
}

@end
