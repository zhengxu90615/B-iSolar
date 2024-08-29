//
//  NewMissionViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/6/18.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "NewGuzViewController.h"
#import "MissDealCell.h"
#import "ErrorInputTableViewCell.h"
#import "CustomDatePicker.h"
#import "MarkSelectAlert.h"
#import "CustomCell.h"
@interface NewGuzViewController ()<CustomPickerDelegate,CustomDatePickerDelegate>
{
    NSMutableDictionary *dataDic;
    CustomDatePicker*pickerV;
    CustomPicker *cusPickerV;
    NSMutableArray *selectUserArray;
    NSMutableDictionary *stationAllParams;

    NSMutableArray *selectStationsArray;
    CGFloat tabVHeight;
}
@end

@implementation NewGuzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增故障任务";
    [mainTableV registerNib:[UINib nibWithNibName:@"MissDealCell" bundle:nil] forCellReuseIdentifier:@"MissDealCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    pickerV = [ [ CustomDatePicker alloc] init];
    [pickerV setDatePickerMode: UIDatePickerModeDateAndTime];
    pickerV.delegate = self;
    
    
    cusPickerV = [[CustomPicker alloc] init];
    cusPickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    cusPickerV.delegate = self;
    
    dataDic = [[NSMutableDictionary alloc] init];
    dataDic[@"ori"] = @"";
    dataDic[@"station"] = @"";
    
    dataDic[@"device"] = @"";
    dataDic[@"deviceSelected"] = @[];
    dataDic[@"deviceIds"] = @"";
    
    dataDic[@"time"] = @"";
    
    dataDic[@"find"] = @"";
    dataDic[@"findDic"] = nil;

    
    dataDic[@"people"] = @"";
    dataDic[@"peopleSelected"] = @[];
    dataDic[@"peopleIds"] = @"";

    
    dataDic[@"note"] = @"";
    
    

    
    self.mainTableV.mj_header = nil;
    tabVHeight= mainTableV.height-74;
    [self setButton];
    
    [self getSelectUser:nil];

    [self getOriAndStation:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}




- (void)setButton{
    if (!buttonView) {
        mainTableV.frame = CGRectMake(mainTableV.x, mainTableV.y, mainTableV.width, mainTableV.height-74);
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, mainTableV.y + mainTableV.height, MAINSCREENWIDTH, 74)];
        buttonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:buttonView];
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonView addSubview:button1];
     
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(15,12.5, MAINSCREENWIDTH-30, 49);

        button1.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
        button1.clipsToBounds = YES;
        [button1 setTitle:@"提交" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button1.backgroundColor = MAIN_TINIT_COLOR;
    }
}

