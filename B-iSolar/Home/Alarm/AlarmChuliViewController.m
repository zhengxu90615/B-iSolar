//
//  MissionChuliViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "AlarmChuliViewController.h"
#import "NoticeTTableViewCell.h"
#import "ErrorInputTableViewCell.h"
#import "MissDealCell.h"
#import "CustomDatePicker.h"
#import "CheckUpImgCell.h"
#import "YBImageBrowser.h"
#import "AlarmNewCellTableViewCell.h"

@interface AlarmChuliViewController ()<CustomDatePickerDelegate>
{
    NSMutableDictionary*misstionDic;
    NSString*missId;
    NSString *misRate;
    NSString *misDT,*baiDT;
    NSString *dealResult;

    NSString *misNote;
    CustomDatePicker *pickerV;
    NSMutableArray *picArr;
}
@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation AlarmChuliViewController
@synthesize dealPickerV;

- (id)initWithMission:(NSDictionary*)miss
{
    if (self = [super init]) {
        missId = TOSTRING(miss[@"id"]);
        
        misstionDic = [[NSMutableDictionary alloc] initWithDictionary:miss];
        
        misstionDic[@"mission_trace_detail"] = [miss copy];
        
        misstionDic[@"dt"] = @"";
        misstionDic[@"des"] = @"";
        if (miss[@"rate"]) {
            misRate = @"";//TOSTRING(miss[@"rate"]);
        }else{
            misRate = @"";
        }
        
        misstionDic[@"rate"] = TOSTRING(miss[@"rate"]);;
        misstionDic[@"rate1"] = TOSTRING(miss[@"rate"]);;

        misstionDic[@"finishTime"] = @"";

        misNote = TOSTRING(@"");
        misDT = TOSTRING(@"");
        baiDT = @"";
        dealResult = TOSTRING(@"");
        picArr = [[NSMutableArray alloc] init];
        [picArr addObject:@""];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务处理";
    [mainTableV registerNib:[UINib nibWithNibName:@"AlarmNewCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmNewCellTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"MissDealCell" bundle:nil] forCellReuseIdentifier:@"MissDealCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckUpImgCell" bundle:nil] forCellReuseIdentifier:@"CheckUpImgCell"];
 
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    mainTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    pickerV = [ [ CustomDatePicker alloc] init];
    pickerV.delegate = self;
    
    self.dealPickerV = [[CustomPicker alloc] init];
    self.dealPickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.dealPickerV.delegate = self;
    
    [self setButton];
    // Do any additional setup after loading the view from its nib.
}


- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    requestHelper.needShowHud =@0;
    parmDic[@"alarmMonitorId"] = missId;
    [requestHelper startRequest:parmDic uri:API_MONITOR_ALARM_DETAIL  result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            misstionDic = [[NSMutableDictionary alloc] initWithDictionary:respModel.data];

            NSString *minTime = misstionDic[@"takingTime"];
            
            [pickerV setMinDate: [NSDate dateWithPortableString:minTime]];
            
            misstionDic[@"dt"] = @"";
            misstionDic[@"des"] = @"";
            
//            misRate = TOSTRING(respModel.data[@"rate"]);
            misRate = @"";

            misstionDic[@"rate"] = TOSTRING(respModel.data[@"rate"]);;
            misstionDic[@"rate1"] = TOSTRING(respModel.data[@"rate"]);;
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        if([ws.mainTableV.mj_header isRefreshing])
            [ws.mainTableV.mj_header endRefreshing];
        
        [ws.mainTableV reloadData];
    }];
}


-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }

    for(UIView *subView in view.subviews) {
        if([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section ==0) {
        return 10 + [AppDelegate textHeight: TOSTRING(indexPath.row==0?misstionDic[@"name"]:misstionDic[@"description"]) andFontSIze:15 andTextwidth:MAINSCREENWIDTH-20 - 90];

    }else
    {
        switch (indexPath.row) {
            case 0:  //时间
                return 75;
                break;
            case 1: //进度
                return 75;
                break;
            case 2:  //处理结果
            {
                if ([misRate isEqualToString:@"100"]) {
                    return 75;
                }else{
                    return 0;
                }
            }
               
                break;
            case 3://白名单截止时间
                {
                    if ([misRate isEqualToString:@"100"] && [dealResult isEqualToString:@"转白名单"]) {
                        return 75;
                    }else{
                        return 0;
                    }
                }
                break;
            case 4: //描述
            {
                return 166;
            }
                break;
            default:
                return 120;
                break;
        }

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 2;
    else
    {
        
        
        int count = picArr.count ;
        int lines = count/3 + (count%3 >0 ?1:0);
        
        return 5+lines;
        
//        if ([misRate isEqualToString:@"100"]) {
//            
//            if ([dealResult isEqualToString:@"转白名单"]) {
//                lines = lines + 1;
//            }
//            
//            return 4 + lines;
//
//        }else{
//            return 3 + lines;
//
//        }
    }
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
    if (indexPath.section == 0) {
        
        NSDictionary *dc;
        if (indexPath.row == 0) {
            dc = @{@"name":@"报警名称：",@"value":TOSTRING(misstionDic[@"name"])};
        }else{
            dc = @{@"name":@"报警描述：",@"value":TOSTRING(misstionDic[@"description"])};
        }
        
        AlarmNewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmNewCellTableViewCell"];
        [cell setData:dc];
        return  cell;
    }else{
        
        if (indexPath.row == 0) {
            MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"name"] =@"处理时间";
            dic[@"value"] = misDT;
            dic[@"placeholder"] = @"请选择时间";
            weak_self(ws);
            [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                            
                
                
                        } andBlock2:^(id x) {
                            pickerV.tag = 100;
                            [pickerV setDatePickerMode:UIDatePickerModeDateAndTime];
                            pickerV.hiddenCustomPicker = NO;
                            [ws dismissAllKeyBoardInView:tableView];
                            
                            
                        }];
            return cell;

        }
        if (indexPath.row == 1) {
            MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"name"] =@"完成进度";
            dic[@"value"] = misRate;
            dic[@"rate1"] = misstionDic[@"rate1"];
            dic[@"placeholder"] = @"请输入百分比";

            [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                if (  [x intValue]  >= [misstionDic[@"rate1"] intValue] &&  [x intValue]  <= 100  ) {

                    NSString *oldx = TOSTRING(x);
                    NSString *newx = TOINTSTRING([x intValue]);
                    if (![oldx isEqualToString:newx]) {
                        [cell setContentX:newx];
                    }
                    misRate = newx;
                    
                    if ([misRate isEqualToString:@"100"]) {
                    
                        if ([dealResult isEqualToString:@""] || [dealResult isEqualToString: @"----"]) {
                            NSMutableArray*statusArr = [NSMutableArray array];
                            [statusArr addObject:@{@"id":@"", @"name":@"----"}];
                            
                            for (NSDictionary*user in misstionDic[@"dealResultChoice"]) {
                                [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
                            }
                            
                            [self.dealPickerV setType:PickerTypeOne andTag:8000 andDatas:statusArr];
                            self.dealPickerV.hiddenCustomPicker = NO;
                        }
                        [tableView reloadData];
                        
                        
                    }else{
                        [tableView reloadData];

                    }
                }else{
                    misRate = misstionDic[@"rate1"];
                    [tableView reloadData];

//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } andBlock2:^(id x) {
                
            }];
            return cell;

        }else if (indexPath.row == 2) {
            MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"name"] =@"处理结果";
            dic[@"value"] = dealResult;
            dic[@"placeholder"] = @"请选择处理结果";
            weak_self(ws);
            [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                
                
              
                
            } andBlock2:^(id x) {
                
                [ws dismissAllKeyBoardInView:tableView];
                NSMutableArray*statusArr = [NSMutableArray array];
                [statusArr addObject:@{@"id":@"", @"name":@"----"}];
                
                for (NSDictionary*user in misstionDic[@"dealResultChoice"]) {
                    [statusArr addObject:@{@"id":user[@"value"], @"name":user[@"name"]}];
                }
                
                [self.dealPickerV setType:PickerTypeOne andTag:8000 andDatas:statusArr];
                self.dealPickerV.hiddenCustomPicker = NO;
                
            }];
            return cell;
            

        }else if (indexPath.row ==  3)//截止时间
        {
            MissDealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissDealCell"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"name"] =@"白名单截止时间";
            dic[@"value"] = baiDT;
            dic[@"placeholder"] = @"请选择时间";
            weak_self(ws);
            [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                            
                
                
                        } andBlock2:^(id x) {
                            
                                pickerV.tag = 200;
                                [pickerV setDatePickerMode:UIDatePickerModeDate];
                            
                            pickerV.hiddenCustomPicker = NO;
                            [ws dismissAllKeyBoardInView:tableView];
                            
                            
                        }];
            return cell;
        }else if (indexPath.row ==  4) {
            ErrorInputTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"name"] =@"处理描述";
            dic[@"value"] = misNote;
            [cell setDataAndName:dic andCanEdit:YES andBlock:^(id x) {
                
                misNote = x;
                
                    } andBlock2:^(id x) {
                        
                    }];
            return cell;
        }else{
           
            
            
            weak_self(ws);
            CheckUpImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckUpImgCell"];
            
            int oriLine = indexPath.row - 5;

            
            NSMutableArray *tmppicArr = [[NSMutableArray alloc] init];
            
            for (int i =oriLine*3; i<MIN(picArr.count, oriLine*3+3); i++) {
                
                [tmppicArr addObject:picArr[i]];
            }
            
            int x1 = 0;

            cell.tag = x1 * 1000;

            [cell setData2:tmppicArr  canEdit:YES andBlock:^(id x) {
                int index = [x intValue];
                
                if(index >= 1000)
                {
                    NSLog(@"新增图片%d",index-1000);
//                        ws
                    [ws showActions];
                    
//                    [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:@(index-1000) andtype:3];

                }else{
                    NSMutableArray *datas = [NSMutableArray array];
                    YBIBImageData *data = [YBIBImageData new];

                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString*  documentsPath = [paths objectAtIndex:0];
                    
                    NSData *imgD = UIImageJPEGRepresentation([tmppicArr objectAtIndex:index], 0.5f);
                    documentsPath = [NSString stringWithFormat:@"%@/%@%f.jpg", documentsPath, @"tmp111",[[NSDate date] timeIntervalSince1970]];
                    [imgD writeToFile:documentsPath atomically:YES];
                    
                    NSURL *url = [NSURL fileURLWithPath:documentsPath]; //文件下载地址
                    data.imageURL  = url;
                    
                    data.projectiveView = [cell viewWithTag:1000+index];
                    [datas addObject:data];
                    
                    YBImageBrowser *browser = [YBImageBrowser new];
                    browser.dataSourceArray = datas;
                    browser.currentPage = 1;

                    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                    [browser show];
                }
            } andDelImgBlock:^(id x) {
                int index = [x intValue];

                int oriIndex = oriLine*3 + index;
                NSLog(@"删除图片%d",oriIndex);
                [picArr removeObjectAtIndex:oriIndex];
                [ws.mainTableV reloadData];
//                [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:1];

            }];
            
            return cell;
        
        }
        return [[UITableViewCell alloc]init];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)pickerViewSureClick:(CustomDatePicker *)v{
    
    
    NSDate *date = v.customDate;
    
    
    if (v.tag == 100) {
        //获取系统当前时间
        NSDate *currentDate = date;
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        //输出currentDateString<span style="font-family: 'Helvetica Neue', Helvetica, 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif; line-height: 25.6000003814697px; white-space: pre-wrap;">NSLog(@"%@",currentDateString);</span>

        
        
        misDT = currentDateString;
        
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        NSLog(@"%@",date);
    }else if (v.tag == 200){
        //获取系统当前时间
        NSDate *currentDate = date;
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
        baiDT = [currentDateString stringByAppendingString:@" 23:59:59"];
        
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        NSLog(@"%@",date);
    }
    
    
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
    [parmDic setObject:missId forKey:@"alarmMonitorId"];

   

    NSMutableArray*filesArr = [NSMutableArray array];
    if ([misDT isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择处理时间"];
        return;
    }
    if ([misRate isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入进度"];
        return;
    }
    
    
    misRate = TOINTSTRING([misRate intValue]);
//    ["missionTraceId", "dealTime", "dealNote", "rate", "fileList"])   dealResult
    parmDic[@"dealTime"] = misDT;
    parmDic[@"rate"] = misRate;
    parmDic[@"description"] = misNote;
    parmDic[@"dealResult"] = dealResult;
    parmDic[@"fileList"] = @"[]";
    
    
    
    if ([misRate isEqualToString:@"100"]) {
        if ([dealResult isEqualToString:@""] || [dealResult isEqualToString: @"----"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择处理结果"];
            return;
        }
        
        if ([dealResult isEqualToString:@"转白名单"] && [baiDT isEqualToString: @""]) {
            [SVProgressHUD showErrorWithStatus:@"请选择白名单截止时间"];
            return;
        }
        parmDic[@"finishTime"] = baiDT;

        parmDic[@"dealResult"] = dealResult;
    }else{
        parmDic[@"dealResult"] = @"";
    }
    if ([misNote isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入处理描述"];
        return;
    }
    if ([misRate isEqualToString:@"100"]) {
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:String(@"提示") message:String(@"进度100%时,请确认已完成该任务！") preferredStyle:UIAlertControllerStyleAlert] ;


        UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:String(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"UIAlertActionStyleDestructive");

           
            if (picArr.count>1) {
                [SVProgressHUD showProgress:0 status:@"正在上传图片..."  ];
                __block int success = 0;
                __block int faild = 0;
                
                
                
                printf("处理前创建信号量，开始循环异步请求操作\n");

                // 1.创建一个串行队列，保证for循环依次执行
                dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);

                // 2.异步执行任务
                dispatch_async(serialQueue, ^{
                    // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                   
                    for (id object in picArr) {
                        if ([object isKindOfClass: [UIImage class]]) {
                            
                            NSLog(@"------ 上传图片%d",success);
                            BHttpRequest * helper = [BHttpRequest new];
                            helper.needShowHud = @0;
                            /////// uiload 。。。。。。
                            [helper startUploadImage2:object  withP: @{} uri:@"mobile/alarm_monitor/single_file_upload" result:^(BResponseModel * _Nonnull respModel) {
                               
                                NSLog(@"本次耗时操作完成，信号量+1 %@\n",[NSThread currentThread]);
                                dispatch_semaphore_signal(sema);
                                
                                if (respModel.success) {
                                    success = success +1;
                                    [filesArr addObject:respModel.data];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [SVProgressHUD showProgress:(float)success/(picArr.count-1) status:[NSString stringWithFormat:@"正在上传图片%d/%d",success,(picArr.count-1) ] ];
                                    });
                                    

                                }else{
                                    faild = faild + 1;
                                   // [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                                }
                            }];
                            
                            
                            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                        }

                    }

                   
                    
                    NSLog(@"其他操作");
                    
                    if (success != picArr.count - 1) {
                        
                        [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重试！"];
                        return;
                    }
                    
                    parmDic[@"fileList"] = [filesArr JSONString];
                    requestHelper.needShowHud =@1;
                    [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/deal" result:^(BResponseModel * _Nonnull respModel) {
                        if (respModel.success) {
                            [SVProgressHUD showSuccessWithStatus:respModel.message];
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

        //                    [picArr removeAllObjects];
        //                    [picArr addObject:@""];
        //                    misNote = @"";
        //
        //                    [self.mainTableV.mj_header beginRefreshing];

                        }else{
                            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                        }
                    }];
                    
                    
                });
                
            }else{
                
                requestHelper.needShowHud =@1;
                
                [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/deal" result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        [SVProgressHUD showSuccessWithStatus:respModel.message];
                        [self.navigationController popViewControllerAnimated:YES];

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

                        //发送通知
                        
        //                [picArr removeAllObjects];
        //                [picArr addObject:@""];
        //                misNote = @"";
        //
        //                [self.mainTableV.mj_header beginRefreshing];

                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }
                }];
            }

        }];
        UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:String(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            NSLog(@"UIAlertActionStyleDestructive");


        }];
        [alertController addAction: destructiveBtn];
        [alertController addAction: cancelBtn];

        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSLog(@"UIAlertActionStyleDestructive");

       
        if (picArr.count>1) {
            [SVProgressHUD showProgress:0 status:@"正在上传图片..."  ];
            __block int success = 0;
            __block int faild = 0;
            
            
            
            printf("处理前创建信号量，开始循环异步请求操作\n");

            // 1.创建一个串行队列，保证for循环依次执行
            dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);

            // 2.异步执行任务
            dispatch_async(serialQueue, ^{
                // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
               
                for (id object in picArr) {
                    if ([object isKindOfClass: [UIImage class]]) {
                        
                        NSLog(@"------ 上传图片%d",success);
                        BHttpRequest * helper = [BHttpRequest new];
                        helper.needShowHud = @0;
                        /////// uiload 。。。。。。
                        [helper startUploadImage2:object  withP: @{} uri:@"mobile/alarm_monitor/single_file_upload" result:^(BResponseModel * _Nonnull respModel) {
                           
                            NSLog(@"本次耗时操作完成，信号量+1 %@\n",[NSThread currentThread]);
                            dispatch_semaphore_signal(sema);
                            
                            if (respModel.success) {
                                success = success +1;
                                [filesArr addObject:respModel.data];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showProgress:(float)success/(picArr.count-1) status:[NSString stringWithFormat:@"正在上传图片%d/%d",success,(picArr.count-1) ] ];
                                });
                                

                            }else{
                                faild = faild + 1;
                               // [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                            }
                        }];
                        
                        
                        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                    }

                }

               
                
                NSLog(@"其他操作");
                
                if (success != picArr.count - 1) {
                    
                    [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重试！"];
                    return;
                }
                
                parmDic[@"fileList"] = [filesArr JSONString];
                requestHelper.needShowHud =@1;
                [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/deal" result:^(BResponseModel * _Nonnull respModel) {
                    if (respModel.success) {
                        [SVProgressHUD showSuccessWithStatus:respModel.message];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

    //                    [picArr removeAllObjects];
    //                    [picArr addObject:@""];
    //                    misNote = @"";
    //
    //                    [self.mainTableV.mj_header beginRefreshing];

                    }else{
                        [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                    }
                }];
                
                
            });
            
        }else{
            
            requestHelper.needShowHud =@1;
            
            [requestHelper startRequest:parmDic uri:@"mobile/alarm_monitor/deal" result:^(BResponseModel * _Nonnull respModel) {
                if (respModel.success) {
                    [SVProgressHUD showSuccessWithStatus:respModel.message];
                    [self.navigationController popViewControllerAnimated:YES];

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmDealSuccess" object:nil];

                    //发送通知
                    
    //                [picArr removeAllObjects];
    //                [picArr addObject:@""];
    //                misNote = @"";
    //
    //                [self.mainTableV.mj_header beginRefreshing];

                }else{
                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
                }
            }];
        }

    }
    
    
    
    
    
}







