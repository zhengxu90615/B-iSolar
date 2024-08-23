//
//  HomeTableViewElecCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "HomeTableViewElecCell.h"

@implementation HomeTableViewElecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    desc.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    desc1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    desc2.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;

    treeLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    co2Label.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;

    elecLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    segmentControl.tintColor = MAIN_TINIT_COLOR;
    
    img1.image = [img1.image imageChangeColor:MAIN_TINIT_COLOR];
    img2.image = [img2.image imageChangeColor:MAIN_TINIT_COLOR];
    img3.image = [img3.image imageChangeColor:MAIN_TINIT_COLOR];

}
- (IBAction)segChanged:(id)sender {
    UIButton *btn = sender;

    if (myBlock) {
        myBlock(@(btn.tag));
    }
}

- (void)setData:(BResponseModel*)model andBlock:(nonnull NormalBlock)block{
    myBlock = block;
    if (model) {
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
