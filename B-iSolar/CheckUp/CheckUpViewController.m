//
//  CheckUpViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/16.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckUpViewController.h"

#import "MonitorDetailTableViewCell.h"
#import "HomeTableHeaderView.h"
#import "ReportDetailChartsCell.h"
#import "HomeTableViewCompleteCell.h"
#import "CheckUpCompleteCell.h"
#import "SelectStationHeaderView.h"
#import "CheckWorkTableViewCell.h"
#import "CheckUpDetailViewController.h"
#import "BaseTableViewController.h"
#import "Select3StationHeaderView.h"
#import "CheckTableViewCell.h"
#import "FileDetailViewController.h"
#import "CheckUpDeatailViewController.h"
#import "CheckPointsViewController.h"
#import "MissionHeaderView.h"
#import "MissionTableViewCell.h"
#import "MarkAlert.h"
#import "MissionDetailViewController.h"
#import "MissionChuliViewController.h"
#import "MissionFRWViewController.h"
#import "ZYSpreadButton.h"
#import "NewMissionViewController.h"

@interface CheckUpViewController ()
{
    NSDictionary *currentMonitor;
    IBOutlet NSLayoutConstraint *topCon;
    IBOutlet NSLayoutConstraint *tableTopCon;
    
    NSMutableArray *allMonitorArr,*allmissionArr;
    
    SelectStationHeaderView *headView;
    Select3StationHeaderView *checkHeadView;
    MissionHeaderView *missionHeadView;
    UIBarButtonItem *checkRightBtn;
    
    BOOL isMannual;
    NSMutableArray * areaArr;
    NSDictionary *currentArea, *currentStation ,*currentSelectMission;
    NSString*currentDate;
    NSInteger currentIndex;
    
    NSMutableArray *uidsArr;
    NSString*missionStatus,*missionName,*missionOnme;
    ZYSpreadButton *zButton;
    
    
    IBOutlet UIView *sepHeadView;
    
    NSString *fromFlag;
    
    NSDictionary *fromParmsDic;
}
@property(nonatomic,strong) NSMutableArray *allMonitorArr,*allmissionArr;
@end

@implementation CheckUpViewController
@synthesize sepView;
@synthesize mainTableV;
@synthesize allMonitorArr,allmissionArr;
@synthesize pickerV;

- (id)initWithAction:(int)action andParms:(NSDictionary *)pa{
    if (self = [super init]) {
     
        fromFlag = @"xxx";
        
        currentSelect = action;
        fromParmsDic = [[NSDictionary alloc] initWithDictionary:pa];
    }
    return self;
}


