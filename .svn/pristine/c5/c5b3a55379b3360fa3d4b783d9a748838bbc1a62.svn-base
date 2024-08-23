//
//  CheckPointsViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/13.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "CheckPointsViewController.h"
#import "SelectStationHeaderView.h"
#import "CheckPointCell.h"
#import "WriteNFCViewController.h"
#import "NewLocationViewController.h"
@interface CheckPointsViewController ()
{
    SelectStationHeaderView *headView;
    NSInteger currentIndex;
    NSDictionary  *currentStation ;
    NSMutableArray *allLocationArr;
    
    NSMutableArray *allStationsArr;
    
    UIBarButtonItem *checkRightBtn;
}


@end

@implementation CheckPointsViewController
@synthesize pickerV;
@synthesize mainTableV;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检点管理";
    weak_self(ws);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPointdAdded:) name:@"POINTADDED" object:nil];

    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    NSString *title = @"当前电站";
    
    checkRightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增巡检点" style:UIBarButtonItemStylePlain target:self action:@selector(newCheck)];
    self.navigationItem.rightBarButtonItem = checkRightBtn;
    
    
    headView = [[SelectStationHeaderView alloc] initWithTitle:title andButtonClick:^(id x) {
        [ws chooseStation];
        
    }];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckPointCell" bundle:nil] forCellReuseIdentifier:@"CheckPointCell"];

    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        currentIndex = 0;
        [ws.mainTableV.mj_footer resetNoMoreData];
        [ws getData:nil];
    }];
    
    
    self.mainTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [ws getData:nil];
    }];
    
    [self.mainTableV.mj_header beginRefreshing];
    
    [self getAllStationLazy];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)newPointdAdded:(id)ob{
    [mainTableV.mj_header beginRefreshing];
}

- (void)newCheck{
    if (currentStation) {
        [self.navigationController pushViewController:[[NewLocationViewController alloc] initWithStation:currentStation] animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请先选择电站！"];
    }
    
    
}

- (void)chooseStation{
    NSMutableArray *stationArray = [[NSMutableArray alloc] init];
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    if (allStationsArr) {
        [self.pickerV setType:PickerTypeOne andTag:100 andDatas:allStationsArr];
        self.pickerV.hiddenCustomPicker = NO;
    }else{
        weak_self(ws);
        [requestHelper stop];
        
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        
        parmDic[@"menuName"] = @"API_patrol_location_list";
        
        requestHelper.needShowHud =@1;
        [requestHelper startRequest:parmDic uri:API_COMM_STATION_LIST result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                
                
                [stationArray addObject:@{@"name":@"全部电站", @"id":@"0"}];
                [stationArray addObjectsFromArray:respModel.data];
                allStationsArr = [[NSMutableArray alloc] initWithArray:stationArray];
                [self.pickerV setType:PickerTypeOne andTag:100 andDatas:allStationsArr];
                self.pickerV.hiddenCustomPicker = NO;
                
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
        }];
    }
    
    
    
    
    
    
   
}
- (void)getAllStationLazy{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    parmDic[@"menuName"] = @"API_patrol_location_list";
    
    BHttpRequest *req = [BHttpRequest new];
    req.needShowHud =@0;
    [req startRequest:parmDic uri:API_COMM_STATION_LIST result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            NSMutableArray *stationArray = [[NSMutableArray alloc] init];
            [stationArray addObject:@{@"name":@"全部电站", @"id":@"0"}];
            [stationArray addObjectsFromArray:respModel.data];
            allStationsArr = [[NSMutableArray alloc] initWithArray:stationArray];
        }
    }];
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    
    parmDic[@"pageindex"] = @(currentIndex);
    
    requestHelper.needShowHud =@0;
    if (currentStation) {
        parmDic[@"stationId"] = currentStation[@"id"];

    }
    
    [requestHelper startRequest:parmDic uri:API_patrol_location_list result:^(BResponseModel * _Nonnull respModel) {
        
        
        
        if (respModel.success) {
            currentIndex = currentIndex + 1;
            
            if([ws.mainTableV.header isRefreshing])
            {
                allLocationArr = [[NSMutableArray alloc] initWithArray:respModel.data[@"patrolLocationList"]];
                
            }else{
                
                if([respModel.data[@"patrolLocationList"] count] == 0)
                {
                    [ws.mainTableV.mj_footer endRefreshingWithNoMoreData];
                    [ws.mainTableV reloadData];
                    return;
                }else{
                    [allLocationArr addObjectsFromArray:respModel.data[@"patrolLocationList"]];
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
        
    
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!allLocationArr){
           return 0;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allLocationArr?[allLocationArr count]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(currentSelect==2){
        return 44.0f;
//    }
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
    
   
    
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CheckPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckPointCell"];
    NSDictionary *locationDic = allLocationArr[indexPath.row];
    
    [cell setData:locationDic andButtonClick:^(id x) {
            
            if (@available(iOS 13.0,*)) {

               if (NFCNDEFReaderSession.readingAvailable == YES) {
                   if ([NFCNDEFReaderSession readingAvailable]) {
                       WriteNFCViewController*wV = [[WriteNFCViewController alloc] initWithString:locationDic[@"nfc_code"]];
                       [self presentViewController:wV animated:YES completion:^{
                           
                       }];
                   }
               }else {
                   [SVProgressHUD showErrorWithStatus:@"该机型不支持NFC功能!"];
               }
            }else {

                [SVProgressHUD showErrorWithStatus:@"当前系统不支持NFC功能!"];
                NSLog(@"this device not support iOS 11.0");
            }
        
        } andButton1Click:^(id x) {
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该条巡检点吗？" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               
                
                if ([BAPIHelper getToken].length==0) {
                    return;
                }
                
                weak_self(ws);
                [requestHelper stop];
                
                NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

                requestHelper.needShowHud =@1;
                parmDic[@"id"] = locationDic[@"id"];

                [requestHelper startRequest:parmDic uri:API_patrol_location_delete result:^(BResponseModel * _Nonnull respModel) {
                    
                    if (respModel.success) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [allLocationArr removeObjectAtIndex:indexPath.row];
                        [mainTableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [mainTableV reloadData];
                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }
                }];
                
                
                
            }];

            [alert addAction:cancelAction];

            [alert addAction:okAction];

            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }];
    
    return cell;
}

#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if(v.tag == 100)
    {
        [headView setTitle:array[0][@"name"]];
        
        currentStation = array[0];
        if ([TOSTRING(currentStation[@"id"]) isEqualToString:@"0"]) {
            currentStation = nil;
        }
        [self.mainTableV.mj_header beginRefreshing];
        return;
//        currentDate =
    }
}





@end
