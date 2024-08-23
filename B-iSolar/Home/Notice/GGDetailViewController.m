//
//  GGDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "GGDetailViewController.h"
#import "GGTableViewCell.h"
#import "GGFilesTableViewCell.h"
#import "FileDetailViewController.h"
@interface GGDetailViewController ()
{
    NSDictionary *noticeDic;

    IBOutlet UIControl *bgV;
    
    IBOutlet UIButton *moreBtn;
}

- (IBAction)bgClick:(id)sender;
@end

@implementation GGDetailViewController
@synthesize mainTableV;

- (id)initWithNotice:(NSDictionary *)notice andType:(NSInteger)ty{
    if (self = [super init]) {
           type = ty;
           noticeDic = [[NSDictionary alloc] initWithDictionary:notice];
       }
       return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = String(@"公告通知详情");
    [mainTableV registerNib:[UINib nibWithNibName:@"GGTableViewCell" bundle:nil] forCellReuseIdentifier:@"GGTableViewCell"];
    [filesTableV registerNib:[UINib nibWithNibName:@"GGFilesTableViewCell" bundle:nil] forCellReuseIdentifier:@"GGFilesTableViewCell"];
    filesTableV.separatorStyle = UITableViewCellSelectionStyleNone;
    filesTableV.userInteractionEnabled = YES;
    
    weak_self(ws)
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
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
    [requestHelper startRequest:parmDic uri:API_NOTICE_DETAIL result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ object:noticeDic[@"id"]];
            
            ws.dataModel = respModel;
            NSInteger count = [ws.dataModel.data[@"announcement"][@"attachementsList"] count] ;
            if (count > 0) {
                bottomCon.constant = 80;
                filesTableHeght.constant = 60;
                [filesTableV reloadData];
                
//                moreBtn.hidden = (count == 1);
                if (count == 1) {
                    [moreBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
                }
            }
            [ws.mainTableV.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        
        [ws.mainTableV reloadData];
    }];
}


#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == filesTableV) {
        return 60;
    }
    NSString *desc =   dataModel.data[@"content"];
    NSString *title =   dataModel.data[@"title"];
    CGFloat width = MAINSCREENWIDTH-24;

    UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
    _atest.numberOfLines = 0;
    _atest.text = desc;
    _atest.lineBreakMode = NSLineBreakByWordWrapping;
    _atest.font = [UIFont systemFontOfSize:17];
    CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize labelsize = [_atest sizeThatFits:baseSize];

    _atest.text = title;
    CGSize labelsize2 = [_atest sizeThatFits:baseSize];

    return labelsize.height + 100 + labelsize2.height ;
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
    if (tableView == filesTableV) {
        if (dataModel) {
           NSInteger count = [self.dataModel.data[@"announcement"][@"attachementsList"] count] ;
            return count;
        }
    }
    if (dataModel) {
       return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == mainTableV) {
        GGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGTableViewCell"];
        [cell setData:self.dataModel.data[@"announcement"]];
        return cell;
    }else{
        NSArray* attachementsList = self.dataModel.data[@"announcement"][@"attachementsList"];
        weak_self(ws);
        GGFilesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGFilesTableViewCell"];
        [cell setData:attachementsList[indexPath.row]];
        cell.attClick = ^(NSDictionary * _Nonnull data) {
            [ws openFile:data[@"filePath"]];
        };
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == filesTableV) {
        NSArray* attachementsList = self.dataModel.data[@"announcement"][@"attachementsList"];
        NSDictionary *file = attachementsList[indexPath.row];

        FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:API_FILE_URL(file[@"filePath"])];
        [self.navigationController pushViewController:v animated:YES];
    }
}

- (void)openFile:(NSString *)path{
    FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:API_URL(path)];
       [self.navigationController pushViewController:v animated:YES];
}



- (IBAction)fileClick:(id)sender {
    NSArray* attachementsList = self.dataModel.data[@"announcement"][@"attachementsList"];
    NSDictionary *file = attachementsList[0];
    [self openFile:file[@"filePath"]];
       
}

- (IBAction)bgClick:(id)sender {
    moreBtn.tag = 0;
    
    filesTableHeght.constant = 60;
    [moreBtn setImage:[UIImage imageNamed:@"icon_rise-1"] forState:UIControlStateNormal];

    [filesTableV reloadData];
    bgV.hidden = YES;
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    
    if (sender.tag == 0) {
        sender.tag = 1;
        NSInteger maxCount = MAINSCREENHEIGHT /60 / 2;
        NSInteger count = [self.dataModel.data[@"announcement"][@"attachementsList"] count] ;

        filesTableHeght.constant = MIN(count, maxCount) * 60;
        [moreBtn setImage:[UIImage imageNamed:@"icon_rise(1)"] forState:UIControlStateNormal];

        if(count==1){
           [self fileClick:nil];
           return;
        }
        [filesTableV reloadData];
        bgV.hidden = NO;
    }else{
        sender.tag = 0;
       filesTableHeght.constant = 60;
       [moreBtn setImage:[UIImage imageNamed:@"icon_rise-1"] forState:UIControlStateNormal];
  
       [filesTableV reloadData];
       bgV.hidden = YES;
    }
   
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