- (id)initWithAction:(int)action{
    if (self = [super init]) {
        //0 巡检      2 外部巡检     -1 任务
//        if (currentSelect == 2) {
//            CheckUpDeatailViewController*vc = [[CheckUpDeatailViewController alloc] initWithData:nil andEdit:YES];
//            PUSHNAVICONTROLLER(vc);
//        }else if (currentSelect == 0){
//            CheckPointsViewController*vc = [[CheckPointsViewController alloc] init];
//            PUSHNAVICONTROLLER(vc);
//        }else if (currentSelect == -1){
//            NewMissionViewController*vc = [[NewMissionViewController alloc] init];
//            PUSHNAVICONTROLLER(vc);
//        }
        
        
        fromFlag = @"xxx";
        
        currentSelect = action;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

   
    
    UIImage *btnBg = [UIImage imageNamed:@"plus"];
    zButton = [[ZYSpreadButton alloc] initWithBackgroundImage:btnBg highlightImage:nil position:CGPointMake(10 + btnBg.size.width/2,  MAINSCREENHEIGHT-200)];
    zButton.positionMode = SpreadPositionModeTouchBorder;
    [self.view addSubview:zButton];
    zButton.cover.frame = CGRectMake(0, 0, 1000, 1000);
    zButton.spreadAngle = 90;
    zButton.direction = SpreadDirectionRightUp;
    
    zButton.hidden = YES;
    
    [zButton setButtonClickBlock:^(ZYSpreadButton *spreadButton) {
//        0 巡检      2 外部巡检     -1 任务
        if (currentSelect == 2) {
            CheckUpDeatailViewController*vc = [[CheckUpDeatailViewController alloc] initWithData:nil andEdit:YES];
            PUSHNAVICONTROLLER(vc);
        }else if (currentSelect == 0){
            CheckPointsViewController*vc = [[CheckPointsViewController alloc] init];
            PUSHNAVICONTROLLER(vc);
        }else if (currentSelect == -1){
            NewMissionViewController*vc = [[NewMissionViewController alloc] init];
            PUSHNAVICONTROLLER(vc);
        }
    }];
    
   UIView *view = [[UIView alloc] init];
   view.frame = CGRectMake(0,0,MAINSCREENWIDTH,157);
   self.mainTableV.backgroundColor = [UIColor clearColor];
   // gradient
   CAGradientLayer *gl = [CAGradientLayer layer];
   gl.frame = CGRectMake(0,0,MAINSCREENWIDTH,157);
   gl.startPoint = CGPointMake(0.5, 0);
   gl.endPoint = CGPointMake(0.5, 1);
   gl.colors = @[(__bridge id)[UIColor colorWithRed:1/255.0 green:154/255.0 blue:216/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:246/255.0 green:248/255.0 blue:249/255.0 alpha:1.0].CGColor];
   gl.locations = @[@(0), @(1.0f)];
   [view.layer addSublayer:gl];
   [self.view addSubview:view];
   [self.view sendSubviewToBack:view];
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    weak_self(ws)

    NSString *title = @"当前电站";
    
    headView = [[SelectStationHeaderView alloc] initWithTitle:title andButtonClick:^(id x) {
        [ws chooseStation];
    }];
    
    checkHeadView = [[Select3StationHeaderView alloc] initWithTitle:@[@"地区",@"公司名称",@"巡检时间"] andButtonClick:^(id x) {
        [ws headCheckClick:[x intValue]];
    }];
    
    missionHeadView = [[MissionHeaderView alloc] initWithBlock:^(int index, id item) {
        NSLog(@"%d,%@",index, item);
        [missionHeadView resignFirstResp];
        if (index == 0) {
            
            NSMutableArray*statusArr = [NSMutableArray array];
            [statusArr addObject:@{@"id":@"-1", @"name":@"全部"}];
            
            for (NSDictionary*user in  ws.dataModel.data[@"missionStatusSelect"]) {
                [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
            }
            
            [self.pickerV setType:PickerTypeOne andTag:8000 andDatas:statusArr];
            self.pickerV.hiddenCustomPicker = NO;
        }else if (index==1)
        {
            missionName = TOSTRING(item);
            [ws.mainTableV.mj_header beginRefreshing];

        }else if (index==2)
        {
            NSMutableArray*statusArr = [NSMutableArray array];
            for (NSDictionary*user in  ws.dataModel.data[@"user_select_list"]) {
                [statusArr addObject:@{@"id":user[@"userId"], @"name":user[@"username"]}];
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayAction:@"请选择被指派人" action:statusArr result:^(NSArray *arr) {
                if (arr) {
                    NSLog(@"%@",arr);
                    uidsArr = [NSMutableArray array];
                    NSMutableArray *nameArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        [uidsArr addObject:dic[@"id"]];
                        [nameArr addObject:dic[@"name"]];
                    }
                    NSString *ids = [uidsArr componentsJoinedByString:@","];
                    
                    NSLog(@"%@",ids);
                    missionOnme = @"0";
                    [missionHeadView resetData:nil name:nil ids:[nameArr componentsJoinedByString:@","] onMe:@"0"];
                    [ws.mainTableV.mj_header beginRefreshing];
                }
            }];
            [al show];
        }else if (index==3)
        {
            
            [missionHeadView resetData:nil name:nil ids:@"" onMe:nil];
            missionOnme = TOSTRING(item);
            [ws.mainTableV.mj_header beginRefreshing];
            
        }
    }];
    
    if (fromParmsDic) {
        [missionHeadView setData:fromParmsDic];
        if ([fromParmsDic[@"from"] intValue] == 0) {
            [missionHeadView resetData:nil name:nil ids:nil onMe:@"1"];

        }else if ([fromParmsDic[@"from"] intValue] == 1){
            missionStatus = @"0";
            [missionHeadView resetData:@"未开始" name:nil ids:nil onMe:nil];
        }else if ([fromParmsDic[@"from"] intValue] == 2){
            missionStatus = @"1";
            [missionHeadView resetData:@"处理中" name:nil ids:nil onMe:nil];

        }

    }
    
    //    topCon.constant = 64;
//    tableTopCon.constant = -64;
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckUpCompleteCell" bundle:nil] forCellReuseIdentifier:@"CheckUpCompleteCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckWorkTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckWorkTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MissionTableViewCell"];

    [monthBtn setTitle:String(@"巡检任务") forState:UIControlStateNormal];
    [checkBtn setTitle:String(@"电站巡检") forState:UIControlStateNormal];
    [workBtn setTitle:String(@"任务管理") forState:UIControlStateNormal];

    
    checkRightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(newCheck)];
    self.navigationItem.rightBarButtonItem = checkRightBtn;
       
    sepView.frame = CGRectMake(0, 0, MAINSCREENWIDTH/3, 4);
    sepView.backgroundColor = [UIColor whiteColor];
    
    
    if (fromFlag) {
        sepHeadView.hidden = YES;
        
        switch (currentSelect) {
            case -1:
            {
                checkRightBtn.title = @"新增";
                self.title = @"任务管理";
            }
                break;
            case 2:
                self.title = @"电站巡检";
                break;
            case 0:
                self.title = @"巡检任务";
                break;
            default:
                break;
        }

        
    }else{
        self.title = String(@"工作");
        currentSelect = -1;    //   0 巡检      2 外部巡检     -1 任务
    }
    
    [workBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [workBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];

    [checkBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
    [monthBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];

    
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(isMannual)
        {
            currentArea = nil;
            currentDate = nil;
            currentStation = nil;
        }
        isMannual  = YES;
        currentIndex = 0;
        [ws.mainTableV.mj_footer resetNoMoreData];
        [ws getData:nil];
    }];
    
    
    self.mainTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [ws getData:nil];
    }];
    
    [self.mainTableV.mj_header beginRefreshing];
}



