//
//  CheckModelTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/1.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckModelTableViewCell.h"

@implementation CheckModelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    bgView.backgroundColor = WHITE_COLOR;
    
    ruleLabel.font  = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    decLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    
    ruleLabel.textColor  = COLOR_TABLE_TITLE;
    decLabel.textColor = COLOR_TABLE_TITLE;
    
    nameLabel.font  = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    ruleNameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    nameLabel.textColor = COLOR_TABLE_DES;
    ruleNameLabel.textColor = COLOR_TABLE_DES;
    
    selectLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    selectLabel.textColor = COLOR_TABLE_DES;
    
    
    line0.backgroundColor = line1.backgroundColor = line2.backgroundColor = COLOR_TABLE_SEP;

}
- (IBAction)bgClick{
    myBlock(nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)segChanged:(UISegmentedControl *)sender {
    myBlock(@(segmentCrl.selectedSegmentIndex));
}

- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block{
    myBlock = block;
    
    decLabel.text = dic[@"name"];
    
    ruleLabel.text = dic[@"rules"];

    if ( [TOSTRING(dic[@"value"]) isEqualToString:@"1"]) {
        segmentCrl.selectedSegmentIndex = 1;
    }else{
        segmentCrl.selectedSegmentIndex = 0;
    }
    
    
}
@end
