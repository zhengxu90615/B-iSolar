//
//  NoticeTyleTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "NoticeTyleTableViewCell.h"

@implementation NoticeTyleTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    imageV.image = [UIImage imageNamed:data[@"img"]];
    titleLabel.text = data[@"name"];
    dot.hidden = ([data[@"num"] intValue] == 0);
}

@end
