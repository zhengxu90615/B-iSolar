//
//  NewMissionViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/6/18.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "NewMissionViewController.h"
#import "MissDealCell.h"
#import "ErrorInputTableViewCell.h"
#import "CustomDatePicker.h"
#import "MarkSelectAlert.h"
#import "CustomCell.h"
@interface NewMissionViewController ()
{
    NSMutableDictionary *dataDic;
    CustomDatePicker*pickerV;
    NSMutableArray *selectUserArray;
    CGFloat tabVHeight;
}
@end

@implementation NewMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务新增";
    [mainTableV registerNib:[UINib nibWithNibName:@"MissDealCell" bundle:nil] forCellReuseIdentifier:@"MissDealCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    pickerV = [ [ CustomDatePicker alloc] init];
    pickerV.delegate = self;
    dataDic = [[NSMutableDictionary alloc] init];
    dataDic[@"name"] = @"";
    dataDic[@"des"] = @"";
    dataDic[@"endTime"] = @"";
    dataDic[@"remindTime"] = @"";
    dataDic[@"people"] = @"";
    dataDic[@"selected"] = nil;
    dataDic[@"note"] = @"";
    tabVHeight= mainTableV.height-74;
    [self setButton];
    
    [self getSelectUser:nil];

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

    
//   ["name", "missionNote", "endTime", "remindTime", "userIds"]
    parmDic[@"name"] = dataDic[@"name"];
    parmDic[@"missionNote"] = dataDic[@"des"];
    
    parmDic[@"endTime"] = dataDic[@"endTime"];
    parmDic[@"remindTime"] = dataDic[@"remindTime"];
    if (!dataDic[@"ids"]) {
        dataDic[@"ids"] = @[];
    }
    parmDic[@"userIds"] = [dataDic[@"ids"] componentsJoinedByString:@","] ;

    parmDic[@"note"] = dataDic[@"note"];

    

    if ([parmDic[@"name"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入任务名称"];
        return;
    }
    if ([parmDic[@"missionNote"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入任务描述"];
        return;
    }
    if ([parmDic[@"endTime"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择任务截止时间"];
        return;
    }
    if ([parmDic[@"remindTime"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择任务提醒时间"];
        return;
    }
    if (!parmDic[@"userIds"] || [parmDic[@"userIds"] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择被指派人"];
        return;
    }
    requestHelper.needShowHud =@1;
    [requestHelper startRequest:parmDic uri:@"mobile/mission_trace/add" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [SVProgressHUD showSuccessWithStatus:respModel.message];
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


- (void)getData:(id)sender{
   
    [mainTableV.mj_header endRefreshing];
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 155;
    }else if (indexPath.row == 5) {
        return 155;
    }else if (indexPath.row == 4) {
        
       
        CGFloat h = [AppDelegate textHeight:dataDic[@"people"] andFontSIze:FONTSIZE_TABLEVIEW_CELL_TITLE andTextwidth:MAINSCREENWIDTH-20];
        
        return MAX(75, h + 40);
    }
    return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
    
 
    if (indexPath.row == 0) {
        MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"任务名称";
        dic[@"value"] =  dataDic[@"name"];
        dic[@"placeholder"] = @"请输入任务名称";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
            dataDic[@"name"] = TOSTRING(x);

            
        } andBlock2:^(id x) {
         
            NSLog(@"andBlock2 %@",x);
            
        }];
        return cell;
    }else if (indexPath.row == 1) {
        ErrorInputTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"任务描述";
        dic[@"value"] =   dataDic[@"des"];
        dic[@"placeholder"] = @"请输入任务描述";
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
            NSLog(@"andBlock %@",x);
            dataDic[@"des"] = TOSTRING(x);

            
        } andBlock2:^(id x) {
            NSLog(@"andBlock2 %@",x);

        }];
        return cell;
    }else if (indexPath.row == 2) {
        MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"任务截止时间";
        dic[@"value"] =  dataDic[@"endTime"];
        dic[@"placeholder"] = @"请选择时间";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

            if (![dataDic[@"remindTime"] isEqualToString:@""]) {
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormatter dateFromString:dataDic[@"remindTime"]];

                
                [pickerV setMinDate:date];
            }
            
            [pickerV setMaxDate:[dateFormatter dateFromString:@"2099-12-31 00:00:00"]];

            pickerV.tag = 100;
            pickerV.hiddenCustomPicker = NO;
            
            [ws dismissAllKeyBoardInView:tableView];
            
            NSLog(@"andBlock2 %@",x);
            
        }];
        return cell;
    }else if (indexPath.row == 3) {
        MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"name"] =@"任务提醒时间";
        dic[@"value"] = dataDic[@"remindTime"];
        dic[@"placeholder"] = @"请选择时间";
        weak_self(ws);
        [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                        
            NSLog(@"andBlock %@",x);

        } andBlock2:^(id x) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

            if (![dataDic[@"endTime"] isEqualToString:@""]) {

                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormatter dateFromString:dataDic[@"endTime"]];

                
                [pickerV setMaxDate:date];
            }
            
            [pickerV setMinDate:[dateFormatter dateFromString:@"2023-12-31 00:00:00"]];

            NSLog(@"andBlock2 %@",x);
            pickerV.tag = 200;
            pickerV.hiddenCustomPicker = NO;
            [ws dismissAllKeyBoardInView:tableView];
            
        }];
        return cell;
    }else if (indexPath.row == 4) {
        
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
        dic[@"name"] =@"任务备注";
        dic[@"value"] = dataDic[@"note"];
        dic[@"placeholder"] = @"请输入备注";
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
    [mainTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)reloadSelectedUsers:(NSArray *)selectedUsers{
    dataDic[@"selected"] = [selectedUsers mutableCopy];
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    NSMutableArray *idArr = [[NSMutableArray alloc] init];
    
    for (NSArray *arr in selectedUsers) {
        for (NSDictionary *dic in arr) {
            if ([idArr containsObject:TOSTRING(dic[@"id"])]) {
                continue;
            }
            [idArr addObject:TOSTRING(dic[@"id"])];
            [nameArr addObject:[NSString stringWithFormat:@"(%d)%@",[nameArr count] +1,dic[@"name"]]];
        }
    }
    
    dataDic[@"ids"] = idArr;
    dataDic[@"people"] =  [nameArr componentsJoinedByString:@"、"];
    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    titleInput.text = [nameArr componentsJoinedByString:@"、"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        [self dismissAllKeyBoardInView:tableView];

        if (selectUserArray) {
            MarkSelectAlert *al = [[MarkSelectAlert alloc] initUsers:selectUserArray andSelected:dataDic[@"selected"] result:^(NSArray *x) {
                [self reloadSelectedUsers:x];
            }];
            [al show];
        }else{
            [self getSelectUser:^(id x) {
                MarkSelectAlert *al = [[MarkSelectAlert alloc] initUsers:selectUserArray andSelected:dataDic[@"selected"] result:^(NSArray *x) {
                    [self reloadSelectedUsers:x];
                }];
                [al show];
            }];
        }
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
        dataDic[@"endTime"] =currentDateString;
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }else{
        dataDic[@"remindTime"] =currentDateString;
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    NSLog(@"%@",date);
}




@end
