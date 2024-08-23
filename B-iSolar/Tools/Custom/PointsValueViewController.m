//
//  PointsValueViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/18.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "PointsValueViewController.h"
#import "PointTableViewCell.h"
#import "PointLinesCell.h"
@interface PointsValueViewController ()
{
    NSString *pointID,*stationID;
}
@end

@implementation PointsValueViewController
@synthesize mainTableV;
@synthesize pickerV;
@synthesize selectTime;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"设备实时数据";

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    mainTableV.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    weak_self(ws);
    
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    
    
    [self.mainTableV.mj_header beginRefreshing];
    [mainTableV registerNib:[UINib nibWithNibName:@"PointLinesCell" bundle:nil] forCellReuseIdentifier:@"PointLinesCell"];

    
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithStationID:(NSString *)str1 andPointID:(NSString*)str2{
    if (self=[super init]) {
        stationID = TOSTRING(str1);
        pointID = TOSTRING(str2);
    }
    return self;
}



- (void)selectDate{
    [self.pickerV setType:PickerTypeYYYYMMDD andTag:3 andDatas:nil];
    
    if (self.selectTime) {
        [self.pickerV setCurrentY:[[self.selectTime componentsSeparatedByString:@"-"][0] integerValue] M:[[self.selectTime componentsSeparatedByString:@"-"][1] integerValue] D:[[self.selectTime componentsSeparatedByString:@"-"][2] integerValue]];
    }
    self.pickerV.hiddenCustomPicker = NO;
}




- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    [mainTableV registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointTableViewCell"];


    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    parmDic[@"pointId"] = pointID;
    parmDic[@"stationId"] = stationID;
    if (selectTime) {
        parmDic[@"date_s"] = selectTime;
    }


    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:@"mobile/monitor_points_value" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;

            ws.selectTime = TOSTRING(ws.dataModel.data[@"date_s"]);
            
            ws.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:ws.selectTime style:UIBarButtonItemStyleDone target:ws action:@selector(selectDate)];
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        if([ws.mainTableV.mj_header isRefreshing])
            [ws.mainTableV.mj_header endRefreshing];
        if([ws.mainTableV.mj_footer isRefreshing])
            [ws.mainTableV.mj_footer endRefreshing];
        [ws.mainTableV reloadData];
    }];
        
 
    
}


#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 265-44;
    }
    return 30;
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
    if (!dataModel) {
        return 0;
    }
    NSArray *arr = dataModel.data[@"list"];
    return arr.count + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        PointLinesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PointLinesCell"];

        NSDictionary *data = dataModel.data;
        [cell setData:data];

        return cell;
    }else{
        NSDictionary *data = dataModel.data[@"list"][indexPath.row-1];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TOSTRING(@(indexPath.row))];

    //    PointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];

        cell.textLabel.text = TOSTRING(data[@"t"]);
        cell.detailTextLabel.text =  TOSTRING(data[@"v"]);

        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    
    selectTime = [array componentsJoinedByString:@"-"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:selectTime style:UIBarButtonItemStyleDone target:self action:@selector(selectDate)];
    [mainTableV.mj_header beginRefreshing];
    
}



@end
