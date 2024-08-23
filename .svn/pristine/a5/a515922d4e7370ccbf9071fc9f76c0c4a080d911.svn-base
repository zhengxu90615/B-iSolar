//
//  SelectStationHeaderView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/17.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "Select3StationHeaderView.h"

@implementation Select3StationHeaderView
- (instancetype)initWithTitle:(NSArray *)threeTitles andButtonClick:(NormalBlock)block{
    CGRect rect = CGRectMake(0, 0, MAINSCREENWIDTH, 44);
    if (self = [super initWithFrame:rect]) {
        myBlock = block;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
        v.backgroundColor = [UIColor clearColor];
        [self addSubview:v];
        
        
        
        button0 = [UIButton buttonWithType:UIButtonTypeCustom];
        button0.tag = 0;
        [button0 setTitle:threeTitles[0] forState:UIControlStateNormal];
        button0.titleLabel.font = [UIFont systemFontOfSize:14];
        button0.titleLabel.textColor = COLOR_TABLE_TITLE;
        button0.frame = CGRectMake(0, 0, MAINSCREENWIDTH/3, 44);
        [button0 setImage:[[UIImage imageNamed:@"icon_down"] imageChangeColor:COLOR_TABLE_TITLE] forState:UIControlStateNormal];
        [self addSubview:button0];
        [self reSetBtn:button0];
        [button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag = 1;
        [button1 setTitle:threeTitles[1] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        button1.titleLabel.textColor = COLOR_TABLE_TITLE;
        button1.frame = CGRectMake(MAINSCREENWIDTH/3, 0, MAINSCREENWIDTH/3, 44);
        [button1 setImage:[[UIImage imageNamed:@"icon_down"] imageChangeColor:COLOR_TABLE_TITLE] forState:UIControlStateNormal];
        [self addSubview:button1];
        [self reSetBtn:button1];
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.tag = 2;
        [button2 setTitle:threeTitles[2] forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont systemFontOfSize:14];
        button2.titleLabel.textColor = COLOR_TABLE_TITLE;
        button2.frame = CGRectMake(MAINSCREENWIDTH/3 * 2, 0, MAINSCREENWIDTH/3, 44);
        [button2 setImage:[[UIImage imageNamed:@"icon_down"] imageChangeColor:COLOR_TABLE_TITLE] forState:UIControlStateNormal];
        [self addSubview:button2];
        [self reSetBtn:button2];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
//        button.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
//        button.clipsToBounds = YES;
//
//        button.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
//        button.layer.shadowOffset = CGSizeMake(0,0);
//        // 设置阴影透明度
//        button.layer.shadowOpacity = 1;
//        // 设置阴影半径
//        button.layer.shadowRadius = 1;
//        [self addSubview:button];
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)reSetBtn:(UIButton *)btn{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    CGFloat btnImageWidth = btn.imageView.bounds.size.width;
    CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
    CGFloat margin = 3;

    [btn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    
    btnImageWidth += margin;
    btnLabelWidth += margin;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
}

- (void)buttonClick:(UIButton *)btn{
    NSLog(@"%s",__func__);
    myBlock(@(btn.tag));
    
}
- (void)setTitle0:(NSString *)title0 title1:(NSString *)title1 title2:(NSString *)title2
{
    if(title0)
        [button0 setTitle:title0 forState:UIControlStateNormal];
    if(title1)
        [button1 setTitle:title1 forState:UIControlStateNormal];
    if(title2)
        [button2 setTitle:title2 forState:UIControlStateNormal];
    
    [self reSetBtn:button0];
    [self reSetBtn:button1];
    [self reSetBtn:button2];

}

- (void)hideBtn{
//    button.hidden = YES;
}

@end