- (void)headCheckClick:(int)index
{
    if(index == 2)
    {
        [self.pickerV setType:PickerTypeYYYYMM andTag:2 andDatas:areaArr];
        [pickerV setCurrentY:[NSDate year] M:[NSDate month] D:[NSDate day]];
        self.pickerV.hiddenCustomPicker = NO;
        return;
    }
    weak_self(ws);
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    requestHelper.needShowHud =@1;
    [requestHelper startRequest:parmDic uri:API_ExternalStationApi result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            areaArr = [[NSMutableArray alloc] init];
            if (index==0)
            {
                for (NSDictionary * dic in respModel.data) {
                    if([dic[@"pId"] intValue]==0)
                    {
                        [areaArr addObject:dic];
                    }
                }
                [ws.pickerV setType:PickerTypeOne andTag:0 andDatas:areaArr];
                self.pickerV.hiddenCustomPicker = NO;
            }else{
                for (NSDictionary * dic in respModel.data) {
                    if([dic[@"pId"] intValue]==0)
                    {
                        [areaArr addObject:dic];
                    }
                }
                
                for (int i =0; i< areaArr.count;i++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:areaArr[i]];
                    NSMutableArray * tmpArr = [NSMutableArray array];
                    for (NSDictionary * tmpDic in respModel.data) {
                        if( [tmpDic[@"areaId"] intValue] == -2 &&  [tmpDic[@"pId"] intValue]==[dic[@"id"] intValue])
                        {
                            [tmpArr addObject:tmpDic];
                        }
                    }
                    dic[@"list"] = tmpArr;
                    areaArr[i] = dic;
                }
                
                [ws.pickerV setType:PickerTypeTwo andTag:1 andDatas:areaArr];
                self.pickerV.hiddenCustomPicker = NO;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}



- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    if (!self.mainTableV.mj_header.isRefreshing) {
        [self.mainTableV.mj_header beginRefreshing];
    }
}

