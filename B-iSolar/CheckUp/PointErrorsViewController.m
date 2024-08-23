//
//  PointErrorsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "PointErrorsViewController.h"
#import "PointErrorTableViewCell.h"
#import "SendErrorViewController.h"
@interface PointErrorsViewController ()
{
    NSDictionary *checkWork,*location,*point;
}
@end

@implementation PointErrorsViewController

- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary *)lo andPoint:(NSDictionary*)po
{
    if (self = [super init]) {
        checkWork = check;
        location = lo;
        point = po;
    }
    return self;
}

- (void)viewDidLoad {
    self.title = point[@"name"];

    [super viewDidLoad];
    [mainTableV registerNib:[UINib nibWithNibName:@"PointErrorTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointErrorTableViewCell"];
    mainTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.mainTableV.mj_header.isRefreshing) {
        [self.mainTableV.mj_header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
    [parmDic setObject:TOSTRING(location[@"id"]) forKey:@"location_id"];
    [parmDic setObject:TOSTRING(point[@"id"]) forKey:@"point_id"];

    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:API_CHECK_POINT_ERROER_LIST result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
    
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataModel.data[@"mission_error_list"] count];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PointErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointErrorTableViewCell"];
    [cell setData:[self.dataModel.data[@"mission_error_list"] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SendErrorViewController *se = [[SendErrorViewController alloc] initWithCheck:checkWork andLocation:location andPoint:point andError:[self.dataModel.data[@"mission_error_list"] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:se animated:YES];
}

@end
