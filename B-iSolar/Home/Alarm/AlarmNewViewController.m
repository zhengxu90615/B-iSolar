//
//  AlarmsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "AlarmNewViewController.h"
#import "AlarmNewCellTableViewCell.h"
#import "AlarmsDetailViewController.h"
#import "AlarmChuliViewController.h"
#import "AlarmNewCell.h"
#import "MarkAlert.h"
#import "AlarmGZNewCell.h"
#import "GZDetailViewController.h"
#import "GZChuliViewController.h"
#import "NewGuzViewController.h"
@interface AlarmNewViewController ()
{
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    
    NSString *level,*orga,*station , *guzhanglevel;
    NSString *levelname,*guzhanglevelname;
    
    UIBarButtonItem *checkRightBtn;
    NSArray * orgaArr;
    NSArray * stationArr;
    NSDictionary *stationDic, *orgDic;
    NSInteger currentSelect;
    NSDictionary *alarmDataDic,*guzhangDataDic;
}

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *guzhangDataArr;


@end

@implementation AlarmNewViewController
@synthesize mainTableV;
- (id)initWithStation:(NSDictionary *)station andOrinization:(NSDictionary*)org
{
    if (self = [super init]) {
        stationDic = [[NSDictionary alloc] initWithDictionary:station];
        orgDic = [[NSDictionary alloc] initWithDictionary:org];
    }
    return self;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];

    if (btn.tag == 0) {
        self.navigationItem.rightBarButtonItem = nil;

        if (currentSelect == 1) {
            currentSelect = 0;
            [mainTableV reloadData];
        }
        NSString *str = @"状态";
        if (![level isEqualToString: @""]) {
            str = levelname;
        }
        [button2 setTitle:str forState:UIControlStateNormal];
        [self reSetBtn:button2];

        currentSelect = 0;
        
        [guzhangBtn setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            sepView.frame = CGRectMake(0, 44, MAINSCREENWIDTH/2, 4);
        }];
        
    }else{
        self.navigationItem.rightBarButtonItem = checkRightBtn;

        if (currentSelect == 0) {
            currentSelect = 1;
            [mainTableV reloadData];
        }
        
        NSString *str = @"状态";
        if (![guzhanglevel isEqualToString: @""]) {
            str = guzhanglevelname;
        }
        [button2 setTitle:str forState:UIControlStateNormal];

        [self reSetBtn:button2];

        currentSelect = 1;
        [alarmBtn  setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            sepView.frame = CGRectMake(MAINSCREENWIDTH/2, 44, MAINSCREENWIDTH/2, 4);
        }];
    }
    
    [self.mainTableV.mj_header beginRefreshing];
}


