//
//  DevPointsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/21.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "DevPointsViewController.h"
#import "PointTableViewCell.h"
#import "PointsValueViewController.h"

@interface DevPointsViewController ()
{
    int currentSelect ;
    NSString *devID;
}
@end

@implementation DevPointsViewController
@synthesize mainTableV;

- (id)initWithDevID:(NSString *)dID{
    if (self = [super init]) {
        devID = TOSTRING(dID);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备实时数据";
    currentSelect = 0;
    
    [button0 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [button1 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button2 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button3 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    
    sliderV.frame = CGRectMake(0, 0, MAINSCREENWIDTH/4, 4);
    sliderV.backgroundColor = MAIN_TINIT_COLOR;

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    mainTableV.backgroundColor = MAIN_BACKGROUND_COLOR;

    
    [button0 setTitle:String(@"遥测") forState:UIControlStateNormal];
    [button1 setTitle:String(@"遥信") forState:UIControlStateNormal];
    [button2 setTitle:String(@"遥脉") forState:UIControlStateNormal];
    [button3 setTitle:String(@"计算遥测量") forState:UIControlStateNormal];
    sliderV.frame = CGRectMake(currentSelect*MAINSCREENWIDTH/4, 0, MAINSCREENWIDTH/4, 4);
    
    [mainTableV registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointTableViewCell"];

    weak_self(ws);
    
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    
    
    [self.mainTableV.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)sepBtnClick:(UIButton *)sender {
    weak_self(ws);
    
    [button0 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button1 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button2 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    [button3 setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
    
    [sender setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];

    currentSelect = sender.tag-1000;
    
    [UIView animateWithDuration:.5 animations:^{
        sliderV.frame = CGRectMake(currentSelect*MAINSCREENWIDTH/4, 0, MAINSCREENWIDTH/4, 4);
    }];
    
    if ([mainTableV.mj_header isRefreshing]) {
        [self getData:nil];
    }else{
        [mainTableV.mj_header beginRefreshing];
    }
}


- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    

    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    UIButton *btn = [self.view viewWithTag:1000+currentSelect];
    
    parmDic[@"devId"] = devID;
  
    parmDic[@"measureType"] = btn.titleLabel.text;

    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:@"mobile/monitor_device_points_value" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.title = [NSString stringWithFormat:@"%@ %@",respModel.data[@"deviceInfo"][@"dci__name"],respModel.data[@"deviceInfo"][@"name"]];
            ws.dataModel = respModel;
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        if([ws.mainTableV.mj_header isRefreshing])
            [ws.mainTableV.mj_header endRefreshing];
        if([ws.mainTableV.mj_footer isRefreshing])
            [ws.mainTableV.mj_footer endRefreshing];
        [ws.mainTableV reloadData];
    }];
        
 
    
}




#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
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

    PointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];

    [cell setData:device];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    NSDictionary *point = dataModel.data[@"list"][indexPath.row];

    NSDictionary *devInfo = self.dataModel.data[@"deviceInfo"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PointsValueViewController*v = [[PointsValueViewController alloc] initWithStationID:devInfo[@"station"] andPointID:point[@"id"]];
    PUSHNAVICONTROLLER(v);
    

}






@end