- (void)buttonClick:(id)sender{
    
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    
//    dataDic[@"ori"] = @"";
//    dataDic[@"station"] = @"";
//    
//    dataDic[@"device"] = @"";
//    dataDic[@"deviceSelected"] = @[];
//    dataDic[@"deviceIds"] = @"";
//    
//    dataDic[@"time"] = @"";
//    
//    dataDic[@"find"] = @"";
//    dataDic[@"findDic"] = nil;
//
//    
//    dataDic[@"people"] = @"";
//    dataDic[@"peopleSelected"] = @[];
//    dataDic[@"peopleIds"] = @"";
    
    //    'organizationId', 'stationId', 'discoverTime', 'discoverUserId', 'description'
    //    item.deviceInfoNames = request.POST.get("deviceInfoNames")
    //    item.deviceInfoIds = request.POST.get("deviceInfoIds")
    //    user_ids = request.POST.get('userIds')
    //    user_names = request.POST.get('userNames')
    
    
    if (!dataDic[@"station"]) {
        [SVProgressHUD showErrorWithStatus:@"请先选择电站！"];
        return;
    }
    
   
    if ([dataDic[@"time"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择发现时间"];
        return;
    }
    if ([dataDic[@"find"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择发现人"];
        return;
    }
    
    if ([dataDic[@"note"]  isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入故障描述"];
        return;
    }
    
    parmDic[@"organizationId"] = dataDic[@"oriDic"][@"id"];
    parmDic[@"stationId"] = dataDic[@"stationDic"][@"id"];
    
    parmDic[@"discoverTime"] = dataDic[@"time"];
    
    parmDic[@"discoverUserId"] = dataDic[@"findDic"][@"id"];
    parmDic[@"description"] = dataDic[@"note"];

    
    if (![dataDic[@"device"] isEqualToString:@""]) {
        parmDic[@"deviceInfoNames"] = dataDic[@"device"];
        parmDic[@"deviceInfoIds"] = dataDic[@"deviceIds"];
    }
   
    if (![dataDic[@"people"] isEqualToString:@""]) {
        parmDic[@"userNames"] = dataDic[@"people"];
        parmDic[@"userIds"] = dataDic[@"peopleIds"];
    }
   
    requestHelper.needShowHud =@1;
    [requestHelper startRequest:parmDic uri:@"mobile/fault_task/add" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [SVProgressHUD showSuccessWithStatus:respModel.message];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
//                    [picArr removeAllObjects];
//                    [picArr addObject:@""];
//                    misNote = @"";
//
//                    [self.mainTableV.mj_header beginRefreshing];
            
            

        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    
    
    
}

- (void)getSelectUser:(NormalBlock)b{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    BHttpRequest *req = [BHttpRequest new];
    weak_self(ws);
    req.needShowHud =@0;
    [req startRequest:nil uri: @"mobile/mission_trace/select_user" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            selectUserArray = [[NSMutableArray alloc] initWithArray:respModel.data];
            
            if (b) {
                b(nil);
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
  
    }];
}


- (void)getOriAndStation:(NormalBlock)b{
    
//    orga_sta_list
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    BHttpRequest *req = [BHttpRequest new];
    weak_self(ws);
    req.needShowHud =@0;
    

    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    parmDic[@"menuName"] = @"API_fault_task_list";
    
    req.needShowHud =@0;
    [req startRequest:parmDic uri:@"mobile/orga_sta_list" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
     
            
            selectStationsArray = [[NSMutableArray alloc] init];
            for (NSDictionary * dic in respModel.data) {
                NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                newDic[@"list"] = dic[@"children"];
                [selectStationsArray addObject:newDic];
            }

            
            
            if (b) {
                b(nil);
            }
        }else{
//            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    
    
}

- (void)getAllParams:(NormalBlock)b{
    stationAllParams = nil;
    BHttpRequest *req = [BHttpRequest new];
    weak_self(ws);
    req.needShowHud =@0;
    

    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    parmDic[@"stationId"] = dataDic[@"stationDic"][@"id"];
    
    req.needShowHud =b?@1:@0;
    [req startRequest:parmDic uri:@"mobile/fault_task/params" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
     
            
            stationAllParams = [[NSMutableDictionary alloc] initWithDictionary:respModel.data];
            if (b) {
                b(nil);
            }

        }else{
//            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    
    
}



- (void)getData:(id)sender{
   
    [mainTableV.mj_header endRefreshing];
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
     
        return 0;
    }else if (indexPath.row == 2) {
        CGFloat h = [AppDelegate textHeight:dataDic[@"device"] andFontSIze:16 andTextwidth:MAINSCREENWIDTH-20];
        
        return MAX(75, h + 40);
    }else if (indexPath.row == 6) {
        return 155;
    }else if (indexPath.row == 5) {
        CGFloat h = [AppDelegate textHeight:dataDic[@"people"] andFontSIze:16 andTextwidth:MAINSCREENWIDTH-20];
        return MAX(75, h + 40);
    }
    return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    dataDic[@"ori"] = @"";
//    dataDic[@"station"] = @"";
//    dataDic[@"device"] = @"";
//    dataDic[@"time"] = @"";
//    dataDic[@"find"] = @"";
//    dataDic[@"people"] = @"";
    
    if (indexPath.row == 0) {
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"项目公司";
        dic[@"value"] = dataDic[@"ori"];
        dic[@"placeholder"] = @"请选择项目公司";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            
         
           
        }];
        return cell;
    }else if (indexPath.row == 1) {
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"电站名称";
        dic[@"value"] = dataDic[@"station"];
        dic[@"placeholder"] = @"请选择电站";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            
         
           
        }];
        return cell;
        
    }else if (indexPath.row == 2) {
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"设备名称";
        dic[@"value"] = dataDic[@"device"];
        dic[@"placeholder"] = @"请选择设备";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            
         
           
        }];
        return cell;
        
    }else if (indexPath.row == 3) {
        MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"发现时间";
        dic[@"value"] =  dataDic[@"time"];
        dic[@"placeholder"] = @"请选择发现时间";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
        
            [pickerV setMaxDate:[NSDate date]];

            pickerV.tag = 100;
            pickerV.hiddenCustomPicker = NO;
            
            [ws dismissAllKeyBoardInView:tableView];
            
            NSLog(@"andBlock2 %@",x);
            
        }];
        return cell;
    }else if (indexPath.row == 4) {
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"发现人";
        dic[@"value"] = dataDic[@"find"];
        dic[@"placeholder"] = @"请选择发现人";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            
         
           
        }];
        return cell;
    }else if (indexPath.row == 5) {
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"被指派人";
        dic[@"value"] = dataDic[@"people"];
        dic[@"placeholder"] = @"请选择被指派人";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            
         
           
        }];
        return cell;
    }else{
        ErrorInputTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"故障描述";
        dic[@"value"] = dataDic[@"note"];
        dic[@"placeholder"] = @"请输入故障描述";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
            NSLog(@"andBlock %@",x);
            dataDic[@"note"] = TOSTRING(x);
            
            [ws maintableHeight:0];
        } andBlock2:^(id x) {
            NSLog(@"andBlock2 %@",x);
            [ws maintableHeight:216];
        }];
        return cell;
    }
    
    
    
}


