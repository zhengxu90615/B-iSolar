//
//  HomeTableViewCompleteCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "HomeTableViewCompleteCell.h"
#import "ZXYGradientProgress.h"
@implementation HomeTableViewCompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    gradientProgress = [[ZXYGradientProgress alloc] initWithFrame:CGRectMake(0,  88*0.15, 88*1.4, 88*1.4) progress:0];
    gradientProgress.center = CGPointMake(MAINSCREENWIDTH/2, 0.85*88);
    gradientProgress.bottomColor = [UIColor lightGrayColor];
    [self addSubview:gradientProgress];
    
    
    gradientProgress2 = [[ZXYGradientProgress alloc] initWithFrame:CGRectMake(0,  88*0.15, 88*1.4, 88*1.4) progress:0];
    gradientProgress2.center = CGPointMake(MAINSCREENWIDTH/2, 0.85*88);
    gradientProgress2.bottomColor = [UIColor lightGrayColor];
    [self addSubview:gradientProgress2];
}
- (void)setData:(BResponseModel*)model{
    
//    gradientProgress.frame = CGRectMake(0,  88*0.15, 88*1.4, 88*1.4);
//    gradientProgress2.frame = CGRectMake(0,  88*0.15, 88*1.4, 88*1.4);
    
//    gradientProgress.backgroundColor = [UIColor redColor];
//    gradientProgress2.backgroundColor = [UIColor blueColor];

    gradientProgress2.center = CGPointMake(MAINSCREENWIDTH/2 - 1.4*44-10, 0.85*88);
    gradientProgress.center = CGPointMake(MAINSCREENWIDTH/2 +  1.4*44+10, 0.85*88);

    
    [gradientProgress setProgress:[model.data[@"rate_float"] doubleValue]/100.0f andTitle:@"年计划电量完成率"];
    [gradientProgress2 setProgress:[model.data[@"rate_month_float"] doubleValue]/100.0f andTitle:@"月计划电量完成率"];

}

- (void)setData2:(BResponseModel*)model{
    gradientProgress2.hidden = YES;
    gradientProgress.center = CGPointMake(MAINSCREENWIDTH/2, 0.85*88);
    [gradientProgress setProgress:[model.data[@"converterLoadBalanceData"] doubleValue]/100.0f andTitle:@"负载一致性"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
