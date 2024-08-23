//
//  FiveWebViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "FiveWebViewController.h"

@interface FiveWebViewController ()

@end

@implementation FiveWebViewController
@synthesize mainWebV;
- (void)viewDidLoad {
    [super viewDidLoad];
    



    [self loadWeb];
  

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadWeb];
}

- (void)loadWeb{
    NSString *url =[NSString stringWithFormat:@"%@mobile/report/index?token=%@",API_HOST,[BAPIHelper getToken]];
    [mainWebV loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
