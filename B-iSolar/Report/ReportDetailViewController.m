//
//  ReportDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/25.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "ReportDetailTableViewCell.h"
#import "HomeTableHeaderView.h"
#import "ReportDetailChartsCell.h"
#import "ProDetailChartsViewController.h"

@interface ReportDetailViewController ()
{
    NSString *stationID;
    NSDictionary *selectDic;
}
@end

@implementation ReportDetailViewController
@synthesize mainTableV;
@synthesize dataModel;
@synthesize pickerV;
@synthesize selectTime;

- (id)initWithStation:(NSDictionary*)stationDic andDate:(NSString *)dateString{
    if (self = [super init]) {
        selectDic = [[NSDictionary alloc] initWithDictionary:stationDic];
        stationID = [NSString stringWithFormat:@"%@",stationDic[@"id"]];
        self.title = stationDic[@"name"];
        selectTime = [[NSString alloc]initWithString:dateString];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    weak_self(ws);
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportDetailTableViewCell"];
    
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportDetailChartsCell" bundle:nil] forCellReuseIdentifier:@"ReportDetailChartsCell"];
    
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    
    
    UIImage *btnBg = [UIImage imageNamed:@"plus"];
    
    zButton = [[ZYSpreadButton alloc] initWithBackgroundImage:btnBg highlightImage:nil position:CGPointMake(10 + btnBg.size.width/2,  MAINSCREENHEIGHT-200)];
    zButton.positionMode = SpreadPositionModeTouchBorder;
    ZYSpreadSubButton *detailBtn = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"analyse"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        ProDetailChartsViewController *vc = [[ProDetailChartsViewController alloc] initWithDate:ws.selectTime andDataDic:selectDic];
        PUSHNAVICONTROLLER(vc);
    }];
    
    ZYSpreadSubButton *detailBtn3 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchDate"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws selectDate];
    }];
    
    [zButton setSubButtons:@[detailBtn,detailBtn3]];
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


- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:stationID forKey:@"stationId"];
    [parmDic setObject:selectTime forKey:@"selectTime"];

    [apiBlock startRequest:parmDic uri:API_REPORT_DETAIL result:^(BResponseModel * _Nonnull respModel) {
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


- (void)selectDate{
    [self.pickerV setType:PickerTypeYYYYMMDD andTag:3 andDatas:nil];
    
    if (self.selectTime) {
        [self.pickerV setCurrentY:[[self.selectTime componentsSeparatedByString:@"-"][0] integerValue] M:[[self.selectTime componentsSeparatedByString:@"-"][1] integerValue] D:[[self.selectTime componentsSeparatedByString:@"-"][2] integerValue]];
    }
    self.pickerV.hiddenCustomPicker = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 44*1.5;
            break;
        case 1:
        {
            return 44;
        }break;
        case 2:
            return 88*3;
        default:
            break;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataModel.data) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 5;
            break;
        default:
            break;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch (section) {
        case 0:
            return [[UIView alloc] init];
            break;
        case 1:
            title = String(@"生产日报") ;
            break;
        case 2:
            title = String(@"日负荷曲线") ;
            break;
        case 3:
            title = String(@"电站概况") ;
            break;
        default:
            break;
    }
    
    return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            {
                ReportDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportDetailTableViewCell"];
                [cell setData:dataModel.data andIndex:indexPath.row];
                return cell;
            }
            break;
        case 1:
        {
            UITableViewCell *ce = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
            ce.textLabel.textColor = COLOR_TABLE_DES;
            ce.textLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
            switch (indexPath.row) {
                case 0:
                    ce.textLabel.text = [NSString stringWithFormat:@"限电说明:%@",dataModel.data[@"limitedNote"]] ;
                    break;
                case 1:
                    ce.textLabel.text = [NSString stringWithFormat:@"运行情况记录:%@",dataModel.data[@"runningRecord"]] ;
                    break;
                case 2:
                    ce.textLabel.text = [NSString stringWithFormat:@"发电量差异分析:%@",dataModel.data[@"variationAnalysis"]] ;
                    break;
                default:
                    break;
            }
            return ce;
        }
            break;
        case 2:
        {
            ReportDetailChartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportDetailChartsCell"];
            [cell setData:dataModel];
            return cell;

        }
            break;
        case 3:
        {
            UITableViewCell *ce = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
            ce.textLabel.textColor = COLOR_TABLE_DES;
            ce.textLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
            switch (indexPath.row) {
                case 0:
                    ce.textLabel.text = [NSString stringWithFormat:@"装机容量:%@",dataModel.data[@"capacity"]] ;
                    break;
                case 1:
                    ce.textLabel.text = [NSString stringWithFormat:@"并网日期:%@",dataModel.data[@"onGridDate"]] ;
                    break;
                case 2:
                    ce.textLabel.text = [NSString stringWithFormat:@"电站业主:%@",dataModel.data[@"proprietor"]] ;
                    break;
                case 3:
                    ce.textLabel.text = [NSString stringWithFormat:@"站址:%@",dataModel.data[@"address"]] ;
                    break;
                case 4:
                    ce.textLabel.text = [NSString stringWithFormat:@"值班室电话:%@",dataModel.data[@"dutyRoomNumber"]] ;
                    break;
                default:
                    break;
            }
            return ce;
        }
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    selectTime = [array componentsJoinedByString:@"-"];
    [mainTableV.mj_header beginRefreshing];
}

@end
