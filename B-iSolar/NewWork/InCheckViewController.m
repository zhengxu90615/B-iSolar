//
//  CheckUpViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/16.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "InCheckViewController.h"
#import "InCheckDeatailViewController.h"

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

@interface InCheckViewController ()
{
    NSDictionary *currentMonitor;
    IBOutlet NSLayoutConstraint *topCon;
    IBOutlet NSLayoutConstraint *tableTopCon;
    
    NSMutableArray *allMonitorArr,*allmissionArr;
    


    Select3StationHeaderView *checkHeadView;

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

@implementation InCheckViewController
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
    

    
    checkHeadView = [[Select3StationHeaderView alloc] initWithTitle:@[@"项目公司",@"电站",@"巡检时间"] andButtonClick:^(id x) {
        [ws headCheckClick:[x intValue]];
    }];
    
    
    
    
    //    topCon.constant = 64;
//    tableTopCon.constant = -64;
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckUpCompleteCell" bundle:nil] forCellReuseIdentifier:@"CheckUpCompleteCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckWorkTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckWorkTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MissionTableViewCell"];

 
    checkRightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(newCheck)];
    self.navigationItem.rightBarButtonItem = checkRightBtn;
       
    sepView.frame = CGRectMake(0, 0, MAINSCREENWIDTH/3, 4);
    sepView.backgroundColor = [UIColor whiteColor];
    
    

    self.title = String(@"巡检报告");
     
    
    
    
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
    if (index == 0) {
        weak_self(ws);
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        parmDic[@"menuName"] = @"inspectionReport_list";
        
        requestHelper.needShowHud =@1;
        [requestHelper startRequest:parmDic uri:@"mobile/orga_sta_list" result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                areaArr = [[NSMutableArray alloc] init];
                [areaArr addObject:@{@"name":@"全部",@"id":@""}];

                    for (NSDictionary * dic in respModel.data) {
                     
                            [areaArr addObject:dic];
                  
                    }
                    [ws.pickerV setType:PickerTypeOne andTag:0 andDatas:areaArr];
                    self.pickerV.hiddenCustomPicker = NO;
                
            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
            }
        }];
    }else if (index==1){
        if (currentArea) {
            
            
            
            [self.pickerV setType:PickerTypeOne andTag:1 andDatas:currentArea[@"children"]];
            self.pickerV.hiddenCustomPicker = NO;

        }else{
            [SVProgressHUD showInfoWithStatus:@"请先选择项目公司！"];
        }
    }
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
    InCheckDeatailViewController*vc = [[InCheckDeatailViewController alloc] initWithData:nil andEdit:YES];
    PUSHNAVICONTROLLER(vc);
}
 

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    
   
    //  外部巡检
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    if(currentDate)
        parmDic[@"inspectionDate"] = currentDate;
    if (currentArea) {
        parmDic[@"organization_id"] = currentArea[@"id"];
    }
    if (currentStation) {
        parmDic[@"station_id"] = currentStation[@"id"];
    }
    
    parmDic[@"pageindex"] = @(currentIndex);
    
    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:@"mobile/inspectionReportApi" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            currentIndex = currentIndex + 1;
            
            [checkHeadView setTitle0:currentArea?currentArea[@"name"]:@"项目公司"
                              title1:currentStation?currentStation[@"name"]:@"电站"
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
    
    //   0 巡检      2 外部巡检     -1 任务
    
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    //   0 巡检      2 外部巡检     -1 任务
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allMonitorArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 44.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        if(dataModel)
            return checkHeadView;
        else
            return nil;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                [requestHelper startRequest:parmDic uri:@"mobile/inspectionReportDownloadApi" result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        //下载文件到本地。
                        [SVProgressHUD showProgress:0];
                        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                            
                        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                        
                        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ts%f",API_FILE_URL([respModel.data[@"url"] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""]),[[NSDate date] timeIntervalSince1970]]]; //文件下载地址
                        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                        
                        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showProgress:downloadProgress.fractionCompleted];//下载进度
                            });
                         
                        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

                           NSString * fileName =  response.suggestedFilename; //文件名

                            fileName = [NSString stringWithFormat:@"%f%@",[[NSDate date] timeIntervalSince1970],fileName];
                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]]; //文件位置
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

                InCheckDeatailViewController*vc = [[InCheckDeatailViewController alloc] initWithData:check andEdit:YES];
                PUSHNAVICONTROLLER(vc);
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该条巡检报告吗？" preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];

                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   
                    
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
                    [parmDic setObject:check[@"id"] forKey:@"id"];
                    
                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/inspectionReportDelApi" result:^(BResponseModel * _Nonnull respModel) {
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

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //   0 巡检      2 外部巡检     -1 任务
    NSDictionary *check = allMonitorArr[indexPath.row];
    InCheckDeatailViewController*vc = [[InCheckDeatailViewController alloc] initWithData:check andEdit:NO];
    PUSHNAVICONTROLLER(vc);
   
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
  
   if(v.tag == 2)
   {
       currentDate = [NSString stringWithFormat:@"%@-%@",array[0],array[1]];
       isMannual = NO;
       [self.mainTableV.mj_header beginRefreshing];
   }else if (v.tag==1)
   {
       isMannual = NO;

       currentStation = array[0];
       
       [checkHeadView setTitle0:currentArea?currentArea[@"name"]:@"项目公司"
                         title1:currentStation?currentStation[@"name"]:@"电站"
                         title2:currentDate?currentDate:@"巡检时间"];
       
       [self.mainTableV.mj_header beginRefreshing];
       
       
   }else if (v.tag==0)
   {
       isMannual = NO;
       currentArea = array[0];
       currentStation = nil;
       [checkHeadView setTitle0:currentArea?currentArea[@"name"]:@"项目公司"
                         title1:currentStation?currentStation[@"name"]:@"电站"
                         title2:currentDate?currentDate:@"巡检时间"];
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
       [self.mainTableV.mj_header beginRefreshing];

   }
    
}

@end