- (void)reSetBtn:(UIButton *)btn{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    CGFloat btnImageWidth = btn.imageView.bounds.size.width;
    CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
    CGFloat margin = 3;

    btnImageWidth += margin;
    btnLabelWidth += margin;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmNewCell" bundle:nil] forCellReuseIdentifier:@"AlarmNewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmGZNewCell" bundle:nil] forCellReuseIdentifier:@"AlarmGZNewCell"];
    
    [alarmBtn setTitle:String(@"报警任务") forState:UIControlStateNormal];
    [guzhangBtn setTitle:String(@"故障任务") forState:UIControlStateNormal];

    sepView.frame = CGRectMake(0, 44, MAINSCREENWIDTH/2, 4);
    sepView.backgroundColor = MAIN_TINIT_COLOR;

    self.guzhangDataArr = [[NSMutableArray alloc] init];
    
//    currentSelect = -1;    //   0 巡检      2 外部巡检     -1 任务
    [alarmBtn setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [alarmBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [guzhangBtn setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
    [guzhangBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    currentSelect = 0;
    
    self.title = String(@"报警列表");
    self.dataArr = [[NSMutableArray alloc] init];
    level = @"";
    guzhanglevel = @"";
    orga= @"";
    station = @"";
    orgaArr = [[NSArray alloc] init];
    stationArr = [[NSArray alloc] init];
    
    button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"项目公司" forState:UIControlStateNormal];
    button0.titleLabel.font = [UIFont systemFontOfSize:14];
    [button0 setTitleColor:UIColorFromHex(0x606266) forState:UIControlStateNormal];
    button0.frame = CGRectMake(0, 44, MAINSCREENWIDTH/3, 44);
    [button0 setImage:[UIImage imageNamed:@"icon_down_g"] forState:UIControlStateNormal];
    [self.view addSubview:button0];
    [self reSetBtn:button0];
    [button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button0.tag = 0;
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"项目电站" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setTitleColor:UIColorFromHex(0x606266) forState:UIControlStateNormal];

    button1.frame = CGRectMake(MAINSCREENWIDTH/3, 44, MAINSCREENWIDTH/3, 44);
    [button1 setImage:[UIImage imageNamed:@"icon_down_g"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [self reSetBtn:button1];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"状态" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitleColor:UIColorFromHex(0x606266) forState:UIControlStateNormal];
    button2.titleLabel.textColor = UIColorFromHex(0x606266);
    button2.frame = CGRectMake(MAINSCREENWIDTH/3 * 2, 44, MAINSCREENWIDTH/3, 44);
    [button2 setImage:[UIImage imageNamed:@"icon_down_g"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [self reSetBtn:button2];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmDealSuccess:) name:@"alarmDealSuccess" object:nil];

    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmNewCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmNewCellTableViewCell"];
    weak_self(ws);
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 0;

        [ws getData:nil];
    }];
     self.mainTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           [ws getData:nil];
     }];
    

    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    mainTableV.backgroundColor = MAIN_BACKGROUND_COLOR;
        
    [self getOrga];
    [self getStation];
    
    
    if (stationDic) {
        orga = TOSTRING(orgDic[@"id"]);
        [button0 setTitle:orgDic[@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button0];


        [self reSetBtn:button0];
            
        station = TOSTRING(stationDic[@"id"]);
        [button1 setTitle:stationDic[@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button1];

        [mainTableV.mj_header beginRefreshing];
    }else{
        [self.mainTableV.mj_header beginRefreshing];
    }
    
    
    checkRightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(newGz)];
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)newGz{
    
    PUSHNAVI(NewGuzViewController);
    
}


- (void)alarmDealSuccess:(id)obj{
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)buttonClick:(UIButton *)btn{
    if ( btn ==button0) {
        NSMutableArray *levelArr = [[NSMutableArray alloc] init];
        [levelArr addObject:@{@"name":@"全部", @"id":@""}];
        [levelArr addObjectsFromArray:orgaArr];
        [self.pickerV setType:PickerTypeOne andTag:0 andDatas:levelArr];
        self.pickerV.hiddenCustomPicker = NO;
        
    }else if ( btn ==button1) {
        NSMutableArray *levelArr = [[NSMutableArray alloc] init];
        [levelArr addObject:@{@"name":@"全部", @"id":@""}];
        [levelArr addObjectsFromArray:stationArr];
        [self.pickerV setType:PickerTypeOne andTag:1 andDatas:levelArr];
        self.pickerV.hiddenCustomPicker = NO;
    }else{
        NSMutableArray *levelArr = [[NSMutableArray alloc] init];
        [levelArr addObject:@{@"name":@"全部", @"value":@""}];
        
        if (currentSelect == 0) {
            if (alarmDataDic) {
                [levelArr addObjectsFromArray:alarmDataDic[@"completeResultChoice"]];
            }
        }else{
            if (guzhangDataDic) {
                [levelArr removeAllObjects];
                [levelArr addObject:@{@"name":@"全部", @"id":@""}];
                [levelArr addObjectsFromArray:guzhangDataDic[@"completeResultChoice"]];
            }
        }
       
        [self.pickerV setType:PickerTypeOne andTag:2 andDatas:levelArr];
        self.pickerV.hiddenCustomPicker = NO;
    }
}

- (void)getData:(id)obj{
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    if (currentSelect == 0) {
        [self getOrga];
        BHttpRequest * apiBlock = [BHttpRequest new];
        weak_self(ws);
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

        apiBlock.needShowHud =@0;
        parmDic[@"pageindex"] = @(self.pageIndex);
        if (![level isEqualToString:@""]) {
            parmDic[@"completeResult"] = level;
        }
         if (![orga isEqualToString:@""])
             parmDic[@"organizationId"] = orga;
        if (![station isEqualToString:@""])
            parmDic[@"stationId"] = station;

        [apiBlock startRequest:parmDic uri:API_ALARMSNEW_LIST result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                alarmDataDic = [NSDictionary dictionaryWithDictionary:respModel.data];
                if (respModel.pageindex == 0) {
                    [ws.dataArr removeAllObjects];
                    [ws.mainTableV.mj_header endRefreshing];
                }else{
                    [ws.mainTableV.mj_footer endRefreshing];
                }

                if ([respModel.data[@"list"] count] < respModel.pagenum) {
                    [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
                }
                [ws.dataArr addObjectsFromArray:respModel.data[@"list"]];
                
                ws.pageIndex = respModel.pageindex+1;
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
            [ws.mainTableV reloadData];
        }];
    }else{
        [self getOrga];
        BHttpRequest * apiBlock = [BHttpRequest new];
        weak_self(ws);
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

        apiBlock.needShowHud =@0;
        parmDic[@"pageindex"] = @(self.pageIndex);
        if (![guzhanglevel isEqualToString:@""]) {
            parmDic[@"completeResult"] = guzhanglevel;
        }
         if (![orga isEqualToString:@""])
             parmDic[@"organizationId"] = orga;
        if (![station isEqualToString:@""])
            parmDic[@"stationId"] = station;

        [apiBlock startRequest:parmDic uri:@"mobile/fault_task/list" result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                

                guzhangDataDic = [NSDictionary dictionaryWithDictionary:respModel.data];

                if (respModel.pageindex == 0) {
                    [ws.guzhangDataArr removeAllObjects];
                    [ws.mainTableV.mj_header endRefreshing];
                }else{
                    [ws.mainTableV.mj_footer endRefreshing];
                }

                if ([respModel.data[@"list"] count] < respModel.pagenum) {
                    [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
                }
                [ws.guzhangDataArr addObjectsFromArray:respModel.data[@"list"]];
                
                ws.pageIndex = respModel.pageindex+1;
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
            [ws.mainTableV reloadData];
        }];
    }
    
    
    
}


- (void)getOrga{
    BHttpRequest * apiBlock = [BHttpRequest new];
    apiBlock.needShowHud = @(0);
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"menuName":@"alarmMonitor_list"}];

    if (currentSelect == 0) {
        
    }else{
        parmDic[@"menuName"] = @"faultTask_list";

    }
    
    [apiBlock startRequest:parmDic uri:API_ORGA_LIST result:^(BResponseModel * _Nonnull respModel) {
         if (respModel.success) {
             orgaArr = respModel.data;
         }else{
             
         }
     }];
}
- (void)getStation{
    BHttpRequest * apiBlock = [BHttpRequest new];
   apiBlock.needShowHud = @(0);
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"menuName":@"alarmMonitor_list"}];
    if (![orga isEqualToString:@""]) {
        parmDic[@"organizationId"] = orga;
    }
    
    if (currentSelect == 0) {
        
    }else{
        parmDic[@"menuName"] = @"faultTask_list";

    }
    
    [apiBlock startRequest:parmDic uri:API_STAT_LIST result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            stationArr = respModel.data;
        }else{
            
        }
    }];
}




