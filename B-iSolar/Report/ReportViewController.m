//
//  ReportViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/24.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import "ZYSpreadSubButton.h"
#import "ReportDetailViewController.h"
#import "ProDetailViewController.h"
#import "ReportSunsortViewController.h"

@interface ReportViewController ()
{
    BOOL expand;
}
@end

@implementation ReportViewController
@synthesize mainTableV;
@synthesize dataModel;
@synthesize pickerV;
@synthesize selectTime;
@synthesize hideSectionArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = String(@"日报");
    expand = NO;
    hideSectionArr = [[NSMutableArray alloc] init];
    weak_self(ws);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNoti:) name:NOTIFICATION_LOGIN object:nil];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportTableViewCell"];
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.hideSectionArr removeAllObjects];
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    UIImage *btnBg = [UIImage imageNamed:@"plus"];
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    
    zButton = [[ZYSpreadButton alloc] initWithBackgroundImage:btnBg highlightImage:nil position:CGPointMake(10 + btnBg.size.width/2,  MAINSCREENHEIGHT-200)];
    zButton.positionMode = SpreadPositionModeTouchBorder;
    ZYSpreadSubButton *detailBtn = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchdetail"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        
        
        ProDetailViewController *vc = [[ProDetailViewController alloc] initWithDate:selectTime];
        
        PUSHNAVICONTROLLER(vc);
        
    }];
    
    ZYSpreadSubButton *detailBtn1 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchStation"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws.pickerV setType:PickerTypeTwo andTag:2 andDatas:ws.dataModel.data[@"list"]];
        ws.pickerV.hiddenCustomPicker = NO;
    }];
    
    ZYSpreadSubButton *detailBtn2 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchOrg"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws.pickerV setType:PickerTypeOne andTag:1 andDatas:ws.dataModel.data[@"list"]];
        ws.pickerV.hiddenCustomPicker = NO;
    }];
    ZYSpreadSubButton *detailBtn3 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"sunsort"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws sunSort];
//        [ws selectDate];
    }];
    
    [zButton setSubButtons:@[detailBtn,detailBtn1,detailBtn2,detailBtn3]];
    [zButton setButtonDidSpreadBlock:^(ZYSpreadButton *spreadButton) {
    }];
    [zButton setButtonWillSpreadBlock:^(ZYSpreadButton *spreadButton) {
        
    }];
    [zButton setButtonWillCloseBlock:^(ZYSpreadButton *spreadButton) {
        
    }];
    [zButton setButtonDidCloseBlock:^(ZYSpreadButton *spreadButton) {
        
    }];
    [self.view addSubview:zButton];
    zButton.cover.frame = CGRectMake(0, 0, 1000, 1000);
    zButton.spreadAngle = 90;
    zButton.direction = SpreadDirectionRightUp;
    
   
}
- (void)loginNoti:(id)noti{
    [mainTableV.mj_header beginRefreshing];
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
    [apiBlock startRequest:parmDic uri:API_REPORT result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            
            ws.dataModel = respModel;
            ws.selectTime = ws.dataModel.data[@"selectTime"];
            
            ws.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:ws.selectTime style:UIBarButtonItemStyleDone target:ws action:@selector(selectDate)];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        
        expand = NO;
        for (int i = 0; i< [ws.dataModel.data[@"list"] count];i++)
        {
            [ws.hideSectionArr addObject:@(i)];
        }
        ws.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"展开" style:UIBarButtonItemStyleDone target:ws action:@selector(expand:)];
        
        [ws.mainTableV reloadData];
    }];
}


- (void)reloadV{
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)expand:(id)sender{
    expand = !expand;
    
    if (expand){
        [hideSectionArr removeAllObjects];
        [sender setTitle:@"收起"];
    }else{
        [sender setTitle:@"展开"];
        for (int i = 0; i< [dataModel.data[@"list"] count];i++)
        {
            [hideSectionArr addObject:@(i)];
        }
    }
    [self.mainTableV reloadData];
}

- (void)sunSort{
    ReportSunsortViewController * vc = [[ReportSunsortViewController alloc] initWithSelectTime:selectTime];
    PUSHNAVICONTROLLER(vc)
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
    NSArray *arr = dataModel.data[@"list"];
    return arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = dataModel.data[@"list"];
    return (([hideSectionArr containsObject:@(section)])?0:[arr[section][@"list"] count]) + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportTableViewCell"];
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section];
    NSArray *stationArr = orgnization[@"list"];
    
    if (indexPath.row == 0 ) {
        [cell setData:orgnization andIsStation:NO];        
    }else{
        [cell setData:stationArr[indexPath.row-1] andIsStation:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section];
    NSArray *stationArr = orgnization[@"list"];
    
    if (indexPath.row == 0) {
        NSMutableArray *stationIndexArr = [[NSMutableArray alloc] init];
        for (int i =0 ; i<stationArr.count; i++) {
            [stationIndexArr addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
        }
        
        if ([hideSectionArr containsObject:@(indexPath.section)]){
            [hideSectionArr removeObject:@(indexPath.section)];
            [tableView insertRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [hideSectionArr addObject:@(indexPath.section)];
            
            [tableView deleteRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }else{
        NSDictionary *station =stationArr[indexPath.row-1];
        ReportDetailViewController *vc = [[ReportDetailViewController alloc] initWithStation:station andDate:selectTime];
        
        PUSHNAVICONTROLLER(vc);
    }
}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 1) {
        [mainTableV scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (v.tag == 2){
        
        if ([hideSectionArr containsObject:@(indexpath.section)]){
            NSDictionary *orgnization = dataModel.data[@"list"][indexpath.section];
            NSArray *stationArr = orgnization[@"list"];
            
            NSMutableArray *stationIndexArr = [[NSMutableArray alloc] init];
            for (int i =0 ; i<stationArr.count; i++) {
                [stationIndexArr addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexpath.section]];
            }
            [hideSectionArr removeObject:@(indexpath.section)];
            [mainTableV insertRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
        [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath.row+1 inSection:indexpath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }else if (v.tag == 3){
        selectTime = [array componentsJoinedByString:@"-"];
        [mainTableV.mj_header beginRefreshing];
    }
    
}

@end
