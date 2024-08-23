//
//  MonitorViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/8.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "MonitorViewController.h"
#import "ReportDetailViewController.h"
#import "MonitorTableViewCell.h"
#import "MonitorOTableViewCell.h"
#import "AlarmNewViewController.h"
#import "MonitorDetailViewController.h"
#import "MonitorOneTableViewCell.h"
#import "MonitorTwoTableViewCell.h"
#import "MonitorThreeTableViewCell.h"

@interface MonitorViewController ()
{
    BOOL   expand;
    IBOutlet NSLayoutConstraint *tableTopCon;
    UIView *headView;
    UIButton *myBtn ;
    NSMutableArray *sortArr;
}
@property(nonatomic ,strong) NSMutableArray *sortArr;
@end

@implementation MonitorViewController
@synthesize mainTableV;
@synthesize hideSectionArr, sortArr;
@synthesize pickerV;

- (void)viewDidLoad {
    [super viewDidLoad];
    expand = NO;
    
    if (kStatusBarHeight == 20){
         tableTopCon.constant = 44 + 20;
     }
     [self setHeader];
    
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
    
    
    self.title = String(@"监控");
    hideSectionArr = [[NSMutableArray alloc] init];
    weak_self(ws);
    [mainTableV registerNib:[UINib nibWithNibName:@"MonitorOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorOneTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MonitorTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorTwoTableViewCell"];
[mainTableV registerNib:[UINib nibWithNibName:@"MonitorThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorThreeTableViewCell"];

    [mainTableV registerNib:[UINib nibWithNibName:@"MonitorTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MonitorOTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorOTableViewCell"];

    
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

    
    ZYSpreadSubButton *detailBtn1 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchStation"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws.pickerV setType:PickerTypeTwo andTag:2 andDatas:ws.dataModel.data[@"list"]];
        ws.pickerV.hiddenCustomPicker = NO;
    }];
    
    ZYSpreadSubButton *detailBtn2 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"searchOrg"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws.pickerV setType:PickerTypeOne andTag:1 andDatas:ws.dataModel.data[@"list"]];
        ws.pickerV.hiddenCustomPicker = NO;
    }];
    
    
    ZYSpreadSubButton *detailBtn3 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"alarmBtn"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        [ws.hideSectionArr removeAllObjects];

        NSMutableArray *oldArr = [[NSMutableArray alloc] initWithArray:ws.dataModel.data[@"list"]];
        
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in oldArr) {
            int alarmCount = [dic[@"alarm"] intValue];
            if (alarmCount > 0) {
                NSMutableArray * newStationArr = [[NSMutableArray alloc] init];
                for (NSDictionary *stationDic in dic[@"list"])
                {
                    int alarmCount = [stationDic[@"alarm"] intValue];
                    if (alarmCount > 0  ) {
                        [newStationArr addObject:stationDic];
                    }
                }
                NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                [newDic setValue:newStationArr forKey:@"list"];
                [newArr addObject:newDic];
            }
        }
        NSMutableDictionary *oldData = [[NSMutableDictionary alloc] initWithDictionary:ws.dataModel.data];
        [oldData setObject:newArr forKey:@"list"];
        ws.dataModel.data = oldData;
        [ws.mainTableV reloadData];
    }];
    
    [zButton setSubButtons:@[detailBtn1,detailBtn2,detailBtn3]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmDealNoti:) name:NOTIFICATION_ALARM_DEAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmDealNoti:) name:NOTIFICATION_LOGIN object:nil];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)setHeader{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, MAINSCREENWIDTH, 44)];
    headView.backgroundColor = [UIColor clearColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = String(@"监控");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [headView addSubview:titleLabel];

    myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.frame = CGRectMake(12, 7.5f, 74, 29);
    myBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [myBtn setTitle:@"全部展开" forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:myBtn];
    
    [self.view addSubview:headView];
}


- (void)reloadV{
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)expand:(UIButton*)sender{
    expand = !expand;
    
    if (expand){
        [hideSectionArr removeAllObjects];
        [sender setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"全部展开" forState:UIControlStateNormal];
        for (int i = 0; i< [dataModel.data[@"list"] count];i++)
        {
            [hideSectionArr addObject:@(i+3)];
        }
    }
    [self.mainTableV reloadData];
}


