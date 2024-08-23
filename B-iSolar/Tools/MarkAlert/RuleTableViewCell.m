//
//  RuleTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/1.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "RuleTableViewCell.h"

@implementation RuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
       
    sw.on = NO;
    [sw setOnTintColor:MAIN_TINIT_COLOR];
    // Initialization code
    nameLabel.textColor = COLOR_TABLE_TITLE;
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selected:(BOOL)selected;
 {
     imageV.image = selected?[UIImage imageNamed:@"selected"]:[UIImage imageNamed:@"unselected"];
}
- (void)hlightBg:(BOOL)selected
{
    self.backgroundColor =selected?COLOR_TABLE_SEP:[UIColor clearColor];

}
- (void)setData:(NSDictionary *)title andBlock:(NormalBlock)block{
    nameLabel.text = (![title[@"name"] isKindOfClass:[NSNull class]])?title[@"name"]: @"";
    myBlock = block;
}

@end
