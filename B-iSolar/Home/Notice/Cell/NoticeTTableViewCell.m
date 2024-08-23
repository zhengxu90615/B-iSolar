//
//  NoticeTTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/18.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "NoticeTTableViewCell.h"

@implementation NoticeTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Initialization code
}

- (void)setTagName:(NSString *)tagName{
    tagNameLabel.text = tagName;
    tagNameLabel.hidden = tagBgImg.hidden = NO;
}
- (void)setName:(NSString*)name detail:(NSString*)detail{
    tagNameLabel.hidden = tagBgImg.hidden = YES;

    nameLabel.text = name;
    detailLabel.text = detail?TOSTRING(detail):@"";
    
}
- (void)setName2:(NSString*)name detail:(NSString*)detail{
    tagNameLabel.hidden = tagBgImg.hidden = YES;

    nameLabel.text = name;
    detailLabel.text = detail?TOSTRING(detail):@"";
    
    nameLabel.font =  [UIFont systemFontOfSize:15];
    detailLabel.font =  [UIFont systemFontOfSize:12];
    nameLabel.textColor = COLOR_TABLE_TITLE;
    detailLabel.textColor = COLOR_TABLE_DES;

    topCons.constant = 8;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
