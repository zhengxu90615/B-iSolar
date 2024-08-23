//
//  MonitorDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/15.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "MonitorDetailViewController.h"
#import "MonitorDetailTableViewCell.h"
#import "HomeTableHeaderView.h"
#import "ReportDetailChartsCell.h"
#import "HomeTableViewCompleteCell.h"
#import "DevPointsViewController.h"

@interface MonitorDetailViewController ()
{
    NSDictionary *currentMonitor;
    IBOutlet NSLayoutConstraint *topCon;
    IBOutlet NSLayoutConstraint *tableTopCon;
    
    NSMutableArray *allMonitorArr;
}
@property(nonatomic,strong) NSMutableArray *allMonitorArr;
@end

@implementation MonitorDetailViewController
@synthesize sepView;
@synthesize mainTableV;
@synthesize allMonitorArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    allMonitorArr = [[NSMutableArray alloc] init];
//    topCon.constant = 64;
//    tableTopCon.constant = -64;
    
    self.title = currentMonitor[@"name"];
    [monthBtn setTitle:@"电站监测" forState:UIControlStateNormal];
    [yearBtn setTitle:@"逆变器监测" forState:UIControlStateNormal];
    
    [mainTableV registerNib:[UINib nibWithNibName:@"MonitorDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorDetailTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportDetailChartsCell" bundle:nil] forCellReuseIdentifier:@"ReportDetailChartsCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"HomeTableViewCompleteCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCompleteCell"];
    
    
    weak_self(ws);
    sepView.frame = CGRectMake(0, 40, MAINSCREENWIDTH/2, 4);
    sepView.backgroundColor = MAIN_TINIT_COLOR;
    currentSelect = 1;
    [monthBtn setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [yearBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
  
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    
}

- (id)initWithMonitor:(NSDictionary *)monitor
{
    if (self = [super init]) {
        currentMonitor = [[NSDictionary alloc] initWithDictionary:monitor];
    }
    return self;
}

- (IBAction)sepBtnClick:(UIButton *)sender {
    weak_self(ws);
    [sender setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    
    if (sender == monthBtn) {
     
        currentSelect =1;
        [yearBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(0, 40, MAINSCREENWIDTH/2, 4);
        }];
    }else{
     
        currentSelect =2;
        [monthBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(MAINSCREENWIDTH/2, 40, MAINSCREENWIDTH/2, 4);
        }];
    }
    
    if ([mainTableV.mj_header isRefreshing]) {
        [self getData:nil];
    }else{
        [mainTableV.mj_header beginRefreshing];
    }
 
    
}



- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:TOSTRING(currentMonitor[@"id"] ) forKey:@"stationId"];
    [parmDic setObject:@(currentSelect) forKey:@"type"];
    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:API_MONITOR_DETAIL result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
            ws.selectTime = ws.dataModel.data[@"selectTime"];
            ws.allMonitorArr = [[NSMutableArray alloc] initWithArray:ws.dataModel.data[@"tableList"]];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
    
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentSelect == 1) {
        if (indexPath.section == 0 )
        {
            return 88*1.5;
        }
        return 88*3;
    }else{
        return 88;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(currentSelect == 1)
    {
        if (dataModel.data) {
            return 2;
        }
        return 0;
    }else
    {
        if (dataModel.data) {
            return 1+ [allMonitorArr count];
        }else
        {
            return 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (currentSelect == 1) {
        NSString *title = @"";
        switch (section) {
            case 0:
                title = String(@"负载一致性") ;
                break;
            default:
                title = String(@"日负荷曲线") ;
                break;
        }
        return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
    }else{
        NSString *title = @"";
        switch (section) {
            case 0:
                title = String(@"逆变器运行状态") ;
                break;
            default:
            {
                NSDictionary *dic =allMonitorArr[section-1];
                title = [NSString stringWithFormat:@"%@ | %@", dic[@"name"], dic[@"componentCapacity"]];
            }
                break;
        }
        
        
        return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentSelect==1) {
        if (indexPath.section == 0) {
            HomeTableViewCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCompleteCell"];
            [cell setData2:dataModel];
            return cell;
        }else{
            ReportDetailChartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportDetailChartsCell"];
            [cell setData:dataModel ];
            return cell;
        }
    }else{
        MonitorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorDetailTableViewCell"];
        if (indexPath.section == 0) {
            [cell setData:dataModel.data];
            weak_self(ws)
            cell.clickBlock = ^(NSInteger index){
//                [IOARequest showToast:TOSTRING(@(index))];
                
                switch (index) {
                    case 0:
                        {
                            ws.allMonitorArr = [[NSMutableArray alloc] initWithArray:ws.dataModel.data[@"tableList"]];
                        }
                        break;
                    case 1:
                    {
                        ws.allMonitorArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in ws.dataModel.data[@"tableList"]) {
                            if ([dic[@"running_status"] isEqualToString:@"运行（正常）"]) {
                                [ws.allMonitorArr addObject:dic];
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        ws.allMonitorArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in ws.dataModel.data[@"tableList"]) {
                            if ([dic[@"running_status"] isEqualToString:@"运行（偏低）"]) {
                                [ws.allMonitorArr addObject:dic];
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        ws.allMonitorArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in ws.dataModel.data[@"tableList"]) {
                            if ([dic[@"running_status"] isEqualToString:@"告警"]) {
                                [ws.allMonitorArr addObject:dic];
                            }
                        }
                    }
                        break;
                    case 4:
                    {
                        ws.allMonitorArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in ws.dataModel.data[@"tableList"]) {
                            if ([dic[@"running_status"] isEqualToString:@"停机"]) {
                                [ws.allMonitorArr addObject:dic];
                            }
                        }
                    }
                        break;
                    case 5:
                    {
                        ws.allMonitorArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in ws.dataModel.data[@"tableList"]) {
                            if ([dic[@"running_status"] isEqualToString:@"中断"]) {
                                [ws.allMonitorArr addObject:dic];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                        
                }
                
                [ws.mainTableV reloadData];
                
            };
        }else{
            NSDictionary *dic =allMonitorArr[indexPath.section-1];
            [cell setData:dic];
            cell.clickBlock =  ^(NSInteger index){
                
                NSLog(@"%@",dic);
                DevPointsViewController * v= [[DevPointsViewController alloc] initWithDevID:dic[@"DEVID"]];
                PUSHNAVICONTROLLER(v);
                
            };
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
