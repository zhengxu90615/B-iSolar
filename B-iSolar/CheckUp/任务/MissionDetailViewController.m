//
//  MissionDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/24.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "MissionDetailViewController.h"
#import "NoticeTTableViewCell.h"
#import "MarkAlert.h"
#import "MissionDetalCell.h"
#import "MissionDealContentCell.h"
#import "MissionFRWViewController.h"

#import "MissionChuliViewController.h"
@interface MissionDetailViewController ()
{
    NSMutableDictionary*misstionDic;
    NSString*missId;
    
    NSDictionary *notiDIc;
}

@end

@implementation MissionDetailViewController
- (id)initWithNoti:(NSDictionary*)noti
{
    if (self = [super init]) {
        notiDIc = [[NSDictionary alloc] initWithDictionary:noti];
//        missId = TOSTRING(miss[@"id"]);
//        
//        misstionDic = [[NSMutableDictionary alloc] initWithDictionary:miss];
//        
//        misstionDic[@"mission_trace_detail"] = [miss copy];
//        misstionDic[@"id"] =missId;
    }
    return self;
}




- (id)initWithMission:(NSDictionary*)miss
{
    if (self = [super init]) {
        missId = TOSTRING(miss[@"id"]);
        
        misstionDic = [[NSMutableDictionary alloc] initWithDictionary:miss];
        
        misstionDic[@"mission_trace_detail"] = [miss copy];
        misstionDic[@"id"] =missId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeTTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionDetalCell" bundle:nil] forCellReuseIdentifier:@"MissionDetalCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionDealContentCell" bundle:nil] forCellReuseIdentifier:@"MissionDealContentCell"];

    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)getData:(id)sender{

    if ([BAPIHelper getToken].length==0) {
        return;
    }
    weak_self(ws);

    if (notiDIc) {
        
        BHttpRequest *helper = [BHttpRequest new];
        helper.needShowHud =@1;
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        parmDic[@"id"] = notiDIc[@"id"];
        ////公告详情announcement  计划任务taskManage        故障alarmMonitor
        // toolUtensil
        // type = 2   时 todo =0 文档 document// 1隐患 hiddenDanger;   2//toolUtensil 工器具;
        [helper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ object:notiDIc[@"id"]];
                
                notiDIc = nil;
                
                missId = TOSTRING(respModel.data[@"missionTrace"][@"id"]);
                NSDictionary*miss = respModel.data[@"missionTrace"];
                //
                        misstionDic = [[NSMutableDictionary alloc] initWithDictionary:miss];
                //
                        misstionDic[@"mission_trace_detail"] = [miss copy];
                        misstionDic[@"id"] =missId;
                
                
                [ws getData:nil];
                
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }

        }];
        
        return;
    }
    
    
    
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    parmDic[@"missionTraceId"] = missId;

    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/detail" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            misstionDic = [[NSMutableDictionary alloc] initWithDictionary:respModel.data];
            misstionDic[@"id"] =missId;

            [ws setButton];
        }else{
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        if([ws.mainTableV.mj_header isRefreshing])
            [ws.mainTableV.mj_header endRefreshing];
        
        [ws.mainTableV reloadData];
    }];
}
- (void)buttonClick:(UIButton*)btn{
    int tag = btn.tag;
    NSLog(@"%d",tag);
    switch (tag) {
        case 6:
            {
                NSLog(@"任务zuofei,%d",tag);
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否作废该条任务？"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    [requestHelper stop];
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:missId forKey:@"missionTraceId"];
          

                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/cancel" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [self.mainTableV.mj_header beginRefreshing];

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
        case 5:
            {
                NSLog(@"任务催办,%d",tag);
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否催办该条任务？"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    [requestHelper stop];
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:missId forKey:@"missionTraceId"];
          

                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/urging" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            
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
            for (NSDictionary*user in  misstionDic[@"user_select_list"]) {
                [statusArr addObject:@{@"id":user[@"userId"], @"name":user[@"username"]}];
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayAction:@"请选择要指派的人员" action:statusArr result:^(NSArray *arr) {
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
                [parmDic setObject:missId forKey:@"missionTraceId"];
                [parmDic setObject:ids forKey:@"userIds"];
                
                requestHelper.needShowHud =@1;
                [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/appoint" result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        [SVProgressHUD showSuccessWithStatus:respModel.message];
                        
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
            [parmDic setObject:missId forKey:@"missionTraceId"];
  

            requestHelper.needShowHud =@1;
            [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/taking" result:^(BResponseModel * _Nonnull respModel) {
                if (respModel.success) {
                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                    [self.mainTableV.mj_header beginRefreshing];

                }else{
                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                }
            }];
            
        }
            break;
            
        case 2:
        {
            NSLog(@"分任务,%d",tag);
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"mission_trace_detail"]];
            dic[@"id"] = missId;
            MissionFRWViewController*vc = [[MissionFRWViewController alloc] initWithMission:dic];
            PUSHNAVICONTROLLER(vc);
        }
            break;
            
        case 1:
        {
            NSLog(@"任务处理,%d",tag);
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"mission_trace_detail"]];
            dic[@"id"] = missId;
            MissionChuliViewController *vc = [[MissionChuliViewController alloc] initWithMission:dic];
            PUSHNAVICONTROLLER(vc);
        }
            break;
       
        default:
            break;
    }
}

