//
//  ProDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/26.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ProDetailChartsViewController.h"
#import "HomeTableHeaderView.h"
#import "ReportDetailCell.h"
#import "ReportDetailChartsCell.h"

@interface ProDetailChartsViewController ()
{
    NSString *stationId;
}
@end

@implementation ProDetailChartsViewController
@synthesize sepView;
@synthesize dataModel;
@synthesize pickerV;
@synthesize selectTime;
@synthesize mainTableV;

- (id)initWithDate:(NSString *)selectDateString andDataDic:(NSDictionary*)dic
{
    if (self = [super init]) {
        apiBlock = [BHttpRequest new];
        apiBlock.needShowHud =@0;
        
        if (selectDateString == nil) {
            selectDateString = [NSString stringWithFormat:@"%d-%d-1",[NSDate year],[NSDate month]];
        }
        
        self.title = dic[@"name"];
        stationId = TOSTRING(dic[@"id"]);
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[selectDateString componentsSeparatedByString:@"-"]];
        [arr removeLastObject];
        selectTime = [NSString stringWithFormat:@"%@",[arr componentsJoinedByString:@"-"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    weak_self(ws);
    sepView.frame = CGRectMake(0, 40, MAINSCREENWIDTH/2, 4);
    sepView.backgroundColor = MAIN_TINIT_COLOR;
    
    [monthBtn setTitle:String(@"按月") forState:UIControlStateNormal];
    [yearBtn setTitle:String(@"按年") forState:UIControlStateNormal];
    currentSelect = 1;
    [monthBtn setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [yearBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    

    [mainTableV registerNib:[UINib nibWithNibName:@"ReportDetailCell" bundle:nil] forCellReuseIdentifier:@"ReportDetailCell"];
//
    [mainTableV registerNib:[UINib nibWithNibName:@"ReportDetailChartsCell" bundle:nil] forCellReuseIdentifier:@"ReportDetailChartsCell"];

    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
}


- (void)getData:(id)obj{
    if ([BAPIHelper getToken].length==0) {
        return;
    }
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:selectTime style:UIBarButtonItemStyleDone target:self action:@selector(selectDate)];
    
    weak_self(ws);
    [apiBlock stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    
    [parmDic setObject:stationId forKey:@"stationId"];
    [parmDic setObject:selectTime forKey:@"selectTime"];
    [parmDic setObject:@(currentSelect) forKey:@"type"];
    
    [apiBlock startRequest:parmDic uri:API_REPORT_STATION_DETAIL_CHART result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
            ws.selectTime = ws.dataModel.data[@"selectTime"];
           
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
}


- (IBAction)sepBtnClick:(UIButton *)sender {
    weak_self(ws);
    [sender setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[selectTime componentsSeparatedByString:@"-"]];

    if (sender == monthBtn) {
        if (arr.count == 1) {
            [arr addObject:@"1"];
        }
        selectTime = [arr componentsJoinedByString:@"-"];
        currentSelect =1;
        [yearBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(0, 40, MAINSCREENWIDTH/2, 4);
        }];
    }else{
        if (arr.count == 2) {
            [arr removeLastObject];
        }
        selectTime = [arr componentsJoinedByString:@"-"];
        currentSelect =2;
        [monthBtn setTitleColor:COLOR_TABLE_TITLE forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            ws.sepView.frame = CGRectMake(MAINSCREENWIDTH/2, 40, MAINSCREENWIDTH/2, 4);
        }];
    }
    
   
    
    if ([mainTableV.mj_header isRefreshing]) {
        [self getData:nil];
    }else{
        [mainTableV.mj_header beginRefreshing];
    }
    
}

- (void)selectDate{
    if (currentSelect == 1) {
        [self.pickerV setType:PickerTypeYYYYMM andTag:3 andDatas:nil];
    }else{
        [self.pickerV setType:PickerTypeYYYY andTag:3 andDatas:nil];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[selectTime componentsSeparatedByString:@"-"]];

    if (arr.count > 0) {
        [self.pickerV setCurrentY:[arr[0] integerValue] M:arr.count>1?[arr[1] integerValue]:0 D:0];
    }
    self.pickerV.hiddenCustomPicker = NO;
}

#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    selectTime = [array componentsJoinedByString:@"-"];
    if ([mainTableV.mj_header isRefreshing]) {
        [self getData:nil];
    }else{
        [mainTableV.mj_header beginRefreshing];
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

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88*3;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataModel.data) {
        return 2 ;
    }else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return [dataModel.data[@"dataList"] count]+1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
        return 0.1f;
//    }
//    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportDetailCell"];
        [cell setDataDetailV:dataModel andIndex:indexPath andType:currentSelect];
        return cell;
    }else{
        ReportDetailChartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportDetailChartsCell"];
        [cell setData2:dataModel  andType:currentSelect];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
