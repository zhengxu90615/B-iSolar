//
//  DeviceTypeBtn.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/3.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "DeviceTypeBtn.h"

@implementation DeviceTypeBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, self.frame.size.width-60, self.frame.size.width-60)];
    imgV.image = [UIImage imageNamed:@"逆变器"];
    [self addSubview:imgV];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 50, self.frame.size.width-10, 50)];
    [self addSubview:titleLabel];
    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_TABLE_TITLE;
    titleLabel.numberOfLines = 0;
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setData:(NSDictionary *)data  withEvent:(DeviceTypeBtnBlock)block;
{
    imgV.image = [[UIImage imageNamed:data[@"type"]] imageChangeColor:MAIN_TINIT_COLOR];
    
    titleLabel.text = [NSString stringWithFormat:@"%@\n%@个",data[@"type"],data[@"count"]];
    myBlock = block;
}
- (void)btnClick:(id)sender
{
    if (myBlock){
        myBlock();
    }
}



@end
