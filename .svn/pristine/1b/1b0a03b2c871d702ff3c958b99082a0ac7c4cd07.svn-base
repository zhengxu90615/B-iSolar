//
//  ADViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/20.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "ADViewController.h"
#import "UIKit+AFNetworking.h"

@interface ADViewController ()
{
    NSDictionary *adDic;
}
@end

@implementation ADViewController
- (id)initWithADDic:(NSDictionary*)dic
{
    if (self = [super init]) {
        adDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    button = [[ATCountdownButton alloc] initWithFrame:CGRectMake(MAINSCREENWIDTH -44 -20, 64, 44, 44)];
    [self.view addSubview:button];
    button.layer.cornerRadius = 22;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    button.progressColor = [UIColor whiteColor];
    button.progressTrackColor = MAIN_TINIT_COLOR;
    button.progressWidth = 5.0f;
    [button addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    [button startWithDuration:5.0f block:^(CGFloat time) {
        [button setTitle:[NSString stringWithFormat:@"%d",5-(int)time] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
       [button setTitle:[NSString stringWithFormat:@"跳过"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AD_DISMISS object:nil];
    }];
    
    if (![adDic[@"filePath"] hasPrefix:@"http"])
    {
        [adImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_FILE_HOST,adDic[@"filePath"]]] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (void)jump:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AD_DISMISS object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
