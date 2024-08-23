//
//  AssetsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/2.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssestOTableViewCell.h"
#import "AssetSTableViewCell.h"
#import "DeviceTypeBtn.h"
#import "AssetsForStationViewController.h"
@interface AssetsViewController ()
{
    IBOutlet NSLayoutConstraint *rightCon;
    
        
}
@end

@implementation AssetsViewController
@synthesize stationTableV;
@synthesize hideSectionArr,deviceArr;
@synthesize deviceScrollV;
@synthesize currentStationId;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = String(@"资产");
    rightCon.constant = MAINSCREENWIDTH/3 *2;

    currentStationId = [[NSString alloc] init];
    deviceArr = [[NSMutableArray alloc] init];
    
    [stationTableV registerNib:[UINib nibWithNibName:@"AssestOTableViewCell" bundle:nil] forCellReuseIdentifier:@"AssestOTableViewCell"];
    [stationTableV registerNib:[UINib nibWithNibName:@"AssetSTableViewCell" bundle:nil] forCellReuseIdentifier:@"AssetSTableViewCell"];
    
    hideSectionArr = [[NSMutableArray alloc] init];
    weak_self(ws);

    stationTableV.backgroundColor = [UIColor clearColor];
    self.stationTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.hideSectionArr removeAllObjects];
        [ws getData:nil];
    }];
    [self.stationTableV.mj_header beginRefreshing];
    
    self.deviceScrollV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.deviceArr removeAllObjects];
        
//        if (ws.currentStationId.length  0) {
            [ws getDevices];
//        }
    }];
    [self.deviceScrollV.mj_header beginRefreshing];
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
 
    [apiBlock startRequest:parmDic uri:API_STATIONS result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.stationTableV.mj_header endRefreshing];
        
        for (int i = 0; i< [ws.dataModel.data[@"list"] count];i++)
        {
            [ws.hideSectionArr addObject:@(i)];
        }
        [ws.stationTableV reloadData];
    }];
}


- (void)getDevices{
    
    for (UIView *v in deviceScrollV.subviews){
        if ([v isKindOfClass:[DeviceTypeBtn class]])
        {
            [v removeFromSuperview];
        }
    }
    
    if ([BAPIHelper getToken].length==0)
    {
        [self.deviceScrollV.mj_header endRefreshing];
        return;
    }
   
 
   
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:currentStationId forKey:@"stationid"];
    [apiBlock startRequest:parmDic uri:API_ASSETS_STATION result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.deviceArr = [[NSMutableArray alloc] initWithArray:respModel.data[@"devices"]];
            
            [self performSelectorOnMainThread:@selector(showDevices:) withObject:nil waitUntilDone:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.deviceScrollV.mj_header endRefreshing];
        
    }];
}

- (void)showDevices:(id)obj{
    int w = MAINSCREENWIDTH/3;
    int h = MAINSCREENWIDTH/3 + 25;
    for (int i =0; i< deviceArr.count;i++) {
        int x = i %2;
        int y = i/2;
        
        DeviceTypeBtn *btn = [[DeviceTypeBtn alloc] initWithFrame:CGRectMake(x*w, y*h, w, h)];
        weak_self(ws);
        [btn setData:deviceArr[i] withEvent:^{
            if (![currentStationId isEqualToString: @""]) {
                AssetsForStationViewController *vc = [[AssetsForStationViewController alloc] initWithStationID:TOSTRING(ws.deviceArr[i][@"stationid"] ) andType:TOSTRING(ws.deviceArr[i][@"type"] ) andStationName:TOSTRING(ws.deviceArr[i][@"stationname"] )];
                vc.hidesBottomBarWhenPushed = YES;
                [ws.navigationController pushViewController:vc animated:YES];
            }
        }];
        [self.deviceScrollV addSubview:btn];
    }
    
    self.deviceScrollV.contentSize = CGSizeMake(MAINSCREENWIDTH/3 *2, h * (deviceArr.count/2) + (deviceArr.count%2 == 1?h:0));
}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 54;
    }
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
    NSArray *arr = dataModel.data[@"list"];
    return arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = dataModel.data[@"list"];
    return (([hideSectionArr containsObject:@(section)])?0:[arr[section][@"list"] count]) + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section];
    NSArray *stationArr = orgnization[@"list"];

    UITableViewCell *cell;

    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AssestOTableViewCell"];
        [(AssestOTableViewCell*)cell setTitle:orgnization[@"name"]];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AssetSTableViewCell"];
        [(AssestOTableViewCell*)cell setTitle:stationArr[indexPath.row-1] [@"name"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section];
    NSArray *stationArr = orgnization[@"list"];
    
    if (indexPath.row == 0) {
        NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section];

        if(indexPath.section==0 && [orgnization[@"id"] intValue] == 0 ){
            currentStationId = @"";
//            [self.deviceScrollV.mj_header endRefreshing];
            [self.deviceScrollV.mj_header beginRefreshing];
            return;
        }
        NSMutableArray *stationIndexArr = [[NSMutableArray alloc] init];
        for (int i =0 ; i<stationArr.count; i++) {
            [stationIndexArr addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
        }
        
        if ([hideSectionArr containsObject:@(indexPath.section)]){
            [hideSectionArr removeObject:@(indexPath.section)];
            [tableView insertRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [hideSectionArr addObject:@(indexPath.section)];
            
            [tableView deleteRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }else{
        currentStationId = TOSTRING(stationArr[indexPath.row-1][@"id"]);
        [self.deviceScrollV.mj_header beginRefreshing];
    }
}




@end
