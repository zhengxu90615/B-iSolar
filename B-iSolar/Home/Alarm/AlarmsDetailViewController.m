//
//  AlarmsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/11.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "AlarmsDetailViewController.h"
#import "AlarmNewCellTableViewCell.h"
#import "AlarmChuliViewController.h"

#import "MarkAlert.h"
#import "HomeTableHeaderView.h"

#import "AlarmDetailLogContentCell.h"

@interface AlarmsDetailViewController ()
{
    NSString *alarmId;

    NSMutableDictionary*misstionDic;

}
@property(nonatomic,strong)NSString *alarmId;
@end

@implementation AlarmsDetailViewController
@synthesize alarmId;
@synthesize mainTableV;

- (id)initWithStationId:(NSDictionary *)stationDic{
    if (self = [super init]) {
        alarmId = [NSString stringWithString:TOSTRING(stationDic[@"id"])];
        self.title = [NSString stringWithFormat:@"%@",String(@"报警任务详情")];
        if (stationDic.allKeys.count > 2) {
            misstionDic = [[NSMutableDictionary alloc] initWithDictionary:stationDic];
        }
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    weak_self(ws);
    mainTableV.backgroundColor = [UIColor clearColor];
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmNewCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmNewCellTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmDetailLogContentCell" bundle:nil] forCellReuseIdentifier:@"AlarmDetailLogContentCell"];
    
    
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"处理" style:UIBarButtonItemStyleDone target:ws action:@selector(dealAlarm)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableV.mj_header beginRefreshing];

}


- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    requestHelper.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    parmDic[@"alarmMonitorId"] = alarmId;
    [requestHelper startRequest:parmDic uri:API_MONITOR_ALARM_DETAIL result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
//            if ([respModel.data[@"dealResult"] isEqualToString:@"未处理"]) {
//                    ws.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"处理" style:UIBarButtonItemStyleDone target:ws action:@selector(dealAlarm)];
//            }
//            
            misstionDic = [[NSMutableDictionary alloc] initWithDictionary:respModel.data];
            [ws setButton];

            [ws.mainTableV.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        
        [ws.mainTableV reloadData];
    }];
}


