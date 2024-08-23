//
//  MonitorTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/8.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "MonitorTableViewCell.h"
#import "UIKit+AFNetworking.h"

@implementation MonitorTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    bgView.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
//    
//    bgView.layer.shadowColor =MAIN_TINIT_COLOR.CGColor;
//    bgView.layer.shadowOffset = CGSizeMake(0,0);
//    // 设置阴影透明度
//    bgView.layer.shadowOpacity = 2;
//    // 设置阴影半径
//    bgView.layer.shadowRadius = 2;
//    bgView.clipsToBounds = NO;
    
    [alarmBtn setBackgroundColor:UIColorFromRGB0xFFFFFFA(0xff0000, .1f)];
    [alarmBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self bringSubviewToFront:alarmBtn];
    alarmBtn.enabled = YES;
    
    xBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREENWIDTH-10-100, 6, 100, 22)];
    [bgView addSubview:xBtn];
    [xBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setData:(NSDictionary *)data
{
//    [leftBtn setImage:[[UIImage imageNamed:@"alarm"] imageChangeColor:MAIN_TINIT_COLOR] forState:UIControlStateNormal];
//    [rightBtn setImage:[[UIImage imageNamed:@"workorder"] imageChangeColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//
    [alarmBtn setTitle:[NSString stringWithFormat:@"报警数(%@)",TOSTRING(data[@"alarm"])] forState:UIControlStateNormal];

    titleLabel.text = [NSString stringWithFormat:@"%@",data[@"name"]];
    tem.text = [NSString stringWithFormat:@"%@℃",data[@"tem"]];

    NSDictionary *dicTmp = data[@"EMI_RI"];
    
    fusheDesc.text =  [NSString stringWithFormat:@"%@(%@)",dicTmp[@"name"],dicTmp[@"unit"]];
    fushe.text = TOSTRING(dicTmp[@"value"]);

    dicTmp = data[@"PV_ACP"];
    gonglv.text = TOSTRING(dicTmp[@"value"]);
    gonglvDesc.text = [NSString stringWithFormat:@"%@(%@)",dicTmp[@"name"],dicTmp[@"unit"]];

    dicTmp = data[@"PV_DGC"];
    riFaLabel.text = TOSTRING(dicTmp[@"value"]);
    rifaDesc.text = [NSString stringWithFormat:@"日发电量\n(%@)",dicTmp[@"unit"]];
    
    leftLabel0.text = [NSString stringWithFormat:@"%@",data[@"capacity"]];
    leftLabel1.text = [NSString stringWithFormat:@"%@",[data[@"mw"] stringByReplacingOccurrencesOfString:@"千瓦时" withString:@""]];
    
    [imgV setImageWithURL:[NSURL URLWithString:API_FILE_URL(data[@"sta_img"])] placeholderImage:[UIImage imageNamed:@"img_gif"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftClick:(id)sender {
    self.leftClickBlock();
}
- (IBAction)rightClick:(id)sender {
    self.rightClickBlock();
}
@end
