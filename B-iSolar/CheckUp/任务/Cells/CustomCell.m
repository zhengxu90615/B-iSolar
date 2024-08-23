//
//  MissDealCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    perLabbel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    nameLabel.textColor = COLOR_TABLE_DES;
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataAndName:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2{

    canEd = canEdit;
    nameLabel.text = dic[@"name"];
    perLabbel.text = dic[@"value"];
    perLabbel.textColor = COLOR_TABLE_TITLE;
    if ([@"" isEqualToString:dic[@"value"]]) {
        perLabbel.text = dic[@"placeholder"];
        perLabbel.textColor = COLOR_TABLE_DES;

    }
    
}



@end
