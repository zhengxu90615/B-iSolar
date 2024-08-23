//
//  CheckTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "AlarmNewCell.h"

@implementation AlarmNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    view0 = [[UIView alloc] initWithFrame:CGRectMake(10, 5, MAINSCREENWIDTH-20, 200-10)];
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
    
    [button0 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
    [button0 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    
    button1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button1.clipsToBounds = YES;
    [button1 setBackgroundColor:MAIN_TINIT_COLOR];

    button2.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button2.clipsToBounds = YES;
    [button2 setBackgroundColor:COLOR_CHARTS_COLOR1];
    
    label0.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    label0.textColor =  COLOR_TABLE_TITLE;
    
    [prossV setTintColor:MAIN_TINIT_COLOR];
//    label1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
//    label1.textColor =  COLOR_TABLE_DES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setData:(NSDictionary *)data andButtonClick:(nonnull NormalBlock)blcok{
    myBlock = blcok;
    label0.text = data[@"name"];

    
    label1.text = data[@"stationName"];
    label2.text = data[@"deviceName"];
    label3.text = data[@"assigneeUser"];
    label4.text = data[@"completeResult"];
    
    float height = 190;
    
    prossV.hidden = prossTitleLabel.hidden = label5.hidden =NO;
    view0.frame = CGRectMake(10, 5, MAINSCREENWIDTH-20, 200-10);

    if ([label4.text isEqualToString:@"处理完成"]) {
        label4.textColor = UIColorFromRGB0xFFFFFF(0x19D39B);
    }else if ([label4.text isEqualToString:@"处理中"]){
        label4.textColor = MAIN_TINIT_COLOR;
    }else if([label4.text isEqualToString:@"未处理"]){
        prossV.hidden = prossTitleLabel.hidden = label5.hidden  = YES;
        height = 190 -18-5;
        label4.textColor = UIColorFromRGB0xFFFFFF(0xf73042);
        view0.frame = CGRectMake(10, 5, MAINSCREENWIDTH-20, 200-10-18-5);
    }
    else
    {
        label4.textColor = UIColorFromRGB0xFFFFFF(0x303133);
    }
    
    label5.text = [NSString stringWithFormat:@"%@%%",TOSTRING(data[@"rate"])];
    float progress = [data[@"rate"] intValue]/100.0f;
    prossV.progress = progress;
    
    
    
    //    appointButton = 0;   //指派
    //    dealButton = 0;     //任务处理
    //    progressButton = 0;  //分任务进展
    //    takingButton = 0;  //任务接单
    //    urgingButton = 1;   //催办
    int appointButton = [data[@"button_dict"][@"appointButton"] intValue];
    int dealButton = [data[@"button_dict"][@"dealButton"] intValue];
    int takingButton = [data[@"button_dict"][@"takingButton"] intValue];
    
    int urgingButton = [data[@"button_dict"][@"urgingButton"] isEqualToString:@"none"]?0:1;

    int total = appointButton + dealButton    + takingButton  + urgingButton;
    
    float f =  self.height;
    
    [button0 setTitle:@"任务查看" forState:UIControlStateNormal];
    [button0 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
    [button0 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    button0.tag = 0;
    if (total == 0) {
        button1.hidden = button2.hidden = YES;
        button0.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 , height - 30, 72, 30);
    }else if (total == 1){
        button2.hidden = YES;
        button1.hidden = NO;
        button0.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 - 82, height - 30, 72, 30);
        button1.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 , height - 30, 72, 30);

        
        if (dealButton) {
            [button1 setTitle:@"任务处理" forState:UIControlStateNormal];
            [button1 setBackgroundColor:MAIN_TINIT_COLOR];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.tag = 1;
        }
    
        if (takingButton) {
            [button1 setTitle:@"任务接单" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button1.tag = 3;
        }
        if (appointButton==1)
        {
            [button1 setTitle:@"任务指派" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
            [button1 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
            button1.tag = 4;
        }
        if (urgingButton) {
            if ([data[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }else{
                [button1 setTitle:@"已催办" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            button1.tag = 5;
        }
    }else if (total == 2){
        button1.hidden = button2.hidden = NO;

        button0.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 - 82- 82, height - 30, 72, 30);
        button1.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 - 82 , height - 30, 72, 30);
        button2.frame = CGRectMake(MAINSCREENWIDTH - 72 -20 , height - 30, 72, 30);
        //
        //    dealButton = 0;     //任务处理
        //    progressButton = 0;  //分任务进展
        //    takingButton = 0;  //任务接单
        //    appointButton = 0;   //指派
        //    urgingButton = 1;   //催办
//        int appointButton = [data[@"button_dict"][@"appointButton"] intValue];
//        int dealButton = [data[@"button_dict"][@"dealButton"] intValue];
//        int progressButton = [data[@"button_dict"][@"progressButton"] intValue];
//        int takingButton = [data[@"button_dict"][@"takingButton"] intValue];
//        int urgingButton = [data[@"button_dict"][@"urgingButton"] intValue];
        while (1) {
           
            if (dealButton) {
                [button1 setTitle:@"任务处理" forState:UIControlStateNormal];
                [button1 setBackgroundColor:MAIN_TINIT_COLOR];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 1;
                break;
            }
          
            if (takingButton) {
                [button1 setTitle:@"任务接单" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 3;
                break;
            }
            if (appointButton==1)
            {
                [button1 setTitle:@"任务指派" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
                [button1 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
                
                button1.tag = 4;
                break;
            }
            if (urgingButton) {
                if ([data[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                    [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
                    [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [button1 setTitle:@"已催办" forState:UIControlStateNormal];
                    [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                button1.tag = 5;
                break;
            }
        }
        if (1) {
            
            if (dealButton) {
                [button2 setTitle:@"任务处理" forState:UIControlStateNormal];
                [button2 setBackgroundColor:MAIN_TINIT_COLOR];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 1;
            }
            
            if (takingButton) {
                [button2 setTitle:@"任务接单" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 3;
            }
            if (appointButton==1)
            {
                [button2 setTitle:@"任务指派" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
                [button2 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
                
                button2.tag = 4;
            }
            if (urgingButton) {
                if ([data[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                    [button2 setTitle:@"任务催办" forState:UIControlStateNormal];
                    [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [button2 setTitle:@"已催办" forState:UIControlStateNormal];
                    [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                button2.tag = 5;
            }
        }
        
        
        
        
    }
    
    
    
}

- (IBAction)btnClick:(id)sender {
    UIButton * btn = sender;
    myBlock(@(btn.tag));
}

@end
