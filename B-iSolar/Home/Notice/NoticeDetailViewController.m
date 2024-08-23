//
//  NoticeDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDetailTableViewCell.h"
#import "FileDetailViewController.h"
#import "NoticeTTableViewCell.h"

@interface NoticeDetailViewController ()
{
    NSDictionary *noticeDic;
    UITableView *mainTableV;
}

@end

@implementation NoticeDetailViewController
@synthesize mainTableV;

- (id)initWithNotice:(NSDictionary *)notice
{
    if (self = [super init]) {
        self.title = notice[@"title"];
        noticeDic = [[NSDictionary alloc] initWithDictionary:notice];
    }
    return self;
}
- (id)initWithNotice:(NSDictionary *)notice andType:(NSInteger)ty{
    if (self = [super init]) {
        type = ty;
        
        
        self.title = notice[@"title"];
        
        if (type == 1) {
            self.title = @"任务通知";
        }else        if (type == 2){
            self.title = @"待办通知";
        }else if (type == 4){
            self.title = @"系统通知详情";
        }
        noticeDic = [[NSDictionary alloc] initWithDictionary:notice];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mainTableV.backgroundColor = [UIColor clearColor];
    weak_self(ws);
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeDetailTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeTTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTTableViewCell"];

    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 0;
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];

    // Do any additional setup after loading the view from its nib.m  announcementId
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    weak_self(ws);
    requestHelper.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    parmDic[@"id"] = noticeDic[@"id"];
    ////公告详情announcement  计划任务taskManage        故障alarmMonitor
    // toolUtensil
    // type = 2   时 todo =0 文档 document// 1隐患 hiddenDanger;   2//toolUtensil 工器具;
    [requestHelper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ object:noticeDic[@"id"]];
            ws.dataModel = respModel;
            [ws.mainTableV.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV reloadData];
    }];
}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type == 1) {
        
        NSDictionary * dic = dataModel.data[@"taskManage"];
        NSString *desc = @"";
        switch (indexPath.row) {
            case 0:
                desc = dic[@"soName"];
                break;
            case 1:
                desc = dic[@"name"];
            break;
            case 2:
                desc = dic[@"typeName"];
            break;
            case 3:
                desc = dic[@"completeTime"];
            break;
            case 4:
                desc = dic[@"detail"];
            break;
            case 5:
                desc = dic[@"outTypeName"];
            break;
                
            default:
                break;
        }
        CGFloat width = MAINSCREENWIDTH-30;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = [UIFont systemFontOfSize:15];
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        return labelsize.height + 54 ;
    }
    if (type == 2 ) {
        
        NSDictionary * dic;
        NSString *desc = @"222";

        NSInteger todo = [dataModel.data[@"todo"] integerValue];
        
        switch (todo) {
            case 0:
                {
                    dic = dataModel.data[@"document"];
                    
                    if (indexPath.row == 6) {
                        NSArray *payjson = dic[@"payJson"];
                        for (NSDictionary *p in payjson) {
                            desc = [desc stringByAppendingFormat:@"%@\n%@\n%@",p[@"payNextTime"],TOSTRING(p[@"payNextAmount"]),p[@"payNextRemindTime"]];
                        }
                    }

                }
                break;
            case 1:
            {
                dic = dataModel.data[@"hiddenDanger"];
                
                if (indexPath.row == 1) {
                    desc = dic[@"content"];
                    
                }

            }
            break;
            case 2:
            {
                dic = dataModel.data[@"toolUtensil"];
                
            }
            break;
            default:
                break;
        }
        
        CGFloat width = MAINSCREENWIDTH-30;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = [UIFont systemFontOfSize:15];
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        return labelsize.height + 54 ;
    }
    
    if (type == 4) {
        
        NSString *desc = @"222";

        if (indexPath.row == 3) {
            desc = dataModel.data[@"content"];
        }
        
        CGFloat width = MAINSCREENWIDTH-30;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = [UIFont systemFontOfSize:15];
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        return labelsize.height + 54 ;
    }
    
    if(indexPath.section == 0)
    {
        NSString *desc =   dataModel.data[@"content"];
        CGFloat width = MAINSCREENWIDTH-5*4;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        return labelsize.height + 44 + 70 + 38 * [dataModel.data[@"attachementsList"] count];
    }
    return 44;
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
    if (dataModel) {
        if (type == 1) {
            return 6;
        }
        if (type == 4) {
            
            NSInteger todo = [dataModel.data[@"todo"] integerValue];
            
            switch (todo) {
                case 1:
                    return 4;
                       
                    break;
               
                default:
                    break;
            }
            return 1;
        }
        if (type == 2 ) {
            NSInteger todo = [dataModel.data[@"todo"] integerValue];

            switch (todo) {
                case 0:
                    return 7;
                       
                    break;
                case 1:
                    return 5;
                case 2:
                    return 4;
                default:
                    break;
            }
            
        }
        
        
        
        if (section==0) {
            return 1;
        }else{
            return [dataModel.data[@"attachementsList"] count];
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type == 1) {
        NoticeTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTTableViewCell"];

        NSDictionary * dic = dataModel.data[@"taskManage"];
        
        switch (indexPath.row) {
            case 0:
                [cell setName:@"实施组织" detail:dic[@"soName"]];
                break;
            case 1:
                [cell setName:@"任务名称" detail:dic[@"name"]];
                break;
            case 2:
                [cell setName:@"工作类型" detail:dic[@"typeName"]];
                break;

            case 3:
                [cell setName:@"截止日期" detail:dic[@"completeTime"]];
                break;

            case 4:
                [cell setName:@"详情描述" detail:dic[@"detail"]];
                break;

            case 5:
                [cell setName:@"输出形式" detail:dic[@"outTypeName"]];
                break;
                
            
            default:
                break;
        }
        return cell;
        
        
    }else   if (type == 2 ){
        NoticeTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTTableViewCell"];
/// 1隐患 hiddenDanger;   2//toolUtensil 工器具;
        NSInteger todo = [dataModel.data[@"todo"] integerValue];
        if (todo == 0) {
            NSDictionary * dic = dataModel.data[@"document"];
            switch (indexPath.row) {
                       case 0:
                           [cell setName:@"项目公司" detail:dic[@"orgaName"]];
                    [cell setTagName:@"待办合同"];
                           break;
                       case 1:
                           [cell setName:@"项目电站" detail:dic[@"staName"]];
                           break;
                       case 2:
                           [cell setName:@"文档名称" detail:dic[@"name"]];
                           break;

                       case 3:
                           [cell setName:@"文档类型" detail:dic[@"type"]];
                           break;

                       case 4:
                           [cell setName:@"截止时间" detail:dic[@"paymentTime"]];
                           break;

                       case 5:
                           [cell setName:@"支付金额（元）" detail:TOSTRING(dic[@"paymentAmount"])];
                           break;
                           
                       case 6:
                {
                    NSString *desc = @"";
                    NSArray *payjson = dic[@"payJson"];
                    for (NSDictionary *p in payjson) {
                        desc = [desc stringByAppendingFormat:@"支付时间：%@\n支付金额（元）：%@\n系统通知时间：%@",p[@"payNextTime"],TOSTRING(p[@"payNextAmount"]),p[@"payNextRemindTime"]];
                    }
                     [cell setName:@"下次支付信息" detail:desc];
                }
        
                           
                       break;
                       default:
                           break;
                   }
                   return cell;
            
            
            
        }else if (todo == 1){
            NSDictionary * dic = dataModel.data[@"hiddenDanger"];
                    switch (indexPath.row) {
                               case 0:
                                   [cell setName:@"项目电站" detail:dic[@"staName"]];
                                   [cell setTagName:@"隐患排查"];
                                   break;
                               case 1:
                                   [cell setName:@"隐患内容" detail:dic[@"content"]];
                                   break;
                               case 2:
                                   [cell setName:@"隐患类型" detail:dic[@"typeName"]];
                                   break;

                               case 3:
                                   [cell setName:@"发现时间" detail:dic[@"findDate"]];
                                   break;

                               case 4:
                                   [cell setName:@"整改期限" detail:dic[@"modificationDate"]];
                                   break;

                              
                               default:
                                   break;
                           }
                           return cell;
            
        
        }else if (todo == 2 || type == 4){
            NSDictionary * dic = dataModel.data[@"toolUtensil"];
                switch (indexPath.row) {
                           case 0:
                               [cell setName:@"项目电站" detail:dic[@"staName"]];
                               [cell setTagName:@"工器具检查"];
                               break;
                           case 1:
                               [cell setName:@"工器具名称" detail:dic[@"toolName"]];
                               break;
                           case 2:
                               [cell setName:@"检查周期" detail:dic[@"durant"]];
                               break;

                           case 3:
                               [cell setName:@"提醒日期" detail:dic[@"remindDate"]];
                               break;

                          
                           default:
                               break;
                       }
                       return cell;
        }
        
        
           
            
    }else if (type == 4) {
        NoticeTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTTableViewCell"];

        NSDictionary * dic = dataModel.data;
        
        switch (indexPath.row) {
            case 0:
                [cell setName:@"项目公司" detail:dic[@"orgName"]];
                [cell setTagName:@"提示信息"];
                break;
            case 1:
                [cell setName:@"项目电站" detail:dic[@"staName"]];
                break;
            case 2:
                [cell setName:@"提醒时间" detail:dic[@"releaseTime"]];
                break;

            case 3:
                [cell setName:@"内容描述" detail:dic[@"content"]];
                break;

            
            default:
                break;
        }
        return cell;
        
        
    }
    
    
    NoticeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeDetailTableViewCell"];
    [cell setData:dataModel.data];
    weak_self(ws);
    cell.attClick = ^(int index){
        NSDictionary *file = ws.dataModel.data[@"attachementsList"][index];
        
        FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:API_FILE_URL(file[@"filePath"])];
        [ws.navigationController pushViewController:v animated:YES];
        
//        [SVProgressHUD showErrorWithStatus:file[@"name"]];
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *alarm = self.dataArr[indexPath.row];
//    NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:alarm];
//    PUSHNAVICONTROLLER(vc);
    
    //    FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:@"http://bisolar.boeet.com.cn:88/djangoUpload/stationFile/134/design.png"];
    
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
