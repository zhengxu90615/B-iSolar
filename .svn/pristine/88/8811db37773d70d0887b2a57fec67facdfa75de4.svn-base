//
//  ErrorTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "ErrorTableViewCell.h"

@implementation ErrorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
    detailLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    detailLabel.layer.borderWidth = .5f;
    detailLabel.layer.borderColor = COLOR_TABLE_SEP.CGColor;
    detailLabel.textColor = COLOR_TABLE_DES;

    detailLabel.textInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 0.f); // 设置左内边距


    nameLabel.textColor = COLOR_TABLE_TITLE;
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 88-50, MAINSCREENWIDTH-20, 40);
    [button setBackgroundColor:[UIColor clearColor]];
    [self addSubview:button];
    [button addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)bgClick{
    myBlock(nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block
{
    myBlock = block;
    if (self.tag == 0) {
        nameLabel.text = dic[@"label0"];
        detailLabel.text = dic[@"device_name"];
    }else if (self.tag == 1){
        nameLabel.text = dic[@"label1"];
        detailLabel.text = dic[@"rule_name"];
    }
}

@end
