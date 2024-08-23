//
//  NoticeTypeViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/21.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "NoticeTypeViewController.h"
#import "NoticeTyleTableViewCell.h"
#import "NoticesViewController.h"
#import "NoticesMissViewController.h"

@interface NoticeTypeViewController ()

@end

@implementation NoticeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    [mainTableV registerNib:[UINib nibWithNibName:@"NoticeTyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTyleTableViewCell"];

    // Do any additional setup after loading the view from its nib.
}
- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    [apiBlock startRequest:nil uri:API_NOTICE_NUM result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
    
    
   [self.mainTableV.mj_header endRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
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
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ctx['an_num'] = dataCtx['key0'] if 'key0' in dataCtx else '0'
//           ctx['pt_num'] = dataCtx['key1'] if 'key1' in dataCtx else '0'
//           ctx['re_num'] = dataCtx['key2'] if 'key2' in dataCtx else '0'
//           ctx['al_num'] = dataCtx['key3'] if 'key3' in dataCtx else '0'
//           ctx['all_num'] = str(int(ctx['an_n
//
    NoticeTyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTyleTableViewCell"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (indexPath.row == 0) {
        dic[@"img"] = @"icon_message_a";
        dic[@"name"] = @"公告通知";
        dic[@"num"] = dataModel?dataModel.data[@"an_num"]:0;
    }else if (indexPath.row == 1) {
        dic[@"img"] = @"icon_message_b";
        dic[@"name"] = @"任务通知";
        dic[@"num"] = dataModel?dataModel.data[@"pt_num"]:0;
    }else if (indexPath.row == 2) {
        dic[@"img"] = @"icon_message_c";
        dic[@"name"] = @"待办通知";
        dic[@"num"] = dataModel?dataModel.data[@"re_num"]:0;
    }else if (indexPath.row == 3) {
        dic[@"img"] = @"icon_message_d";
        dic[@"name"] = @"故障通知";
        dic[@"num"] = dataModel?dataModel.data[@"al_num"]:0;
    }else if (indexPath.row == 4) {
        dic[@"img"] = @"icon_message_a";
        dic[@"name"] = @"系统通知";
        dic[@"num"] = dataModel?dataModel.data[@"sys_num"]:0;
    }
    
    [cell setData:dic];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        PUSHNAVI(NoticesMissViewController);
    }else{
        NoticesViewController *vc = [[NoticesViewController alloc] initWithType:indexPath.row];
        PUSHNAVICONTROLLER(vc)
    }
    
  
    
}

@end
