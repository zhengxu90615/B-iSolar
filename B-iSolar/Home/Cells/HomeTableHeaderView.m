//
//  HomeTableHeaderView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "HomeTableHeaderView.h"

@implementation HomeTableHeaderView
- (instancetype)initWithTitle:(NSString *)title andFrame:(CGRect )rect{
    if (self = [super initWithFrame:rect]) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 5, rect.size.height-10)];
        v.backgroundColor = MAIN_TINIT_COLOR;
        [self addSubview:v];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(v.frame.origin.x + 5 + v.frame.size.width, 5, rect.size.width - (v.frame.origin.x + 5 + v.frame.size.width) -5 , rect.size.height-10)];
        la.backgroundColor = [UIColor clearColor];
        la.text = title;
        la.font = FONTSIZE_TABLEVIEW_HEADER;
        [self addSubview:la];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
