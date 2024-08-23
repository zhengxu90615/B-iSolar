//
//  CheckTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "CheckTableViewCell.h"

@implementation CheckTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MAINSCREENWIDTH-20, 78-10)];
    [self addSubview:view0];
    [self sendSubviewToBack:view0];
    view0.layer.cornerRadius  =  BUTTON_CORNERRADIUS;    // Initialization code
    
    view0.layer.shadowColor =  MAIN_TINIT_COLOR.CGColor;
    view0.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    view0.layer.shadowOpacity = 1;
    // 设置阴影半径
    view0.layer.shadowRadius = 1;
    view0.clipsToBounds = NO;
    view0.backgroundColor = [UIColor whiteColor];
    
    button0.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button0.clipsToBounds = YES;
    [button0 setBackgroundColor:MAIN_TINIT_COLOR];

    button1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button1.clipsToBounds = YES;
    [button1 setBackgroundColor:MAIN_TINIT_COLOR];

    button2.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button2.clipsToBounds = YES;
    [button2 setBackgroundColor:COLOR_CHARTS_COLOR1];
    
    label0.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    label0.textColor =  COLOR_TABLE_TITLE;
    
    label1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    label1.textColor =  COLOR_TABLE_DES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setData:(NSDictionary *)data andButtonClick:(nonnull NormalBlock)blcok{
    myBlock = blcok;
    label0.text = data[@"name"];
    label1.text = data[@"inspectionDate"];
    
}

- (IBAction)btnClick:(id)sender {
    UIButton * btn = sender;
    myBlock(@(btn.tag));
}

@end
