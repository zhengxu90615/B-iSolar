//
//  PointTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/21.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "PointTableViewCell.h"

@implementation PointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = COLOR_TABLE_TITLE;
    valueLabtl.textColor = COLOR_TABLE_DES;
    datelabel.textColor = COLOR_TABLE_DES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)dic
{
    nameLabel.text = dic[@"dataPointName"];
    valueLabtl.text = [NSString stringWithFormat:@"%@ %@",dic[@"value"],dic[@"unit"]];
    datelabel.text = dic[@"time"];

    
}


@end
