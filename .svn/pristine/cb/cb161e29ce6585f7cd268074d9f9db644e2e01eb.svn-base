//
//  BaseTableViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController
@synthesize mainTableV;

- (void)viewDidLoad {
//    self.navigationController.navigationBar.topItem.title = @"";
    [super viewDidLoad];
    
    float h = 44;
//    if (kStatusBarHeight == 20){
        h = kNavigationHeight + kBottomSafeAreaHeight;
//    }else{
//        h = 96+25;
//    }
//
    
    self.mainTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT-h) style:UITableViewStyleGrouped];
    mainTableV.delegate = self;
    mainTableV.dataSource = self;
    mainTableV.backgroundColor = [UIColor clearColor];
    mainTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:mainTableV];
    
    
    weak_self(ws)
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)getData:(id)sender{
   
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
