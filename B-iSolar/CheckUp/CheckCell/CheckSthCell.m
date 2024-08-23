//
//  CheckSthCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/11.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "CheckSthCell.h"

@implementation CheckSthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    // Initialization code
    label.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    label.textColor = COLOR_TABLE_TITLE;
    self.backgroundColor = [UIColor clearColor];
    bgV.backgroundColor = MAIN_BACKGROUND_COLOR;
    seg.tintColor = MAIN_TINIT_COLOR;
    seg.backgroundColor = COLOR_TABLE_SEP;
    if (@available(iOS 13.0, *)) {
        seg.selectedSegmentTintColor = MAIN_TINIT_COLOR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setData:(NSDictionary *)dic  canEdit:(BOOL)canEdit andBlock:(NormalBlock)block
{
    myBlock = block;
    seg.enabled = canEdit;
    seg.selectedSegmentIndex = [dic[@"value"] isEqualToString:@"是"]?1:0;
    label.text = dic[@"name"];
}

- (IBAction)segChanged:(id)sender {
    if(seg.selectedSegmentIndex == 0)
    {
        myBlock(@"否");
    }else{
        myBlock(@"是");
    }
}
@end