- (void)maintableHeight:(float)height{
    mainTableV.frame = CGRectMake(mainTableV.x, mainTableV.y, mainTableV.width, tabVHeight - height);
    [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissAllKeyBoardInView:tableView];

    if (indexPath.row == 1) {
        
        if (selectStationsArray) {
            [cusPickerV setType:PickerTypeTwo andTag:200 andDatas:selectStationsArray];
            cusPickerV.hiddenCustomPicker = NO;
        }else{
            [self getOriAndStation:^(id x) {
                [pickerV setType:PickerTypeTwo andTag:200 andDatas:selectStationsArray];
                pickerV.hiddenCustomPicker = NO;
            }];
        }
        
    }else if (indexPath.row == 2){
        //设备  ----
        if (!dataDic[@"stationDic"]) {
            [SVProgressHUD showErrorWithStatus:@"请先选择电站！"];
            return;
        }
        
        if (stationAllParams) {
            
            NSMutableArray *indexArr = [[NSMutableArray alloc] init];
           
            for (int i = 0; i<[stationAllParams[@"deviceChoice"] count]; i++) {
                if ([dataDic[@"deviceIds"] containsString:[NSString stringWithFormat:@"#%@#",stationAllParams[@"deviceChoice"][i][@"value"]] ]) {
                    [indexArr addObject:@(i)];
                }
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayAction:@"请选择设备" action:stationAllParams[@"deviceChoice"] result:^(NSArray *arr) {
                
                if (arr) {
                    NSLog(@"%@",arr);
                    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
                    NSMutableArray *nameArr = [NSMutableArray array];
                    NSMutableArray *idsArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        [tmpArr addObject:dic];
                        [idsArr addObject:[NSString stringWithFormat:@"#%@#",dic[@"value"]]];
                        [nameArr addObject:dic[@"name"]];
                    }
                    NSString *ids = [idsArr componentsJoinedByString:@""];
                    
                    NSLog(@"%@",ids);

                    dataDic[@"device"] = [nameArr componentsJoinedByString:@","];
                    dataDic[@"deviceIds"] = ids;
                    
                    dataDic[@"deviceSelected"] = tmpArr;
                    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

                }
                
            }andSelected:indexArr];
            [al show];
        }else{
            weak_self(ws)
            [self getAllParams:^(id x) {
                [ws tableView:tableView didSelectRowAtIndexPath:indexPath];
            }];
        }
        
        
        
    }else if (indexPath.row == 4){
        //发现人  ----
        if (!dataDic[@"stationDic"]) {
            [SVProgressHUD showErrorWithStatus:@"请先选择电站！"];
            return;
        }
        
        if (stationAllParams) {
            
            NSMutableArray*statusArr = [NSMutableArray array];
            for (NSDictionary*user in  stationAllParams[@"discoverChoice"]) {
                [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayActionOnlyOne:@"请选择发现人" action:statusArr result:^(NSArray *arr) {
                if (!arr) {
                    return;
                }
                dataDic[@"find"] = arr[0][@"name"];
                dataDic[@"findDic"] = arr[0];
                [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

            }];
            [al show];
            
        }else{
            weak_self(ws)
            [self getAllParams:^(id x) {
                [ws tableView:tableView didSelectRowAtIndexPath:indexPath];
            }];
        }
        
        
        
    }else if (indexPath.row == 5){
        //被指派人  ----
        if (!dataDic[@"stationDic"]) {
            [SVProgressHUD showErrorWithStatus:@"请先选择电站！"];
            return;
        }
        if (stationAllParams) {
//            dataDic[@"peopleSelected"] = @[];
//            dataDic[@"peopleIds"] = @"";
            NSMutableArray *indexArr = [[NSMutableArray alloc] init];
           
            for (int i = 0; i<[stationAllParams[@"userChoice"] count]; i++) {
                if ([dataDic[@"peopleIds"] containsString:[NSString stringWithFormat:@"#%@#",stationAllParams[@"userChoice"][i][@"value"]] ]) {
                    [indexArr addObject:@(i)];
                }
            }
            
            MarkAlert *al = [[MarkAlert alloc] initWithPayAction:@"请选择任务被指派人" action:stationAllParams[@"userChoice"] result:^(NSArray *arr) {
                
                if (arr) {
                    NSLog(@"%@",arr);
                    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
                    NSMutableArray *nameArr = [NSMutableArray array];
                    NSMutableArray *idsArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        [tmpArr addObject:dic];
                        [idsArr addObject:[NSString stringWithFormat:@"#%@#",dic[@"value"]]];
                        [nameArr addObject:dic[@"name"]];
                    }
                    NSString *ids = [idsArr componentsJoinedByString:@""];
                    
                    NSLog(@"%@",ids);

                    dataDic[@"people"] = [nameArr componentsJoinedByString:@","];
                    dataDic[@"peopleIds"] = ids;
                    
                    dataDic[@"peopleSelected"] = tmpArr;
                    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

                }
                
            }andSelected:indexArr];
            [al show];
        }else{
            weak_self(ws)
            [self getAllParams:^(id x) {
                [ws tableView:tableView didSelectRowAtIndexPath:indexPath];
            }];
        }
        
        
        
        
        
    }
    
    
    
    
//    else if (indexPath.row == 4) {
//
//        if (selectUserArray) {
//            MarkSelectAlert *al = [[MarkSelectAlert alloc] initUsers:selectUserArray andSelected:dataDic[@"selected"] result:^(NSArray *x) {
//                [self reloadSelectedUsers:x];
//            }];
//            [al show];
//        }else{
//            [self getSelectUser:^(id x) {
//                MarkSelectAlert *al = [[MarkSelectAlert alloc] initUsers:selectUserArray andSelected:dataDic[@"selected"] result:^(NSArray *x) {
//                    [self reloadSelectedUsers:x];
//                }];
//                [al show];
//            }];
//        }
//    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)pickerViewSureClick:(CustomDatePicker *)v{
    
    NSDate *date = v.customDate;
    //获取系统当前时间
    NSDate *currentDate = date;
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    

    
    if (v.tag == 100) {
        dataDic[@"time"] =currentDateString;
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    NSLog(@"%@",date);
}

#pragma mark -- cusPickerV
- (void)pickerView :(CustomPicker*)v selected:(NSArray *)array andIndexPath:(NSIndexPath*)indexpath;
{
    
    if ([array[1] isEqualToDictionary:dataDic[@"stationDic"]]) {
        //不变
        NSLog(@"电站没变");
        return;
        
    }
    dataDic[@"oriDic"] = array[0];
    dataDic[@"stationDic"] = array[1];

    dataDic[@"ori"] = array[0][@"name"];
    dataDic[@"station"] = array[1][@"name"];
    
    
    dataDic[@"device"] = @"";
    dataDic[@"deviceSelected"] = @[];
    dataDic[@"deviceIds"] = @"";
        
    dataDic[@"find"] = @"";
    dataDic[@"findDic"] = nil;

    
    dataDic[@"people"] = @"";
    dataDic[@"peopleSelected"] = @[];
    dataDic[@"peopleIds"] = @"";
    
    [mainTableV reloadData];
    
    
//    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self getAllParams:nil];
}





@end
