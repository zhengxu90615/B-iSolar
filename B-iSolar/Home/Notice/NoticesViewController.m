//
//  NoticesViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "NoticesViewController.h"
#import "NoticeTableViewCell.h"
#import "AlarmsDetailViewController.h"
#import "NoticeDetailViewController.h"
#import "GGDetailViewController.h"
#import "MissionDetailViewController.h"

@interface NoticesViewController ()
{
    int type;
}
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation NoticesViewController
- (instancetype)initWithType:(int)typ{
    if (self = [super init]) {
        type = typ;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    weak_self(ws);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(read:) name:NOTIFICATION_READ object:nil];

    
    mainTableV.backgroundColor = [UIColor clearColor];
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
    
    switch (type) {
        case 0:
            self.title = String(@"公告通知");
            break;
        case 1:
            self.title = String(@"任务通知");
        break;
        case 2:
            self.title = String(@"待办通知");
        break;
        case 3:
            self.title = String(@"故障通知");
        break;
        case 4:
            self.title = String(@"系统通知");
        break;
        default:
            break;
    }
    _dataArr = [[NSMutableArray alloc] init];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex = 0;
            [ws getData:nil];
    }];
    
     self.mainTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];

    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    weak_self(ws);
    requestHelper.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    parmDic[@"pageindex"] = @(pageIndex);
    parmDic[@"type"] = @(type);

    [requestHelper startRequest:parmDic uri:API_NOTICE_LIST result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            if (respModel.pageindex == 0) {
                [ws.dataArr removeAllObjects];
                [ws.mainTableV.mj_header endRefreshing];
                [ws.mainTableV.mj_footer resetNoMoreData];
            }else{
                [ws.mainTableV.mj_footer endRefreshing];
            }
            if ([respModel.data count] < respModel.pagenum) {
                [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
            }
            
            [ws.dataArr addObjectsFromArray:respModel.data];
            ws.pageIndex = respModel.pageindex+1;
        }else{
            if (respModel.pageindex == 0) {
                [ws.mainTableV.mj_header endRefreshing];
            }else{
                [ws.mainTableV.mj_footer endRefreshing];
            }

            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        
        [ws.mainTableV reloadData];
    }];
}

- (void)read:(NSNotification *)noti{
    NSString *notiID = noti.object;
    [self setReadNoti:[notiID integerValue]];
}

- (void)setReadNoti:(NSInteger)nid{
    for (int i =0; i< self.dataArr.count; i++) {
        NSDictionary *dic =self.dataArr[i];
        if ([dic[@"id"] intValue] == nid) {
            NSMutableDictionary *mud = [[NSMutableDictionary alloc] initWithDictionary:dic];
            mud[@"isRead"] = @(1);
            self.dataArr[i] = mud;
            [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:i]] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }
}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *alarm = self.dataArr[indexPath.section];

    NSString *desc = alarm[@"content"];
    CGFloat width = MAINSCREENWIDTH-40;
    
    UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
    _atest.numberOfLines = 0;
    _atest.text = desc;
    _atest.lineBreakMode = NSLineBreakByWordWrapping;
    _atest.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize labelsize = [_atest sizeThatFits:baseSize];
    return ( labelsize.height > 60 ? 60 :  labelsize.height) + 33.5 + 39.5 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == (self.dataArr.count-1) ? 10 : .1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *alarm = self.dataArr[indexPath.section];
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
    [cell setData:alarm];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (type) {
        case 0:
            {
               NSDictionary *notice = self.dataArr[indexPath.section];
               GGDetailViewController *vc = [[GGDetailViewController alloc] initWithNotice:notice andType:type];
               PUSHNAVICONTROLLER(vc);
            }
            break;
        
        case 1:
            {
                NSDictionary *notice = self.dataArr[indexPath.section];
                if ([TOSTRING(notice[@"todo"]) isEqualToString:@"6"] ) {
                    MissionDetailViewController*vc= [[MissionDetailViewController alloc] initWithNoti:notice];
                    PUSHNAVICONTROLLER(vc);
                }else{
                    NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                    PUSHNAVICONTROLLER(vc);
                }
               
            }
            break;
        
        case 2:
            {
                NSDictionary *notice = self.dataArr[indexPath.section];
                NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                PUSHNAVICONTROLLER(vc);
            }
            break;
        
        case 3://报警
            {
                NSDictionary *notice = self.dataArr[indexPath.section];
                weak_self(ws);
                requestHelper.needShowHud =@0;
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                parmDic[@"id"] = notice[@"id"];
                ////公告详情announcement  计划任务taskManage        故障alarmMonitor
                [requestHelper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
                    
                    if (respModel.success) {
                        [ws setReadNoti:[ notice[@"id"] integerValue]];
                    }else{
                    }
                }];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic[@"id"] = notice[@"contentId"];
                AlarmsDetailViewController *vc = [[AlarmsDetailViewController alloc] initWithStationId:dic];
                PUSHNAVICONTROLLER(vc);
            }
            break;
        case 4:
            {
                
//                NSDictionary *notice = self.dataArr[indexPath.section];
//                GGDetailViewController *vc = [[GGDetailViewController alloc] initWithNotice:notice andType:type];
//                PUSHNAVICONTROLLER(vc);
                
                
                NSDictionary *notice = self.dataArr[indexPath.section];
                NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] initWithNotice:notice andType:type];
                PUSHNAVICONTROLLER(vc);
            }
            break;
        default:
        {
            NSDictionary *notice = self.dataArr[indexPath.section];
            GGDetailViewController *vc = [[GGDetailViewController alloc] initWithNotice:notice andType:type];
            PUSHNAVICONTROLLER(vc);
            
            
        }
            break;
    }
   
    
   
    
    //    FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:@"http://bisolar.boeet.com.cn:88/djangoUpload/stationFile/134/design.png"];

}


@end
