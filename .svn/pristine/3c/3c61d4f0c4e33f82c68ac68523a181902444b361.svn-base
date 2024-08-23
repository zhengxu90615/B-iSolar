//
//  AssetSTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/2.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AssetSTableViewCell.h"

@implementation AssetSTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    bgV.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
    bgV.layer.shadowColor =MAIN_TINIT_COLOR.CGColor;
    bgV.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    bgV.layer.shadowOpacity = 2;
    // 设置阴影半径
    bgV.layer.shadowRadius = 2;
    bgV.clipsToBounds = NO;

    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    titleLabel.textColor = COLOR_TABLE_TITLE;
    bgV.backgroundColor = [UIColor whiteColor];
    stationImg.image = [stationImg.image imageChangeColor:MAIN_TINIT_COLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTitle:(NSString *)titles
{
    titleLabel.text = titles;
}


@end
