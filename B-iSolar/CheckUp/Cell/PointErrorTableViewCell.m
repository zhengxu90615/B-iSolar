//
//  PointErrorTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "PointErrorTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PointErrorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    nameLabel.textColor = COLOR_TABLE_TITLE;
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    decLabel.textColor = COLOR_TABLE_DES;
    decLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    // Initialization code
    imgV.layer.borderWidth = .5f;
    imgV.layer.borderColor = COLOR_TABLE_SEP.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary*)dic{
    [imgV sd_setImageWithURL:[NSURL URLWithString:API_FILE_URL(dic[@"path"])] placeholderImage:[UIImage imageNamed:@""]];
    nameLabel.text = dic[@"device_name"];
    decLabel.text = dic[@"rule"];
}
@end
