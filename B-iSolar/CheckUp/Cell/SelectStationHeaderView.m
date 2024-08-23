//
//  SelectStationHeaderView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/17.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "SelectStationHeaderView.h"

@implementation SelectStationHeaderView

- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block{
    CGRect rect = CGRectMake(0, 0, MAINSCREENWIDTH, 44);
    if (self = [super initWithFrame:rect]) {
        myBlock = block;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 0, 0)];
        v.backgroundColor = MAIN_TINIT_COLOR;
        [self addSubview:v];
        
        la = [[UILabel alloc] initWithFrame:CGRectMake(v.frame.origin.x + 5 + v.frame.size.width, 5, rect.size.width - (v.frame.origin.x + 5 + v.frame.size.width) -5 , rect.size.height-10)];
        la.backgroundColor = [UIColor clearColor];
        la.text = title;
        la.font = FONTSIZE_TABLEVIEW_HEADER;
        [self addSubview:la];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"全部" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        button.frame = CGRectMake(MAINSCREENWIDTH/2 + 5, 10, MAINSCREENWIDTH/2 - 10, 24);
        button.backgroundColor = [UIColor whiteColor];
        
        button.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
        button.clipsToBounds = YES;

        button.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
        button.layer.shadowOffset = CGSizeMake(0,0);
        // 设置阴影透明度
        button.layer.shadowOpacity = 1;
        // 设置阴影半径
        button.layer.shadowRadius = 1;
        [self addSubview:button];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"%s",__func__);
    myBlock(btn);
    
}
- (void)setTitle:(NSString *)title{
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)setNameLabel:(NSString *)nameLabel{
    la.text = nameLabel;
}

- (void)hideBtn{
    button.hidden = YES;
}

@end
