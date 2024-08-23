//
//  NoticeTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    notReadImgV.backgroundColor = COLOR_WARN;
    notReadImgV.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    bgView.layer.cornerRadius = LAYER_CORNERRADIUS;    // Initialization code
    
    // 设置阴影半径
    bgView.clipsToBounds = NO;
    
    bgView.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor =  COLOR_TABLE_TITLE;
    contentLabel.textColor = dateLabel.textColor = COLOR_TABLE_DES;
    line0.backgroundColor = COLOR_TABLE_SEP;
    
    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    contentLabel.font = dateLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 3;
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    titleLabel.text = (![data[@"title"] isKindOfClass:[NSNull class]])?data[@"title"]:@"通知";
    dateLabel.text = [NSString stringWithFormat:@"%@",(![data[@"releaseTime"] isKindOfClass:[NSNull class]])?data[@"releaseTime"]:data[@"createTime"]];
    contentLabel.text = (![data[@"content"] isKindOfClass:[NSNull class]])?data[@"title"]:@" ";

    notReadImgV.hidden = [TOSTRING(data[@"isRead"]) isEqualToString:@"1"];
    left.constant = 10 + (notReadImgV.hidden?0 : 12);
}

@end