#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentSelect==0) {
        NSDictionary *miss = [self.dataArr objectAtIndex:indexPath.row];

        if([TOSTRING(miss[@"completeResultNum"]) isEqualToString:@"0"])
            return 200 - 18 - 5;
        else
            return 200;
    }else{
        NSDictionary *miss = [self.guzhangDataArr objectAtIndex:indexPath.row];

        if([TOSTRING(miss[@"completeResultNum"]) isEqualToString:@"0"])
            return 200 - 18 - 5;
        else
            return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentSelect == 0) {
        return [self.dataArr count];

    }else{
        return [self.guzhangDataArr count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (currentSelect == 0) {
        AlarmNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmNewCell"];

        NSDictionary *miss = [self.dataArr objectAtIndex:indexPath.row];
        weak_self(ws)
        [cell setData:miss andButtonClick:^(id x) {
            
            switch ([x intValue]) {
                case 5:
                    {
                        NSLog(@"任务催办,%@",x);
                        if ([miss[@"button_dict"][@"urgingButton"] isEqualToString:@"grey"]) {
                            return;
                        }
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否催办该条任务？"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                            [requestHelper stop];
                            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                            [parmDic setObject:miss[@"id"] forKey:@"alarmMonitorId"];
                  

                            requestHelper.needShowHud =@1;
                            [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/urging" result:^(BResponseModel * _Nonnull respModel) {
                                if (respModel.success) {
                                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                                    
                                    [ws.dataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                    [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                    
                                }else{
                                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                                }
                            }];
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:okAction];
                        [ws presentViewController:alert animated:YES completion:nil];
                    }
                    break;
                case 4:
                {
                    NSLog(@"任务指派,%@",x);
                    
                    
                    NSMutableArray*statusArr = [NSMutableArray array];
                    for (NSDictionary*user in  miss[@"userChoice"]) {
                        [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
                    }
                    
                    MarkAlert *al = [[MarkAlert alloc] initWithPayActionOnlyOne:@"请选择要指派的人员" action:statusArr result:^(NSArray *arr) {
                        
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
                        [parmDic setObject:miss[@"id"] forKey:@"alarmMonitorId"];
                        [parmDic setObject:ids forKey:@"userId"];
                        
                        requestHelper.needShowHud =@1;
                        [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/appoint" result:^(BResponseModel * _Nonnull respModel) {
                            if (respModel.success) {
                                [SVProgressHUD showSuccessWithStatus:respModel.message];
                                
                                [ws.dataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                
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
                    NSLog(@"任务接单,%@",x);

                    [requestHelper stop];
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:miss[@"id"] forKey:@"alarmMonitorId"];
          
                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/assignee" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [ws.dataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                            [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                    }];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"分任务,%@",x);
                   
                }
                    break;
                    
                case 1:
                {
                    NSLog(@"任务处理,%@",x);
                    AlarmChuliViewController*vc = [[AlarmChuliViewController alloc] initWithMission:miss];
                    PUSHNAVICONTROLLER(vc);
                }
                    break;
                    
                case 0:
                {
                    NSLog(@"任务详情,%@",x);
                  
                    AlarmsDetailViewController *vc = [[AlarmsDetailViewController alloc] initWithStationId:miss];
                    PUSHNAVICONTROLLER(vc);
                }
                    break;
                default:
                    break;
            }
            NSLog(@"xxx,%@",x);
        }];
        return cell;
    }else{
        AlarmGZNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmGZNewCell"];

        NSDictionary *miss = [self.guzhangDataArr objectAtIndex:indexPath.row];
        weak_self(ws)
        [cell setData:miss andButtonClick:^(id x) {
            
            switch ([x intValue]) {
                case 5:
                    {
                        NSLog(@"任务催办,%@",x);
                        if ([miss[@"button_dict"][@"urgingButton"] isEqualToString:@"grey"]) {
                            return;
                        }
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否催办该条任务？"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                            [requestHelper stop];
                            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                            [parmDic setObject:miss[@"id"] forKey:@"faultTaskId"];
                  

                            requestHelper.needShowHud =@1;
                            [requestHelper startRequest:parmDic uri:@"mobile/fault_task/urging" result:^(BResponseModel * _Nonnull respModel) {
                                if (respModel.success) {
                                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                                    
                                    [ws.guzhangDataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                    [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                    
                                }else{
                                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                                }
                            }];
                        }];
                        [alert addAction:cancelAction];
                        [alert addAction:okAction];
                        [ws presentViewController:alert animated:YES completion:nil];
                    }
                    break;
                case 4:
                {
                    NSLog(@"任务指派,%@",x);
                    
                    
                    NSMutableArray*statusArr = [NSMutableArray array];
                    for (NSDictionary*user in  miss[@"userChoice"]) {
                        [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
                    }
                    
                    MarkAlert *al = [[MarkAlert alloc] initWithPayAction:@"请选择要指派的人员" action:statusArr result:^(NSArray *arr) {
                        
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
                        NSString *names = [nameArr componentsJoinedByString:@","];

                        NSLog(@"%@ --- %@",ids,names);
                        
                        [requestHelper stop];
                        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                        [parmDic setObject:miss[@"id"] forKey:@"faultTaskId"];
                        [parmDic setObject:ids forKey:@"userIds"];
                        [parmDic setObject:names forKey:@"userNames"];

                        requestHelper.needShowHud =@1;
                        [requestHelper startRequest:parmDic uri:@"mobile/fault_task/appoint" result:^(BResponseModel * _Nonnull respModel) {
                            if (respModel.success) {
                                [SVProgressHUD showSuccessWithStatus:respModel.message];
                                
                                [ws.guzhangDataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                
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
                    NSLog(@"任务接单,%@",x);

                    [requestHelper stop];
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:miss[@"id"] forKey:@"faultTaskId"];
          
                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/fault_task/assignee" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [ws.guzhangDataArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                            [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                    }];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"分任务,%@",x);
                   
                }
                    break;
                    
                case 1:
                {
                    NSLog(@"任务处理,%@",x);

                    GZChuliViewController*vc = [[GZChuliViewController alloc] initWithMission:miss];
                    PUSHNAVICONTROLLER(vc);
                }
                    break;
                    
                case 0:
                {
                    NSLog(@"任务详情,%@",x);

                    GZDetailViewController *vc = [[GZDetailViewController alloc] initWithStationId:miss];
                    PUSHNAVICONTROLLER(vc);
                }
                    break;
                default:
                    break;
            }
            NSLog(@"xxx,%@",x);
        }];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (currentSelect == 0) {
        AlarmsDetailViewController *vc = [[AlarmsDetailViewController alloc] initWithStationId:self.dataArr[indexPath.row]];
        PUSHNAVICONTROLLER(vc);
    }else{
        GZDetailViewController *vc = [[GZDetailViewController alloc] initWithStationId:self.guzhangDataArr[indexPath.row]];
        PUSHNAVICONTROLLER(vc);
    }

}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 0) {
        orga = TOSTRING(array[0][@"id"]);
        [button0 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button0];
        [self getStation];
        
        station = @"";
        [button1 setTitle:@"项目电站" forState:UIControlStateNormal];
        [self reSetBtn:button1];
        
        [mainTableV.mj_header beginRefreshing];

    }else if (v.tag == 1){
        
        station = TOSTRING(array[0][@"id"]);

        [button1 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button1];
        [mainTableV.mj_header beginRefreshing];
        
      
    }else if (v.tag == 2){
        if (currentSelect == 0) {
            levelname = array[0][@"name"];
            level = TOSTRING(array[0][@"value"]);
        }else{
            guzhanglevelname = array[0][@"name"];
            guzhanglevel  = TOSTRING(array[0][@"id"]);
        }
        
        [button2 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button2];
        [mainTableV.mj_header beginRefreshing];
    }
    
}


@end
