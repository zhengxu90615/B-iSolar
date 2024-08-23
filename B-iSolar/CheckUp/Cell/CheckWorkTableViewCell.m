//
//  CheckWorkTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/23.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckWorkTableViewCell.h"

@implementation CheckWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

//    titleLabel0.font = titleLabel1.font =  FONTSIZE_TABLEVIEW_CELL_TITLE;
//    titleLabel0.textColor = titleLabel1.textColor =  COLOR_TABLE_TITLE;
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MAINSCREENWIDTH-20, 108-10)];
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
       
    stationLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    stationLabel.textColor =  COLOR_TABLE_TITLE;
    
    dateLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    dateLabel.textColor =  COLOR_TABLE_DES;
    // Initialization code
    
    button.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button.clipsToBounds = YES;
    
    button1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button1.clipsToBounds = YES;
    
    button2.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button2.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonClick:(id)sender {
    UIButton *bt = (UIButton *)sender;
    if (bt == button) {
        myBlock(nil);
    }else if (bt == button1){
        myBlock1(nil);
    }else{
        myBlock2(nil);
    }
}

- (void)setData:(NSDictionary *)data andButtonClick:(NormalBlock)blcok andButton1Click:(NormalBlock)blcok1 andButton2Click:(NormalBlock)blcok2{
    myBlock = blcok;
    myBlock1 = blcok1;
    myBlock2 = blcok2;
    stationLabel.text = data[@"name"];
    dateLabel.text = data[@"start_time"];
    
    if ([data[@"start_real_time"]  isEqualToString:@""]) {
        [button setTitle:@"开始巡检" forState:UIControlStateNormal];
        button.enabled = true;
        [button setBackgroundColor:MAIN_TINIT_COLOR];
        
        [button1 setTitle:@"指派" forState:UIControlStateNormal];
        button1.enabled = true;
        [button1 setBackgroundColor:[UIColor whiteColor]];
        
        [button2 setTitle:@"完成" forState:UIControlStateNormal];
        button2.enabled = false;
        [button2 setBackgroundColor:COLOR_TABLE_SEP ];
    }else{
        [button setTitle:@"继续巡检" forState:UIControlStateNormal];
        button.enabled = true;
        [button setBackgroundColor:MAIN_TINIT_COLOR];
        
        [button1 setTitle:@"指派" forState:UIControlStateNormal];
        button1.enabled = true;
        [button1 setBackgroundColor:[UIColor whiteColor]];
        
        [button2 setTitle:@"完成" forState:UIControlStateNormal];
        button2.enabled = true;
        [button2 setBackgroundColor:MAIN_TINIT_COLOR];
    }
}
@end