- (void)alarmDealNoti:(id)obj{
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
 
    [apiBlock startRequest:parmDic uri:API_MONITOR result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
            ws.navigationItem.title = respModel.data[@"title"];
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        ws.sortArr = [[NSMutableArray alloc] initWithCapacity:[ws.dataModel.data[@"list"] count]];
        expand = NO;
        for (int i = 0; i< [ws.dataModel.data[@"list"] count];i++)
        {
            [ws.hideSectionArr addObject:@(i)];
            [ws.sortArr addObject:@(0)];
        }
        ws.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"展开" style:UIBarButtonItemStyleDone target:ws action:@selector(expand:)];
        
        [ws.mainTableV reloadData];
    }];
}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 127;
    }else if (indexPath.section==1){
        return 204.5;
    }else if (indexPath.section==2){
        return 245;
    }
    
    
    if (indexPath.row == 0) {
        return ([hideSectionArr containsObject:@(indexPath.section)])?(117+5):155;
    }
    return 149+5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section <=2) {
        return 10;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray *arr = dataModel.data[@"list"] ;

    if (section == arr.count + 2) {
        return 10;
    }
    if (section == 2) {
        return 5;
    }
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!dataModel) {
        return 0;
    }
    
    NSArray *arr = dataModel.data[@"list"] ;
    return arr.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section <= 2) {
        return 1;
    }
    NSArray *arr = dataModel.data[@"list"];
    return (([hideSectionArr containsObject:@(section)])?0:[arr[section-3][@"list"] count]) + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        MonitorOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorOneTableViewCell"];
        [cell setData:dataModel.data];
        return cell;
    }else if (indexPath.section==1){
        MonitorTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorTwoTableViewCell"];
        [cell setData:dataModel.data];
        return cell;
    }else if (indexPath.section==2){
        MonitorThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorThreeTableViewCell"];
        [cell setData:dataModel.data];
        return cell;
    }
    
    if (indexPath.row == 0) {
        MonitorOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorOTableViewCell"];
        NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section - 3];
        [cell setData:orgnization andShowNum:orgnization[@"dgc"] andShowBtn:[hideSectionArr containsObject:@(indexPath.section)] andSort:[self.sortArr[indexPath.section - 3] integerValue]];
        weak_self(ws);
        cell.leftClickBlock = ^{
//            [SVProgressHUD showSuccessWithStatus:@"敬请期待"];
            [ws.pickerV setType:PickerTypeOne andTag:100 + indexPath.section-3 andDatas:@[@{@"name": @"兆瓦发电量"},@{@"name": @"日发电量"}]];
            ws.pickerV.hiddenCustomPicker = NO;
        };
        return cell;
        
        
    }
    
    MonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorTableViewCell"];
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section - 3];
    NSArray *stationArr = orgnization[@"list"];
    [cell setData:stationArr[indexPath.row-1] ];
    weak_self(ws);
    cell.leftClickBlock = ^{
//        AlarmNewViewController *alarmV = [[AlarmNewViewController alloc] initWithStationId:stationArr[indexPath.row-1]];
        AlarmNewViewController *alarmV = [[AlarmNewViewController alloc] initWithStation:stationArr[indexPath.row-1] andOrinization:orgnization ];
        alarmV.hidesBottomBarWhenPushed = YES;
        [ws.navigationController pushViewController:alarmV animated:YES];
    };
    
    cell.rightClickBlock = ^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待"];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    if (indexPath.section <= 2) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *orgnization = dataModel.data[@"list"][indexPath.section-3];
    NSArray *stationArr = orgnization[@"list"];
    
    if (indexPath.row == 0) {
        MonitorOTableViewCell *cell = (MonitorOTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
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
        [cell hideBtn:[hideSectionArr containsObject:@(indexPath.section)]];

        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }else{
        NSDictionary *station =stationArr[indexPath.row-1];
        MonitorDetailViewController *vc = [[MonitorDetailViewController alloc] initWithMonitor:station];

        PUSHNAVICONTROLLER(vc);
    }
}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 1) {
        [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section+3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (v.tag == 2){
        if ([hideSectionArr containsObject:@(indexpath.section+3)]){
            NSDictionary *orgnization = dataModel.data[@"list"][indexpath.section];
            NSArray *stationArr = orgnization[@"list"];
            
            NSMutableArray *stationIndexArr = [[NSMutableArray alloc] init];
            for (int i =0 ; i<stationArr.count; i++) {
                [stationIndexArr addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexpath.section+3]];
            }
            [hideSectionArr removeObject:@(indexpath.section+3)];
            [mainTableV insertRowsAtIndexPaths:stationIndexArr withRowAnimation:UITableViewRowAnimationFade];
        }
        [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section+3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else if (v.tag == 3){
        [mainTableV.mj_header beginRefreshing];
    }else{
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:dataModel.data];
        NSMutableArray* oList = [[NSMutableArray alloc] initWithArray:data[@"list"]];
        NSMutableDictionary *orgnization = [[NSMutableDictionary alloc] initWithDictionary:oList[v.tag-100]];

        NSInteger index = indexpath.section;
        
        NSArray *stationsList = orgnization[@"list"];
        
        NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:stationsList.count];
        
        if (index == 0) {
            //兆瓦发电量
            self.sortArr[v.tag-100] = @(1);
         
           newArr = [stationsList sortedArrayUsingComparator:^(id obj1,id obj2)
           {
               //升序，key表示比较的关键字
               if ([obj1[@"mw"] floatValue] > [obj2[@"mw"]  floatValue])
               {
                   return NSOrderedAscending;
               }
               else
               {
                   return NSOrderedDescending;
               }
           }];
           
           orgnization[@"list"] = newArr;
           oList[v.tag-100] = orgnization;
                      
        }else{
            //日发电量
            self.sortArr[v.tag-100] = @(2);
            
            newArr = [stationsList sortedArrayUsingComparator:^(id obj1,id obj2)
            {
                
                //升序，key表示比较的关键字
                if ([obj1[@"PV_DGC"][@"value"] floatValue] > [obj2[@"PV_DGC"][@"value"]  floatValue])
                {
                    return NSOrderedAscending;
                }
                else
                {
                    return NSOrderedDescending;
                }
            }];
            
            orgnization[@"list"] = newArr;
            oList[v.tag-100] = orgnization;
            
        }
        
        data[@"list"] = oList;
        dataModel.data = data;
        
        MonitorOTableViewCell *cell = [mainTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:v.tag-100 + 3]];
        
        [cell setBtn:[self.sortArr[v.tag-100] integerValue]];
      
        
        NSMutableArray *indexPathArr = [[NSMutableArray alloc] initWithCapacity:newArr.count];
        for (int i = 0; i<newArr.count; i++) {
            [indexPathArr addObject:[NSIndexPath indexPathForRow:i+1 inSection:v.tag-100 + 3]];
        }
        
        [mainTableV reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
        
        
        
        
    }
    
}

@end
