//
//  CheckPointTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/29.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckPointTableViewCell.h"

@implementation CheckPointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    bgView.backgroundColor = WHITE_COLOR;
    
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    nameLabel.textColor = COLOR_TABLE_DES;
    // Initialization code
    line.backgroundColor = COLOR_TABLE_SEP;
    
    bgView.layer.borderColor = COLOR_TABLE_SEP.CGColor;
    bgView.layer.borderWidth = 0.5f;
    
    [leftButton setTitle:@"填报异常" forState:UIControlStateNormal];
    [rightButton setTitle:@"异常列表" forState:UIControlStateNormal];
    
    [leftButton setTintColor:MAIN_TINIT_COLOR ];
    leftButton.layer.cornerRadius = BUTTON_CORNERRADIUS;
    leftButton.layer.borderColor = MAIN_TINIT_COLOR.CGColor;
    leftButton.layer.borderWidth = 0.5f;
    
    [rightButton setTintColor:MAIN_TINIT_COLOR ];
    rightButton.layer.cornerRadius = BUTTON_CORNERRADIUS;
    rightButton.layer.borderColor = MAIN_TINIT_COLOR.CGColor;
    rightButton.layer.borderWidth = 0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)changeColor{
//    if (segControl.selectedSegmentIndex == 0) {
//        segControl.tintColor = MAIN_TINIT_COLOR;
//        [segControl setTintColor:MAIN_TINIT_COLOR];
//    }else if (segControl.selectedSegmentIndex == 1){
//        [segControl setTintColor:WHITE_COLOR];
//    }else{
//        [segControl setTintColor:COLOR_WARN];
//    }
//    [segControl setNeedsDisplay];
}

- (IBAction)rightClick:(id)sender {
    myBlock2(sender);
}

- (IBAction)leftClick:(id)sender {
    myBlock1(sender);
}

- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block andLeftClick:(NormalBlock)lefBlock andRightClick:(NormalBlock)rightBlock
{
    myBlock = block;
    myBlock1 = lefBlock;
    myBlock2 = rightBlock;
    nameLabel.text = dic[@"name"];
    
    if ([dic[@"value"] isEqualToString:@""]) {  //未点检
        lastSelectIndex = 1;
    }else if ([dic[@"value"] isEqualToString:@"-1"]){ //异常
        lastSelectIndex = 2;
    }else{
        lastSelectIndex = 0;
    }
    [segControl setSelectedSegmentIndex:lastSelectIndex];

    
    if ([dic[@"value"] isEqualToString:@""] || [dic[@"value"] isEqualToString:@"1"] )
    {
        //无异常 or 未点检
        
        line.hidden = NO;
        leftButton.hidden = rightButton.hidden = YES;
        bgView.frame = CGRectMake(5, 0, MAINSCREENWIDTH-10, 44);
        
    }else{
        //无异常
       
        line.hidden = YES;
        leftButton.hidden = rightButton.hidden = NO;
        bgView.frame = CGRectMake(5, 0, MAINSCREENWIDTH-10, 88);

    }
    
}

- (IBAction)segChanged:(id)sender {
    if (segControl.selectedSegmentIndex == 1) {
        [segControl setSelectedSegmentIndex:lastSelectIndex];
        [self changeColor];
        return;
    }
    lastSelectIndex = segControl.selectedSegmentIndex;
    myBlock(sender);
    [self changeColor];
}

@end
