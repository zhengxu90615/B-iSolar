//
//  MissionFRWViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "MissionFRWViewController.h"

#import "MissionDetailViewController.h"
#import "NoticeTTableViewCell.h"
#import "MarkAlert.h"
#import "MissionDetalCell.h"
#import "MissionDealContentCell.h"

#import "MissionChuliViewController.h"


@interface MissionFRWViewController ()
{
    NSMutableDictionary*misstionDic;
    NSString*missId;
}
@end

@implementation MissionFRWViewController


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
    self.title = @"分任务进展";
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeTTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionDetalCell" bundle:nil] forCellReuseIdentifier:@"MissionDetalCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionDealContentCell" bundle:nil] forCellReuseIdentifier:@"MissionDealContentCell"];

    
    
    // Do any additional setup after loading the view.
}

- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    parmDic[@"missionTraceId"] = missId;

    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/detail_progress" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            misstionDic = [[NSMutableDictionary alloc] initWithDictionary:respModel.data];
            misstionDic[@"id"] =missId;


        }else{
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        if([ws.mainTableV.mj_header isRefreshing])
            [ws.mainTableV.mj_header endRefreshing];
        
        [ws.mainTableV reloadData];
    }];
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
            [cell setData:dic andNeedLine:NO andBlock:^(id x) {
               
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
