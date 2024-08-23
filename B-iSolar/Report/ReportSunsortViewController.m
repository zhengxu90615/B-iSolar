//
//  ReportSunsortViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/3/10.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "ReportSunsortViewController.h"
#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import "ZYSpreadSubButton.h"
#import "ReportDetailViewController.h"
#import "ProDetailViewController.h"
#import "ReportSunsortViewController.h"
@interface ReportSunsortViewController ()

@end

@implementation ReportSunsortViewController

@synthesize mainTableV;

@synthesize pickerV;
@synthesize selectTime;
- (id)initWithSelectTime:(NSString *)dataString
{
    if (self = [super init]) {
        if (dataString)
        {
            selectTime = [[NSString alloc] initWithString:dataString];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = String(@"日报-等效小时排序");

    weak_self(ws);
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportTableViewCell"];
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
   
}
- (void)loadDataOfDay:(NSString *)dataString{
    selectTime = dataString;
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    if (selectTime) {
        [parmDic setObject:selectTime forKey:@"selectTime"];
    }
    [apiBlock startRequest:parmDic uri:API_REPORT_SUNSORT result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            
            ws.dataModel = respModel;
            ws.selectTime = ws.dataModel.data[@"selectTime"];
            
            ws.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:ws.selectTime style:UIBarButtonItemStyleDone target:ws action:@selector(selectDate)];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        

        [ws.mainTableV reloadData];
    }];
}


- (void)reloadV{
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)sunSort{
    PUSHNAVI(ReportSunsortViewController)
}

- (void)selectDate{
    [self.pickerV setType:PickerTypeYYYYMMDD andTag:3 andDatas:nil];
    
    if (self.selectTime) {
        [self.pickerV setCurrentY:[[self.selectTime componentsSeparatedByString:@"-"][0] integerValue] M:[[self.selectTime componentsSeparatedByString:@"-"][1] integerValue] D:[[self.selectTime componentsSeparatedByString:@"-"][2] integerValue]];
    }
    self.pickerV.hiddenCustomPicker = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*3;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportTableViewCell"];
    NSDictionary *data = dataModel.data[@"list"][indexPath.row];

    
//    if (indexPath.row == 0 ) {
//        [cell setData:orgnization andIsStation:NO];
//    }else{
        [cell setData:data andIsStation:YES];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSDictionary *station = dataModel.data[@"list"][indexPath.row];
    ReportDetailViewController *vc = [[ReportDetailViewController alloc] initWithStation:station andDate:selectTime];
    
    PUSHNAVICONTROLLER(vc);
    
}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 1) {
        [mainTableV scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (v.tag == 2){
        
    
        
        
        [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath.row+1 inSection:indexpath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }else if (v.tag == 3){
        selectTime = [array componentsJoinedByString:@"-"];
        [mainTableV.mj_header beginRefreshing];
    }
    
}

@end
