//
//  CheckUpCompleteCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/16.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckUpCompleteCell.h"

@implementation CheckUpCompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    titleLabel0.font = titleLabel1.font =  FONTSIZE_TABLEVIEW_CELL_TITLE;
    titleLabel0.textColor = titleLabel1.textColor =  COLOR_TABLE_TITLE;

    view0.layer.cornerRadius = view1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    
    view0.layer.shadowColor = view1.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
    view0.layer.shadowOffset = view1.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    view0.layer.shadowOpacity = view1.layer.shadowOpacity = 1;
    // 设置阴影半径
    view0.layer.shadowRadius = view1.layer.shadowRadius = 1;
    view0.clipsToBounds = view1.clipsToBounds = NO;
    view0.backgroundColor = view1.backgroundColor = [UIColor whiteColor];
    
    progressL0.font = progressL1.font = desLabel0.font = desLabel1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    progressL0.textColor = progressL1.textColor = desLabel0.textColor = desLabel1.textColor =  COLOR_TABLE_DES;

    progressV0.tintColor = progressV1.tintColor = MAIN_TINIT_COLOR;
}

- (void)setData:(NSDictionary *)data
{
    NSString *f0 = data[@"month_rate"][@"rate"];
    progressV0.progress = [f0 floatValue]/100;
    progressL0.text = [NSString stringWithFormat:@"%@%%",f0];
    desLabel0.text = [NSString stringWithFormat:@"%@个未巡检完成",data[@"month_rate"][@"completion_num"]];
    
    f0 = data[@"history_rate"][@"rate"];
    progressV1.progress = [f0 floatValue]/100;
    progressL1.text = [NSString stringWithFormat:@"%@%%",f0];
    desLabel1.text = [NSString stringWithFormat:@"%@个未巡检完成",data[@"history_rate"][@"completion_num"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
