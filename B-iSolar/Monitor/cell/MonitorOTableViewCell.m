//
//  MonitorOTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/10.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "MonitorOTableViewCell.h"
#import "UIKit+AFNetworking.h"

@implementation MonitorOTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    riFaLabel.font = leftLabel0.font = leftLabel1.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    riFaLabel.textColor = leftLabel0.textColor = leftLabel1.textColor = [UIColor whiteColor];

//    bgView.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
//
//    bgView.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
//    bgView.layer.shadowOffset = CGSizeMake(0,0);
//    // 设置阴影透明度
//    bgView.layer.shadowOpacity = 1;
//    // 设置阴影半径
//    bgView.layer.shadowRadius = 1;
//    bgView.clipsToBounds = NO;
    
    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    titleLabel.textColor = [UIColor whiteColor];
    stationImg.image = [stationImg.image imageChangeColor:[UIColor whiteColor]];
    bgView.backgroundColor = MAIN_TINIT_COLOR;
    line0.backgroundColor = COLOR_TABLE_SEP;
    
    alarmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    

    bgView.backgroundColor = [UIColor grayColor];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,MAINSCREENWIDTH-20,150);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:1/255.0 green:154/255.0 blue:216/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:57/255.0 green:185/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [bgView.layer insertSublayer:gl atIndex:0];

    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"兆瓦发电量" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleLabel.textColor = UIColorFromHex(0xffffff);
    btn.frame = CGRectMake((MAINSCREENWIDTH-103)/2, 114, 103, 26);
    [btn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [self addSubview:btn];
    [self reSetBtn:btn];
    
    [btn setBackgroundColor:UIColorFromRGB0xFFFFFFA(0xffffff, .2f)];
//    [btn setBackgroundColor:UIColorFromRGB0xFFFFFFA(0xff0000, 1)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 13;
    btn.layer.masksToBounds = YES;
    btn.hidden = YES;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)bt{
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}
- (void)reSetBtn:(UIButton *)btn{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    CGFloat btnImageWidth = btn.imageView.bounds.size.width;
    CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
    CGFloat margin = 3;

    btnImageWidth += margin;
    btnLabelWidth += margin;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setBtn:(NSInteger)sort{
    if (sort == 0) {
           [btn setTitle:@"默认排序" forState:UIControlStateNormal];
       }else if (sort==1){
           [btn setTitle:@"兆瓦发电量" forState:UIControlStateNormal];
       }else{
           [btn setTitle:@"日发电量" forState:UIControlStateNormal];
       }
       [self reSetBtn:btn];
}
- (void)setData:(NSDictionary *)data andShowNum:(NSString *)numberString andShowBtn:(BOOL)isShow andSort:(NSInteger)sort
{
    btn.hidden = isShow;
    if (numberString){
        riFaLabel.text = numberString;
    }else{
        riFaLabel.text = @"";
    }
    [self setBtn:sort];
    
    [workBtn setImage:[[UIImage imageNamed:@"workorder"] imageChangeColor:[UIColor whiteColor]] forState:UIControlStateNormal];

    [alarmBtn setTitle:[NSString stringWithFormat:@"报警数(%@)",TOSTRING(data[@"alarm"])] forState:UIControlStateNormal];
    [workBtn setTitle:TOSTRING(data[@"work"]) forState:UIControlStateNormal];
    titleLabel.text = data[@"name"];
    
    leftLabel0.text = [NSString stringWithFormat:@"%@",data[@"capacity"]];
    leftLabel1.text = [NSString stringWithFormat:@"%@",data[@"mw"]];
    dgcDescLabel.text = [NSString stringWithFormat:@"日发电量\n(%@)",data[@"dgcUnit"]];
    
    mwDescLabel.text = [NSString stringWithFormat:@"兆瓦发电量\n(%@)",data[@"mwUnit"]];

    [imgV setImageWithURL:[NSURL URLWithString:API_FILE_URL(data[@"orga_img"])] placeholderImage:[UIImage imageNamed:@"img_gif"]];
}
- (void)hideBtn:(BOOL)isShow{
    btn.hidden = !isShow;
}
@end