- (void)showActions{
   weak_self(ws)
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//       [ws.navigationController popViewControllerAnimated:YES];
   }];
   UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [ws openLibary];
   }];
   UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [ws openCamera];
   }];
   [alertController addAction:cancelAction];
   [alertController addAction:okAction];
   [alertController addAction:resetAction];
   [self presentViewController:alertController animated:YES completion:nil];
}
- (void)openLibary{
   if (![self isLibaryAuthStatusCorrect]) {\
       [SVProgressHUD showErrorWithStatus:@"需要相册权限"];
       return;
   }
   _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    _imagePicker.allowsEditing = false ;// 是否允许编辑
//    _imagePicker.allowsMultipleSelection = true ;// 设置为多选
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)openCamera{
   if (![self statusCheck]) {
//       [SVProgressHUD showErrorWithStatus:@"需要相册权限"];
       return;
   }
   _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

   [self presentViewController:self.imagePicker animated:YES completion:nil];
}
- (BOOL)isLibaryAuthStatusCorrect{
   PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
   if (authStatus == PHAuthorizationStatusNotDetermined || authStatus == PHAuthorizationStatusAuthorized) {
       return YES;
   }
   return NO;
}

- (BOOL)statusCheck{
    if (![self isCameraAvailable]){
        [SVProgressHUD showErrorWithStatus:@"设备无相机——设备无相机功能，无法进行扫描"];
        return NO;
    }
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) {
        [SVProgressHUD showErrorWithStatus:@"设备相机错误——无法启用相机，请检查"];
        return NO;
    }
    if (![self isCameraAuthStatusCorrect]) {
        [SVProgressHUD showErrorWithStatus:@"未打开相机权限 ——请在“设置-隐私-相机”选项中，允许滴滴访问你的相机"];
        return NO;
    }
    return YES;
}


- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isCameraAuthStatusCorrect{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}


#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo{
    weak_self(ws);
    requestHelper.needShowHud =@1;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

}

- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        
//    weak_self(ws);
    [picArr removeLastObject];
    
    [picArr addObject:image];
    [picArr addObject:@""];

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    [mainTableV reloadData];

}




#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if(v.tag == 8000)
    {
        dealResult = array[0][@"id"];
        [mainTableV reloadData];
//        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//        currentDate =
    }
    
}


@end