- (void)setButton{
    if (!buttonView) {
        mainTableV.frame = CGRectMake(mainTableV.x, mainTableV.y, mainTableV.width, mainTableV.height-74);
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
    int progressButton = [misstionDic[@"button_dict"][@"progressButton"] intValue];
    int takingButton = [misstionDic[@"button_dict"][@"takingButton"] intValue];
    int urgingButton = [misstionDic[@"button_dict"][@"urgingButton"] intValue];
    int cancelButton = [misstionDic[@"button_dict"][@"cancelButton"] intValue];

    int total = appointButton + dealButton  + progressButton  + takingButton  + urgingButton + cancelButton;
    
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
        if (progressButton) {
            [button1 setTitle:@"分任务进展" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.tag = 2;
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
            [button1 setBackgroundColor:MAIN_TINIT_COLOR];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.tag = 4;
        }
        if (urgingButton) {
            [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button1.tag = 5;
        }
        if (cancelButton) {
            [button1 setTitle:@"任务作废" forState:UIControlStateNormal];
            [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button1.tag = 6;
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
            if (progressButton) {
                [button1 setTitle:@"分任务进展" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 2;
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
                [button1 setTitle:@"任务催办" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 5;
                break;
            }
            if (cancelButton) {
                [button1 setTitle:@"任务作废" forState:UIControlStateNormal];
                [button1 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button1.tag = 6;
            }
            
        }
        if (1) {
            
            if (dealButton) {
                [button2 setTitle:@"任务处理" forState:UIControlStateNormal];
                [button2 setBackgroundColor:MAIN_TINIT_COLOR];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 1;
            }
            if (progressButton) {
                [button2 setTitle:@"分任务进展" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0x19D39B)];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 2;
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
                [button2 setTitle:@"任务催办" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
                button2.tag = 5;
            }
            if (cancelButton) {
                [button2 setTitle:@"任务作废" forState:UIControlStateNormal];
                [button2 setBackgroundColor:UIColorFromRGB0xFFFFFF(0xF73042)];
                [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button2.tag = 6;
            }
            
        }
        
        
        
        
    }else if (total == 0)
    {
        mainTableV.frame = CGRectMake(mainTableV.x, mainTableV.y, mainTableV.width, mainTableV.height+74);
        [buttonView removeFromSuperview];
        buttonView = nil;
    }
    
}


#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *str = nil;
        if (indexPath.row == 3) {
            str = misstionDic[@"mission_trace_detail"][@"missionNote"];
        }else if (indexPath.row == 6){
            str = misstionDic[@"mission_trace_detail"][@"note"];
        }
        if (str) {
            CGFloat width = MAINSCREENWIDTH-30;
            
            UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
            _atest.numberOfLines = 0;
            _atest.text = str;
            _atest.lineBreakMode = NSLineBreakByWordWrapping;
            _atest.font = [UIFont systemFontOfSize:15];
            CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
            CGSize labelsize = [_atest sizeThatFits:baseSize];
            
            return labelsize.height + 54 ;
        }else{
            return 70;
        }
    }else{
        if (indexPath.row == 0) {
            return 22;
        }
        NSMutableDictionary*dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"mission_trace_log"][indexPath.row-1]];

        CGFloat width = MAINSCREENWIDTH-20 - 90;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = dic[@"dealNote"];
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = [UIFont systemFontOfSize:15];
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        int   fileListCount = [dic[@"file_list"] count];
        int lines = fileListCount/3 + (fileListCount%3 >0 ?1:0);
        
        CGFloat picwidth = (width-20-20)/3;
        CGFloat picH = picwidth* 1.333333 ;
        return labelsize.height + 89 + lines* (picH+10);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (misstionDic[@"mission_trace_log"] && [misstionDic[@"mission_trace_log"] count]>0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 7;
    else
        return [misstionDic[@"mission_trace_log"] count] + 1;
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
    if (indexPath.section == 0) {
        NoticeTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTTableViewCell"];

        switch (indexPath.row) {
            case 0:
                {
                    [cell setName:@"任务创建人（指派人）" detail:misstionDic[@"mission_trace_detail"][@"appointUser"]];
                }
                break;
            case 1:
                {
                    [cell setName:@"任务创建时间" detail:misstionDic[@"mission_trace_detail"][@"createTime"]];
                }
                break;
            case 2:
                {
                    [cell setName:@"任务名称" detail:misstionDic[@"mission_trace_detail"][@"name"]];
                }
                break;
            case 3:
                {
                    [cell setName:@"任务描述" detail:misstionDic[@"mission_trace_detail"][@"missionNote"]];
                }
                break;
            case 4:
                {
                    [cell setName:@"任务截止完成时间" detail:misstionDic[@"mission_trace_detail"][@"endTime"]];
                }
                break;
            case 5:
                {
                    [cell setName:@"任务提醒时间" detail:misstionDic[@"mission_trace_detail"][@"remindTime"]];
                }
                break;
            case 6:
                {
                    [cell setName:@"备注" detail:misstionDic[@"mission_trace_detail"][@"note"]];
                }
                break;
            default:
                break;
        }
        
        
        return cell;
    }else{
        if (indexPath.row == 0)
        {
            MissionDetalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissionDetalCell"];
            return cell;
        }else{
            NSMutableDictionary*dic = [[NSMutableDictionary alloc] initWithDictionary:misstionDic[@"mission_trace_log"][indexPath.row-1]];

            MissionDealContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissionDealContentCell"];
            [cell setData:dic andNeedLine:YES andBlock:^(id x) {
               
                NSLog(@"查看附件");
                
            }];
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
