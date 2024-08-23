//
//  AssetsForStationViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/3.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AssetsForStationViewController.h"
#import "DevPointsViewController.h"

@interface AssetsForStationViewController ()
{
    NSString *stationID;
    NSString *stationName;
    NSString *deviceType;

}
@end

@implementation AssetsForStationViewController
@synthesize mainTableV;

- (id)initWithStationID:(NSString *)stationid andType:(NSString *)deviceT andStationName:(NSString *)name
{
    if (self = [super init])
    {
        stationID = [[NSString alloc] initWithString:stationid];
        stationName = [[NSString alloc] initWithString:name];
        deviceType = [[NSString alloc] initWithString:deviceT];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@-%@",stationName,deviceType];
    
    weak_self(ws);

    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
}


- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:stationID forKey:@"stationid"];
    [parmDic setObject:deviceType forKey:@"type"];
    [apiBlock startRequest:parmDic uri:API_ASSETS_TYPE result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
}



#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = dataModel.data[@"list"];
    return arr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *device = dataModel.data[@"list"][indexPath.row];

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = device[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *device = dataModel.data[@"list"][indexPath.row];

    DevPointsViewController * v= [[DevPointsViewController alloc] initWithDevID:device[@"id"]];
    PUSHNAVICONTROLLER(v);
    
}


@end
