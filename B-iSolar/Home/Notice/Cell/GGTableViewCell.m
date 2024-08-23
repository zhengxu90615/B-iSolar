//
//  GGTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "GGTableViewCell.h"

@implementation GGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    
    content.text = TOSTRING(data[@"content"]);
    title.text = TOSTRING(data[@"title"]);
    date.text = TOSTRING(data[@"releaseTime"]);

}
@end