- (void)setButton{
    if (!buttonView) {
//        mainTableV.frame = CGRectMake(mainTableV.x, mainTableV.y, mainTableV.width, mainTableV.height-74);
        tableVBomCon.constant = 74;
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, mainTableV.y + mainTableV.height, MAINSCREENWIDTH, 74)];
        buttonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:buttonView];
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView addSubview:button1];
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView addSubview:button2];
        
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
        button1.clipsToBounds = YES;
        button2.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
        button2.clipsToBounds = YES;
    }
    
    
    int appointButton = [misstionDic[@"button_dict"][@"appointButton"] intValue];
    int dealButton = [misstionDic[@"button_dict"][@"dealButton"] intValue];

    int takingButton = [misstionDic[@"button_dict"][@"takingButton"] intValue];
    int urgingButton = [misstionDic[@"button_dict"][@"urgingButton"] isEqualToString:@"none"]?0:1;

    int total = appointButton + dealButton    + takingButton  + urgingButton;
    
    if (total == 1){
        button2.hidden = YES;
        button1.hidden = NO;
        button1.frame = CGRectMake(15,12.5, MAINSCREENWIDTH-30, 49);

        if (dealButton) {
            [button1 setTitle:@"任务处理" forState:UIControlStateNormal];
            [button1 setBackgroundColor:MAIN_TINIT_COLOR];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.tag = 1;
        }
    
        if (takingButton) {
            [button1 setTitle:@"任务接单" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button1.tag = 3;
        }
        if (appointButton==1)
        {
            [button1 setTitle:@"任务指派" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
            [button1 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
            button1.tag = 4;
        }
        if (urgingButton) {
        
            
            if ([misstionDic[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }else{
                [button1 setTitle:@"已催办" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            
            button1.tag = 5;
        }
    }else if (total == 2){
        button1.hidden = button2.hidden = NO;

        button1.frame = CGRectMake(15,12.5, (MAINSCREENWIDTH-45)/2, 49);
        button2.frame = CGRectMake(MAINSCREENWIDTH/2 + 7.5, 12.5, (MAINSCREENWIDTH-45)/2, 49);
        
        while (1) {
           
            if (dealButton) {
                [button1 setTitle:@"任务处理" forState:UIControlStateNormal];
                [button1 setBackgroundColor:MAIN_TINIT_COLOR];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 1;
                break;
            }
            if (takingButton) {
                [button1 setTitle:@"任务接单" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 3;
                break;
            }
            if (appointButton==1)
            {
                [button1 setTitle:@"任务指派" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
                [button1 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
                
                button1.tag = 4;
                break;
            }
            if (urgingButton) {
                
                if ([misstionDic[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                    [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
                    [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                }else{
                    [button1 setTitle:@"已催办" forState:UIControlStateNormal];
                    [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                button1.tag = 5;
                break;
            }
        }
        if (1) {
            
            if (dealButton) {
                [button2 setTitle:@"任务处理" forState:UIControlStateNormal];
                [button2 setBackgroundColor:MAIN_TINIT_COLOR];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 1;
            }
            if (takingButton) {
                [button2 setTitle:@"任务接单" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 3;
            }
            if (appointButton==1)
            {
                [button2 setTitle:@"任务指派" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF0F2F5)];
                [button2 setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
                
                button2.tag = 4;
            }
            if (urgingButton) {
                
                if ([misstionDic[@"button_dict"][@"urgingButton"] isEqualToString:@"red"]) {
                    [button2 setTitle:@"任务催办" forState:UIControlStateNormal];
                    [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                }else{
                    [button2 setTitle:@"已催办" forState:UIControlStateNormal];
                    [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x333333)];
                    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                button2.tag = 5;
            }
        }
        
        
        
        
    }else if (total == 0){
        [buttonView removeFromSuperview];
        buttonView = nil;
        tableVBomCon.constant = 0;
        
    }
}


- (void)buttonClick:(UIButton*)btn{
    int tag = btn.tag;
    NSLog(@"%d",tag);
    switch (tag) {
        case 5:
            {
                NSLog(@"任务催办,%d",tag);
                if ([misstionDic[@"button_dict"][@"urgingButton"] isEqualToString:@"grey"]) {
                    return;
                }
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否催办该条任务？"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    [requestHelper stop];
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:misstionDic[@"id"] forKey:@"alarmMonitorId"];
          

                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/urging" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [self.mainTableV.mj_header beginRefreshing];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                    }];
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        case 4:
        {
            NSLog(@"任务指派,%d",tag);

            
            NSMutableArray*statusArr = [NSMutableArray array];
            for (NSDictionary*user in  misstionDic[@"userChoice"]) {
                [statusArr addObject:@{@"id":user[@"id"], @"name":user[@"name"]}];
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayActionOnlyOne:@"请选择要指派的人员" action:misstionDic[@"userChoice"] result:^(NSArray *arr) {
                if (!arr) {
                    return;
                }
                NSLog(@"%@",arr);
                NSMutableArray *idsArr = [NSMutableArray array];
                NSMutableArray *nameArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    [idsArr addObject:dic[@"id"]];
                    [nameArr addObject:dic[@"name"]];
                }
                NSString *ids = [idsArr componentsJoinedByString:@","];
                
                NSLog(@"%@",ids);
                
                [requestHelper stop];
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                [parmDic setObject:misstionDic[@"id"] forKey:@"alarmMonitorId"];
                [parmDic setObject:ids forKey:@"userId"];
                
                requestHelper.needShowHud =@1;
                [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/appoint" result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        [SVProgressHUD showSuccessWithStatus:respModel.message];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

                        [self.mainTableV.mj_header beginRefreshing];
 
                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }
                }];
                
                
                
                
            }];
            [al show];
            
        
            
        }
            break;
        case 3:
        {
            NSLog(@"任务接单,%d",tag);

            [requestHelper stop];
            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
            [parmDic setObject:misstionDic[@"id"] forKey:@"alarmMonitorId"];
  
            requestHelper.needShowHud =@1;
            [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/assignee" result:^(BResponseModel * _Nonnull respModel) {
                if (respModel.success) {
                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                    [self.mainTableV.mj_header beginRefreshing];

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

                }else{
                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                }
            }];
        }
            break;
            
        case 2:
        {
            NSLog(@"分任务,%d",tag);
        }
            break;
            
        case 1:
        {
            NSLog(@"任务处理,%d",tag);
            AlarmChuliViewController*vc = [[AlarmChuliViewController alloc] initWithMission:misstionDic];
            PUSHNAVICONTROLLER(vc);
        }
            break;
       
        default:
            break;
    }
}




#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 7) {
              
                return 10 + [AppDelegate textHeight: TOSTRING(misstionDic[@"description"]) andFontSIze:15 andTextwidth:MAINSCREENWIDTH-20 - 90];

            }
            return 30  ;

        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
    
                return 10 + [AppDelegate textHeight: TOSTRING(misstionDic[@"assigneeUserName"]) andFontSIze:15 andTextwidth:MAINSCREENWIDTH-20 - 90];
            }
            return 30;
        }
            
        case 2:
        {
            NSMutableDictionary*dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"logList"][indexPath.row]];

            
            CGFloat width = MAINSCREENWIDTH-20 - 90;
            
            int   fileListCount = [dic[@"file_list"] count];
            int lines = fileListCount/3 + (fileListCount%3 >0 ?1:0);
            
            CGFloat picwidth = (width-20-20)/3;
            CGFloat picH = picwidth* 1.333333 ;
            return MAX([AppDelegate textHeight: dic[@"dealNote"] andFontSIze:15 andTextwidth:MAINSCREENWIDTH-20 - 90] + 59 + lines* (picH+10), 100);
            
        }
        default:
            break;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!misstionDic) {
        return 0;
    }
    int secs = 2;
    if ([misstionDic[@"logList"] count]>0) {
        secs +=1;
    }
    return secs ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
        {
            if ([misstionDic[@"completeResultNum"] intValue] == 2) {
                return 7;
            }else if ([misstionDic[@"completeResultNum"] intValue]  == 1) {
                return 5;
            }
// 未处理3 处理中5 处理完成7
            return 3;
        }
            
            break;
        case 2:
            return [misstionDic[@"logList"] count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = @"报警信息";
    switch (section) {
        case 0:
            title = @"报警信息";
            break;
        case 1:
            title = @"任务信息";
            break;
        case 2:
            title = @"处理记录";
            break;
        default:
            break;
    }
    
    return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            {
                NSDictionary *dc = @{@"name":@"：",@"value":@""};
                switch (indexPath.row) {
                    case 0:
                        dc = @{@"name":@"项目公司：",@"value":TOSTRING(misstionDic[@"organizationName"])};
                        break;
                    case 1:
                        dc = @{@"name":@"电站：",@"value":TOSTRING(misstionDic[@"stationName"])};
                        break;
                    case 2:
                        dc = @{@"name":@"设备名称：",@"value":TOSTRING(misstionDic[@"deviceName"])};
                        break;
                    case 3:
                        dc = @{@"name":@"报警名称：",@"value":TOSTRING(misstionDic[@"name"])};
                        break;
                    case 4:
                        dc = @{@"name":@"报警时间：",@"value":TOSTRING(misstionDic[@"firstAlarmTime"])};
                        break;
                    case 5:
                        dc = @{@"name":@"故障时长：",@"value":TOSTRING(misstionDic[@"alarmDurationHours"])};
                        break;
                    case 6:
                        dc = @{@"name":@"报警等级：",@"value":TOSTRING(misstionDic[@"levelName"])};
                        break;
                    case 7:
                        dc = @{@"name":@"报警描述：",@"value":TOSTRING(misstionDic[@"description"])};
                        break;
                    default:
                        break;
                }
                
                
                AlarmNewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmNewCellTableViewCell"];
                [cell setData:dc];
                return  cell;
            }
            break;
        case 1:
            {
                NSDictionary *dc = @{@"name":@"：",@"value":@""};
                switch (indexPath.row) {
                    case 0:
                        dc = @{@"name":@"被指派人：",@"value":TOSTRING(misstionDic[@"assigneeUserName"])};
                        break;
                    case 1:
                        dc = @{@"name":@"指派人：",@"value":TOSTRING(misstionDic[@"appointUserName"])};
                        break;
                    case 2:
                        dc = @{@"name":@"任务状态：",@"value":TOSTRING(misstionDic[@"completeResult"])};
                        break;
                    case 3:
                        dc = @{@"name":@"接单人：",@"value":TOSTRING(misstionDic[@"assigneeUser"])};
                        break;
                    case 4:
                        dc = @{@"name":@"接单时间：",@"value":TOSTRING(misstionDic[@"takingTime"])};
                        break;
                    case 5:
                        dc = @{@"name":@"完成时间：",@"value":TOSTRING(misstionDic[@"completeTime"])};
                        break;
                    case 6:
                        dc = @{@"name":@"处理结果：",@"value":TOSTRING(misstionDic[@"dealResult"])};
                        break;
                 
                    default:
                        break;
                }
                
                
                AlarmNewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmNewCellTableViewCell"];
                [cell setData:dc];
                return  cell;
            }
            break;
        case 2:
            {
                NSMutableDictionary*dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"logList"][indexPath.row]];

                AlarmDetailLogContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmDetailLogContentCell"];
                [cell setData:dic andNeedLine:YES andBlock:^(id x) {
                   
                    NSLog(@"查看附件");
                    
                }];
                return cell;
            }
            break;
        default:
            break;
    }
    

    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}


@end