- (void)newCheck{
    //   0 巡检      2 外部巡检     -1 任务
    if (currentSelect == 2) {
        CheckUpDeatailViewController*vc = [[CheckUpDeatailViewController alloc] initWithData:nil andEdit:YES];
        PUSHNAVICONTROLLER(vc);
    }else if (currentSelect == 0){
        CheckPointsViewController*vc = [[CheckPointsViewController alloc] init];
        PUSHNAVICONTROLLER(vc);
    }else if (currentSelect == -1){
        NewMissionViewController*vc = [[NewMissionViewController alloc] init];
        PUSHNAVICONTROLLER(vc);
    }
}

- (void)chooseStation{
    
    NSMutableArray *stationArray = [[NSMutableArray alloc] init];
    [stationArray addObject:@{@"name":@"全部电站", @"id":@"0"}];
    [stationArray addObjectsFromArray:self.dataModel.data[@"station_list"]];
    [self.pickerV setType:PickerTypeOne andTag:100 andDatas:stationArray];
    self.pickerV.hiddenCustomPicker = NO;
}

- (IBAction)sepBtnClick:(UIButton *)sender {
    weak_self(ws);
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    //   0 巡检      2 外部巡检     -1 任务
    if (sender == monthBtn) {
        self.navigationItem.rightBarButtonItem = checkRightBtn;

        [checkRightBtn setTitle:@"巡检点管理"];
        currentSelect =0;
        [checkBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [workBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [workBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];

        zButton.hidden = NO;

        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(MAINSCREENWIDTH/3, 0, MAINSCREENWIDTH/3, 4);
        }];
    }else if (sender == checkBtn){
        self.navigationItem.rightBarButtonItem = checkRightBtn;

        zButton.hidden = NO;
        [checkRightBtn setTitle:@"上传"];
        [monthBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [workBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [monthBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [workBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        dataModel = nil;
        currentSelect =2;
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(MAINSCREENWIDTH/3 * 2, 0, MAINSCREENWIDTH/3, 4);
        }];
    }else{

        zButton.hidden = NO;
        [monthBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [checkBtn setTitleColor:UIColorFromRGB0xFFFFFFA(0xFFFFFF,0.5) forState:UIControlStateNormal];
        [monthBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        dataModel = nil;
        currentSelect =-1;
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(0, 0, MAINSCREENWIDTH/3, 4);
        }];
        
    }
    
    if ([mainTableV.mj_header isRefreshing]) {
        [self getData:nil];
    }else{
        [mainTableV.mj_header beginRefreshing];
    }
}


- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    
    if(currentSelect==2){ //  外部巡检
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

        if(currentDate)
            parmDic[@"inspectionDate"] = currentDate;
        if (currentArea) {
            parmDic[@"area"] = currentArea[@"areaId"];
        }
        if (currentStation) {
            parmDic[@"name"] = currentStation[@"id"];
        }
        
        parmDic[@"pageindex"] = @(currentIndex);
        
        requestHelper.needShowHud =@0;
        [requestHelper startRequest:parmDic uri:API_ExternalApi result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                currentIndex = currentIndex + 1;
                
                [checkHeadView setTitle0:currentArea?currentArea[@"name"]:@"地区"
                                  title1:currentStation?currentStation[@"name"]:@"公司"
                                  title2:parmDic[@"inspectionDate"]?parmDic[@"inspectionDate"]:@"巡检时间"];
                
                if([ws.mainTableV.header isRefreshing])
                {
                    ws.dataModel = respModel;
                    ws.allMonitorArr = [[NSMutableArray alloc] initWithArray:ws.dataModel.data[@"list"]];
                }else{
                    
                    ws.dataModel = respModel;
                    if([ws.dataModel.data[@"list"] count] == 0)
                    {
                        [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
//                        [ws.mainTableV.mj_footer endRefreshing];
                        [ws.mainTableV reloadData];
                        return;
                    }else{
                        [ws.allMonitorArr addObjectsFromArray:ws.dataModel.data[@"list"]];
                    }
//                    ws.allMonitorArr =     [[NSMutableArray alloc] initWithArray:];
                    
                }
            }else{
                currentIndex = currentIndex -1;
                if(currentIndex == 0){
                    currentIndex = 1;
                }
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
            if([ws.mainTableV.mj_header isRefreshing])
                [ws.mainTableV.mj_header endRefreshing];
            if([ws.mainTableV.mj_footer isRefreshing])
                [ws.mainTableV.mj_footer endRefreshing];
            [ws.mainTableV reloadData];
        }];
        
        return;
    }else if (currentSelect == 0)
    {
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        if (currentMonitor && [currentMonitor[@"id"] intValue] > 0){
            [parmDic setObject:TOSTRING(currentMonitor[@"id"]) forKey:@"stationId"];
        }
        [parmDic setObject:@(currentSelect) forKey:@"check_type"];
        requestHelper.needShowHud =@0;
        [requestHelper startRequest:parmDic uri:API_CHECK_LIST result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                ws.dataModel = respModel;
                ws.allMonitorArr = [[NSMutableArray alloc] initWithArray:ws.dataModel.data[@"tableList"]];
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
            [ws.mainTableV.mj_header endRefreshing];
            [ws.mainTableV reloadData];
        }];
    }else if (currentSelect == -1)
    {
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

        if(uidsArr)
            parmDic[@"assigneeUserIds"] = [uidsArr componentsJoinedByString:@","];
        
        if (missionStatus) {
            parmDic[@"missionStatus"] = missionStatus;

        }
        if (fromParmsDic) {
            if ([fromParmsDic[@"from"] intValue]==0) {
                missionOnme = @"1";
            }
            fromParmsDic = nil;
        }
        
        if (missionOnme) {
            parmDic[@"appointMe"] = missionOnme;
        }
        if (missionName) {
            parmDic[@"missionName"] = missionName;
        }
        
        parmDic[@"pageindex"] = @(currentIndex);
        
        requestHelper.needShowHud =@0;
        [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/list" result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                currentIndex = currentIndex + 1;
                ws.dataModel = respModel;

                if([ws.mainTableV.header isRefreshing])
                {
                    ws.allmissionArr = [[NSMutableArray alloc] initWithArray: respModel.data[@"mission_trace_list"]];
                }else{
                    
                    if([ws.dataModel.data[@"mission_trace_list"] count] == 0)
                    {
                        [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
//                        [ws.mainTableV.mj_footer endRefreshing];
                        [ws.mainTableV reloadData];
                        return;
                    }else{
                        [ws.allmissionArr addObjectsFromArray:ws.dataModel.data[@"mission_trace_list"]];
                    }
                    
                }
            }else{
                currentIndex = currentIndex -1;
                if(currentIndex == 0){
                    currentIndex = 1;
                }
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
            if([ws.mainTableV.mj_header isRefreshing])
                [ws.mainTableV.mj_header endRefreshing];
            if([ws.mainTableV.mj_footer isRefreshing])
                [ws.mainTableV.mj_footer endRefreshing];
            [ws.mainTableV reloadData];
        }];
        
        
    }
    //   0 巡检      2 外部巡检     -1 任务
    
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(currentSelect==2){
        return 78;
    }
    if (currentSelect == -1) {
        NSDictionary *miss = [allmissionArr objectAtIndex:indexPath.row];

        if([miss[@"missionStatusName"] isEqualToString:@"未开始"])
            return 200 - 18 - 5;
        else
            return 200;

    }
    return 108;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currentSelect == -1) {
        return 1;
    }
    if (!dataModel){
           return 0;
    }
    if(currentSelect==2){
        return 1;
    }
    return 1;
}
    //   0 巡检      2 外部巡检     -1 任务
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(currentSelect==2){
        return [allMonitorArr count];
    }else if (currentSelect==-1)
    {
        return [allmissionArr count];
    }
    
    if (section == 0) {
//        return 1;
//    }else if (section==1){
        return [self.dataModel.data[currentSelect==2?@"list":@"mission_list"] count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (currentSelect == -1) {
//        @"user_position"      1  0 才会有指派给我   2 下面一行都没有
        if ([TOSTRING(self.dataModel.data[@"user_position"]) isEqualToString:@"2"]) {
            return 50;
        }
        return 100.0f;
    }
    return 44.0f;
//    if (section == 0){
//        return .1f;
//    }else{
//        return 44.0f;
//    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(currentSelect==2){
        if(dataModel)
            return checkHeadView;
        else
            return nil;
    }
    if(currentSelect==-1){
        if (!fromParmsDic) {
            [missionHeadView setData:self.dataModel.data];
        }
        
        return missionHeadView;
    }
//    if (section==0) {
//        return nil;
//    }
    
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (currentSelect==2) {
        NSDictionary *check = allMonitorArr[indexPath.row];

        CheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckTableViewCell"];
        [cell setData:check andButtonClick:^(id x) {
            if(![tableView.mj_header isRefreshing])
            {
                if([x intValue] == 0)
                {
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:check[@"id"] forKey:@"id"];
                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:API_ExternalDownloadApi result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            //下载文件到本地。
                            [SVProgressHUD showProgress:0];
                            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                                
                            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                            
                            NSURL *URL = [NSURL URLWithString:API_FILE_URL([respModel.data[@"url"] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
                            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                            
                            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showProgress:downloadProgress.fractionCompleted];//下载进度
                                });
                             
                            } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

                               NSString * fileName = response.suggestedFilename; //文件名
//                                    weakSelf.fileSize = [self getFileSize:response.expectedContentLength]; //文件大小
                                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName]; //文件位置
                                return url;

                            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

                                NSLog(@"%@",filePath);
                                if(error)
                                    [SVProgressHUD showErrorWithStatus:[error description]];
                                else
                                {
                                    [SVProgressHUD dismiss];
                                    FileDetailViewController *vc = [[FileDetailViewController alloc] initWithURL:filePath];
                                    PUSHNAVICONTROLLER(vc);
                                }
                               //下载完成
//                                   weakSelf.filePathURL = filePath; //文件位置
                            }];
                            [downloadTask resume];
                            
                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                       
                    }];
                    
                    
                }else if([x intValue] == 1){
                    NSDictionary *check = self.dataModel.data[@"list"][indexPath.row];

                    CheckUpDeatailViewController*vc = [[CheckUpDeatailViewController alloc] initWithData:check andEdit:YES];
                    PUSHNAVICONTROLLER(vc);
                }else{
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该条巡检报告吗？" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];

                    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                       
                        
                        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                        [parmDic setObject:check[@"id"] forKey:@"id"];
                        
                        requestHelper.needShowHud =@1;
                        [requestHelper startRequest:parmDic uri:API_ExternalDelApi result:^(BResponseModel * _Nonnull respModel) {
                            if (respModel.success) {
                                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                                [allMonitorArr removeObjectAtIndex:indexPath.row];
                                [mainTableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                
                            }else{
                               
                                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                            }
                        
                        }];
                        
                        
                        
                    }];

                    [alert addAction:cancelAction];

                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];

                    
                }
            }
        }];
        
        return cell;

    }else if (currentSelect == 0)  //巡检任务
    {
        NSDictionary *check = self.dataModel.data[@"mission_list"][indexPath.row];
        weak_self(ws)
        CheckWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckWorkTableViewCell"];
        [cell setData:check andButtonClick:^(id x) {
           
            
            if ([check[@"start_real_time"]  isEqualToString:@""]){
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

                parmDic[@"missionId"] = check[@"id"];
               
                requestHelper.needShowHud =@1;
                [requestHelper startRequest:parmDic uri:API_CHECK_START result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        
                        CheckUpDetailViewController *vC = [[CheckUpDetailViewController alloc] initWithCheck:check];
                        PUSHNAVICONTROLLER(vC);
                    }else{
                        
                    }
                }];
                
                
            }else{
                CheckUpDetailViewController *vC = [[CheckUpDetailViewController alloc] initWithCheck:check];
                PUSHNAVICONTROLLER(vC);
            }
            
            
        } andButton1Click:^(id x) {
            NSLog(@"1 click");
            
            [requestHelper stop];
            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
            [parmDic setObject:check[@"id"] forKey:@"missionId"];

            requestHelper.needShowHud =@1;
            [requestHelper startRequest:parmDic uri:API_PARTOL_USERLIST result:^(BResponseModel * _Nonnull respModel) {
                if (respModel.success) {
                    currentSelectMission = [[NSDictionary alloc] initWithDictionary:check];
                    NSMutableArray *stationArray = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary*user in  respModel.data) {
                        [stationArray addObject:@{@"missionId":check[@"id"] ,@"id":user[@"user_id"], @"name":[NSString stringWithFormat:@"%@@%@",user[@"user_name"],user[@"position"]]}];
                    }
                    
                    [self.pickerV setType:PickerTypeOne andTag:800 andDatas:stationArray];
                    self.pickerV.hiddenCustomPicker = NO;
                }else{
                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                }
               
            }];
            
            
        } andButton2Click:^(id x) {
            NSLog(@"2 click");
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定完成该巡检任务吗？"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                [requestHelper stop];
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                [parmDic setObject:check[@"id"] forKey:@"missionId"];
                [parmDic setObject:[check[@"missionJson"] mj_JSONString] forKey:@"missionJson"];
                [parmDic setObject:@"1" forKey:@"missionStatus"];

                requestHelper.needShowHud =@1;
                [requestHelper startRequest:parmDic uri:API_CHECK_SAVE result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
            
                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }
                    [ws.mainTableV.mj_header beginRefreshing];
                    [ws.mainTableV reloadData];
                }];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [ws presentViewController:alert animated:YES completion:nil];
            
            
        }];
        return cell;
    }else{
        MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissionTableViewCell"];

        NSDictionary *miss = [allmissionArr objectAtIndex:indexPath.row];
        weak_self(ws)
        [cell setData:miss andButtonClick:^(id x) {
                
            [missionHeadView resignFirstResp];
            
//            [button1 setTitle:@"任务处理" forState:UIControlStateNormal];1
//            [button1 setTitle:@"分任务进展" forState:UIControlStateNormal];2
//            [button1 setTitle:@"任务接单" forState:UIControlStateNormal];3
//            [button1 setTitle:@"任务指派" forState:UIControlStateNormal];4
//            [button1 setTitle:@"任务催办" forState:UIControlStateNormal];5
        
            switch ([x intValue]) {
                    
                case 6:
                    {
                        NSLog(@"任务作废,%@",x);
                        
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否作废该条任务？"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                            [requestHelper stop];
                            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                            [parmDic setObject:miss[@"id"] forKey:@"missionTraceId"];
                  

                            requestHelper.needShowHud =@1;
                            [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/cancel" result:^(BResponseModel * _Nonnull respModel) {
                                if (respModel.success) {
                                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                                    
                                    [allmissionArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                    [mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            
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
                    
                case 5:
                    {
                        NSLog(@"任务催办,%@",x);
                        
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否催办该条任务？"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                            [requestHelper stop];
                            NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                            [parmDic setObject:miss[@"id"] forKey:@"missionTraceId"];
                  

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
                        [ws presentViewController:alert animated:YES completion:nil];
                    }
                    break;
                case 4:
                {
                    NSLog(@"任务指派,%@",x);

                    
                    NSMutableArray*statusArr = [NSMutableArray array];
                    for (NSDictionary*user in  ws.dataModel.data[@"user_select_list"]) {
                        [statusArr addObject:@{@"id":user[@"userId"], @"name":user[@"username"]}];
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
                        
                        NSLog(@"%@",ids);
                        
                        [requestHelper stop];
                        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                        [parmDic setObject:miss[@"id"] forKey:@"missionTraceId"];
                        [parmDic setObject:ids forKey:@"userIds"];
                        
                        requestHelper.needShowHud =@1;
                        [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/appoint" result:^(BResponseModel * _Nonnull respModel) {
                            if (respModel.success) {
                                [SVProgressHUD showSuccessWithStatus:respModel.message];
                                
                                [allmissionArr replaceObjectAtIndex:indexPath.row withObject:respModel.data];
                                [mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                                
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
                    [parmDic setObject:miss[@"id"] forKey:@"missionTraceId"];
          

                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/taking" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [ws.mainTableV.mj_header beginRefreshing];

                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                    }];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"分任务,%@",x);
                    MissionFRWViewController*vc = [[MissionFRWViewController alloc] initWithMission:miss];
                    PUSHNAVICONTROLLER(vc);
                }
                    break;
                    
                case 1:
                {
                    NSLog(@"任务处理,%@",x);
                    MissionChuliViewController *vc = [[MissionChuliViewController alloc] initWithMission:miss];
                    PUSHNAVICONTROLLER(vc);
                    
                }
                    break;
                    
                case 0:
                {
                    NSLog(@"任务详情,%@",x);
                    MissionDetailViewController*vc = [[MissionDetailViewController alloc] initWithMission:miss];
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
    
    [missionHeadView resignFirstResp];
    //   0 巡检      2 外部巡检     -1 任务
    if (currentSelect==2)  //外部巡检
    {
        NSDictionary *check = allMonitorArr[indexPath.row];

        CheckUpDeatailViewController*vc = [[CheckUpDeatailViewController alloc] initWithData:check andEdit:NO];
        PUSHNAVICONTROLLER(vc);
    }else if (currentSelect == -1)
    {
        NSDictionary *miss = allmissionArr[indexPath.row];

        MissionDetailViewController*vc = [[MissionDetailViewController alloc] initWithMission:miss];
        PUSHNAVICONTROLLER(vc);
        
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

#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if(v.tag == 100)
    {
        currentMonitor = array[0];
        [headView setTitle:array[0][@"name"]];
        [self.mainTableV.mj_header beginRefreshing];
        return;
//        currentDate =
    }
   if(v.tag == 2)
   {
       currentDate = [NSString stringWithFormat:@"%@-%@",array[0],array[1]];
       isMannual = NO;
       [self.mainTableV.mj_header beginRefreshing];
   }else if (v.tag==1)
   {
       isMannual = NO;
       currentArea = array[0];
       currentStation = array[1];
       [self.mainTableV.mj_header beginRefreshing];
       
       
   }else if (v.tag==0)
   {
       isMannual = NO;
       currentArea = array[0];
       currentStation = nil;
       [self.mainTableV.mj_header beginRefreshing];

   }else if (v.tag==800){
       
       NSLog(@"%@",array);
       weak_self(ws)
       UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定指派该巡检任务给[%@]吗？",array[0][@"name"]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
           [requestHelper stop];
           NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
           [parmDic setObject:currentSelectMission[@"id"] forKey:@"missionId"];
           [parmDic setObject:[currentSelectMission[@"missionJson"] mj_JSONString] forKey:@"missionJson"];
           [parmDic setObject:@"0" forKey:@"missionStatus"];
           [parmDic setObject:array[0][@"id"] forKey:@"operatorId"];

           requestHelper.needShowHud =@1;
           [requestHelper startRequest:parmDic uri:API_CHECK_SAVE result:^(BResponseModel * _Nonnull respModel) {
               if (respModel.success) {
       
               }else{
                   [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
               }
               [ws.mainTableV.mj_header beginRefreshing];
               [ws.mainTableV reloadData];
           }];
       }];
       [alert addAction:cancelAction];
       [alert addAction:okAction];
       [ws presentViewController:alert animated:YES completion:nil];
       
       
       
       
   }else if (v.tag == 8000){
       
       missionStatus = TOSTRING(array[0][@"id"]);
       if ([missionStatus isEqualToString:@"-1"]) {
           missionStatus = nil;
       }
       [missionHeadView resetData:array[0][@"name"] name:nil ids:nil onMe:nil];
       [self.mainTableV.mj_header beginRefreshing];

   }
    
}

@end
