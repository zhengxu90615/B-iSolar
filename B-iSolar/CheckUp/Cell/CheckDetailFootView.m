//
//  CheckDetailFootView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckDetailFootView.h"
#import "UIImageView+WebCache.h"

@implementation CheckDetailFootView

- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block{
    CGRect rect = CGRectMake(0, 0, MAINSCREENWIDTH, 264);
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor clearColor];
        myBlock = block;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 264-5)];
        v.backgroundColor = [UIColor whiteColor];
        [self addSubview:v];
        [self sendSubviewToBack:v];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake( 10 , 5, MAINSCREENWIDTH-88-20 , 20)];
        la.backgroundColor = [UIColor clearColor];
        la.text = title;
        la.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        la.textColor = COLOR_TABLE_TITLE;
        [self addSubview:la];
        
        desLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10 , la.frame.origin.y + la.frame.size.height + 5, MAINSCREENWIDTH-20 ,20)];
        desLabel.backgroundColor = [UIColor clearColor];
        desLabel.text = title;
        desLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        desLabel.textColor = COLOR_TABLE_DES;
        [self addSubview:desLabel];
        
        bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, desLabel.mj_y + desLabel.mj_h + 5, MAINSCREENWIDTH-20, 264- desLabel.mj_y -  desLabel.mj_h - 20)];
        bgImageV.backgroundColor = [UIColor whiteColor];
        
        bgImageV.layer.borderColor = [UIColor grayColor].CGColor;
        bgImageV.layer.borderWidth = 0.5f;
        bgImageV.contentMode = 	UIViewContentModeScaleAspectFit;
        [self addSubview:bgImageV];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [button setTitle:@"添加照片" forState:UIControlStateNormal];
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -50, -50, 0)	;
        button.imageEdgeInsets = UIEdgeInsetsMake(-20-5, 20, 0, -30);
        
        [button setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        button.frame = bgImageV.frame;
        button.backgroundColor = [UIColor clearColor];
        
        [self addSubview:button];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    myBlock(btn);
}

- (void)setData:(NSDictionary*)data
{
    desLabel.text = data[@"fatigueName"];
    
    if ([data[@"fatiguePath"] length] > 0) {
        [self setImage:nil orUrl:API_FILE_URL(data[@"fatiguePath"])];
    }
    
}
- (void)setImage:(UIImage*)img orUrl:(NSString *)imgUrl
{
    if (img) {
        [bgImageV setImage:img];
    }else{
        [bgImageV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateNormal];

    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
