//
//  AssestOTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/2.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AssestOTableViewCell.h"

@implementation AssestOTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    bgV.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
      
    bgV.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
    bgV.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    bgV.layer.shadowOpacity = 1;
    // 设置阴影半径
    bgV.layer.shadowRadius = 1;
    bgV.clipsToBounds = NO;

    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    titleLabel.textColor = [UIColor whiteColor];
    bgV.backgroundColor = MAIN_TINIT_COLOR;
    stationImg.image = [stationImg.image imageChangeColor:[UIColor whiteColor]];
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
