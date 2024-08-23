//
//  MissionDetalCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/24.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "MissionDetalCell.h"

@implementation MissionDetalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
