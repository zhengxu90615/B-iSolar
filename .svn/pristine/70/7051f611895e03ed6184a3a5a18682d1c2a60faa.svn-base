//
//  CheckDetailTableHeader.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckDetailTableHeader.h"

@implementation CheckDetailTableHeader


- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block{
    CGRect rect = CGRectMake(0, 0, MAINSCREENWIDTH, 44);
    if (self = [super initWithFrame:rect]) {
        myBlock = block;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
        v.backgroundColor = WHITE_COLOR;
        [self addSubview:v];
        [self sendSubviewToBack:v];
        
        la = [[UILabel alloc] initWithFrame:CGRectMake( 10 , 5, MAINSCREENWIDTH-88-20 , rect.size.height-10)];
        la.backgroundColor = [UIColor clearColor];
        la.text = title;
        la.font = FONTSIZE_TABLEVIEW_HEADER;
        [self addSubview:la];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"全部完成" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        button.frame = CGRectMake(MAINSCREENWIDTH - 10 - 88, 10, 88, 24);
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
- (void)setTitle:(NSString *)title withBgColor:(UIColor *)bColor withTitleColor:(UIColor *)tColor
{
    button.enabled =![title isEqualToString:@"已完成"];
    
    [button setBackgroundColor:bColor];
    [button setTitleColor:tColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title andBtnTitle:(NSString *)btnTitle withBgColor:(UIColor *)bColor withTitleColor:(UIColor *)tColor
{
    la.text = title;
    [button setBackgroundColor:bColor];
    [button setTitleColor:tColor forState:UIControlStateNormal];
    [button setTitle:btnTitle forState:UIControlStateNormal];
}

@end
