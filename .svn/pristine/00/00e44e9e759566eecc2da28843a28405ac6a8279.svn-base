//
//  NewLocationViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/14.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "NewLocationViewController.h"
#import "CustomPicker.h"
#import "WriteNFCViewController.h"
@interface NewLocationViewController ()<UITextFieldDelegate,CustomPickerDelegate>
{
    NSDictionary *stationDic;
    IBOutlet UIView *bgV;
    
    IBOutlet UITextField *deviceTextF;
    IBOutlet UITextField *locationNameTextF;
    IBOutlet UITextField *locationModelTextF;
    IBOutlet UITextField *locationTextF;
    IBOutlet UITextField *sortTextF;

    IBOutlet UIButton *conpleteBtn;
    
    NSMutableArray *allDeviceArr,*allModelArr,*currentModelArr;;
    NSDictionary*currentDevice,*currentModel;
}
@end

@implementation NewLocationViewController
@synthesize pickerV;
- (id)initWithStation:(NSDictionary *)staDic
{
    if (self = [super init]) {
        stationDic = [[NSDictionary alloc] initWithDictionary:staDic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增巡检点";
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    bgV.layer.cornerRadius  =  BUTTON_CORNERRADIUS;    // Initialization code

    bgV.layer.shadowColor =  MAIN_TINIT_COLOR.CGColor;
    bgV.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    bgV.layer.shadowOpacity = 1;
    // 设置阴影半径
    bgV.layer.shadowRadius = 1;
    bgV.clipsToBounds = NO;
    bgV.backgroundColor = [UIColor whiteColor];
    
    locationNameTextF.layer.borderColor = COLOR_TABLE_DES.CGColor;
    locationNameTextF.layer.borderWidth = 0.5f;
    locationNameTextF.layer.cornerRadius = 3.0f;
    locationNameTextF.clipsToBounds = YES;
    
    deviceTextF.layer.borderColor = COLOR_TABLE_DES.CGColor;
    deviceTextF.layer.borderWidth = 0.5f;
    deviceTextF.layer.cornerRadius = 3.0f;
    deviceTextF.clipsToBounds = YES;
    
    locationTextF.layer.borderColor = COLOR_TABLE_DES.CGColor;
    locationTextF.layer.borderWidth = 0.5f;
    locationTextF.layer.cornerRadius = 3.0f;
    locationTextF.clipsToBounds = YES;
    
    locationModelTextF.layer.borderColor = COLOR_TABLE_DES.CGColor;
    locationModelTextF.layer.borderWidth = 0.5f;
    locationModelTextF.layer.cornerRadius = 3.0f;
    locationModelTextF.clipsToBounds = YES;
    
    sortTextF.layer.borderColor = COLOR_TABLE_DES.CGColor;
    sortTextF.layer.borderWidth = 0.5f;
    sortTextF.layer.cornerRadius = 3.0f;
    sortTextF.clipsToBounds = YES;
    
    conpleteBtn.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    conpleteBtn.clipsToBounds = YES;
    conpleteBtn.backgroundColor = MAIN_TINIT_COLOR;
    
    
    [self getTemlateLazy];
    [self getAllDeviceLazy];
    [self getSortLazy];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}



- (CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter=5.0f;//设备移动后获取位置信息的最小距离
        _locationManager.delegate=self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    locationTextF.text = [NSString stringWithFormat:@"%.6f,%.6f", self.locationManager.location.coordinate.longitude,
                          self.locationManager.location.coordinate.latitude];
    NSString* locationString = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f\n高度:%3.5f",
                             self.locationManager.location.coordinate.longitude,
                             self.locationManager.location.coordinate.latitude,
                             self.locationManager.location.altitude];
    NSLog(@"%@",locationString);
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"E:%@",error);
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler;
{
    
}





- (void)getAllDeviceLazy{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    parmDic[@"stationId"] = stationDic[@"id"];
    
    BHttpRequest *req = [BHttpRequest new];
    req.needShowHud =@0;
    [req startRequest:parmDic uri:API_patrol_location_device_list result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            NSMutableArray *stationArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary * dic in respModel.data[@"list"]) {
                [stationArray addObject:@{@"name":dic[@"name"], @"list":dic[@"deviceList"]}];
            }
            allDeviceArr = [[NSMutableArray alloc] initWithArray:stationArray];
        }
    }];
}


- (void)getSortLazy{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    parmDic[@"stationId"] = stationDic[@"id"];
    
    BHttpRequest *req = [BHttpRequest new];
    req.needShowHud =@0;
    [req startRequest:parmDic uri:@"mobile/patrol_location_sort_by_station" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            sortTextF.text = TOSTRING(respModel.data[@"sort"]);
        }
    }];
}


- (void)getTemlateLazy{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    parmDic[@"stationId"] = stationDic[@"id"];
    
    BHttpRequest *req = [BHttpRequest new];
    req.needShowHud =@0;
    [req startRequest:parmDic uri:@"mobile/patrol_template_list" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            allModelArr = [[NSMutableArray alloc] initWithArray:respModel.data];
        }
    }];
}




- (IBAction)completeBtnClick:(id)sender {
    [sortTextF resignFirstResponder];
    [locationNameTextF resignFirstResponder];
    
    if (!currentDevice) {
        [SVProgressHUD showErrorWithStatus:@"请先选择设备"];
        return;
    }
    if ([locationNameTextF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请先输入巡检点名称"];
        return;
    }
    if (!currentModel) {
        [SVProgressHUD showErrorWithStatus:@"请先选择巡检点模型"];
        return;
    }
    if ([locationTextF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请开启定位"];
        return;
    }
    if ([sortTextF.text isEqualToString:@""] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入排序值"];
        return;
    }
   
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    requestHelper.needShowHud =@1;
    parmDic[@"id"] = @"0";
    parmDic[@"organizationId"] = stationDic[@"organization_id"];
    parmDic[@"stationId"] = stationDic[@"id"];
    parmDic[@"deviceId"] = currentDevice[@"id"];
    parmDic[@"name"] = locationNameTextF.text;
    parmDic[@"templateId"] = currentModel[@"id"];
    parmDic[@"position"] = locationTextF.text;
    parmDic[@"sort"] = sortTextF.text;

    [requestHelper startRequest:parmDic uri:@"mobile/patrol_location_save" result:^(BResponseModel * _Nonnull respModel) {
        
        if (respModel.success) {
            
            WriteNFCViewController*vc = [[WriteNFCViewController alloc] initWithString:respModel.data[@"nfc_code"] andBack:^(id x) {
                [SVProgressHUD showSuccessWithStatus:@"新增成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"POINTADDED" object:nil];

                [self.navigationController popViewControllerAnimated:YES];
            }];
            [ws presentModalViewController:vc animated:NO];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    

}






#pragma mark -- UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField == deviceTextF) {
        
        [sortTextF resignFirstResponder];
        [locationNameTextF resignFirstResponder];
        
        [self showDevice];
        
    }else if (textField == locationNameTextF){
        return YES;
    }else if (textField == locationModelTextF){
        [sortTextF resignFirstResponder];
        [locationNameTextF resignFirstResponder];
        [self showModels];

    }else if (textField == locationTextF){
        [sortTextF resignFirstResponder];
        [locationNameTextF resignFirstResponder];
        [self.locationManager startUpdatingLocation];
    }else if (textField == sortTextF){
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField == sortTextF) {
        int x = [sortTextF.text intValue];
        textField.text = [NSString stringWithFormat:@"%d",x];
    }
}


- (void)showDevice{
    if (allDeviceArr) {
        [self.pickerV setType:PickerTypeTwo andTag:100 andDatas:allDeviceArr];
        self.pickerV.hiddenCustomPicker = NO;
    }else{
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        
        parmDic[@"stationId"] = stationDic[@"id"];
        
        BHttpRequest *req = [BHttpRequest new];
        req.needShowHud =@1;
        [req startRequest:parmDic uri:API_patrol_location_device_list result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                NSMutableArray *stationArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary * dic in respModel.data[@"list"]) {
                    [stationArray addObject:@{@"name":dic[@"name"], @"list":dic[@"deviceList"]}];
                }
                allDeviceArr = [[NSMutableArray alloc] initWithArray:stationArray];
                
                [self.pickerV setType:PickerTypeTwo andTag:100 andDatas:allDeviceArr];
                self.pickerV.hiddenCustomPicker = NO;
            }
        }];
    }
    
 
    
}
- (void)showModels{
    if (!currentDevice) {
        [SVProgressHUD showErrorWithStatus:@"请先选择设备"];
        return;
    }
    
    if (currentModelArr.count > 0) {
        [self.pickerV setType:PickerTypeOne andTag:200 andDatas:currentModelArr];
        self.pickerV.hiddenCustomPicker = NO;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先维护巡检点模型！"];
    }
}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if(v.tag == 100)
    {
        deviceTextF.text = array[1][@"name"];
        currentDevice = [NSDictionary dictionaryWithDictionary:array[1]];
        
        locationNameTextF.text = [NSString stringWithFormat:@"%@-%@",stationDic[@"name"],currentDevice[@"name"]];
        
        currentModelArr = [[NSMutableArray alloc] init];
        for (NSDictionary*model in allModelArr) {
            if ([model[@"type"] isEqualToString:currentDevice[@"type"]]) {
                
                [currentModelArr addObject:model];
            }
        }
        
        if (currentModelArr.count > 0) {
            currentModel  = currentModelArr[0];
            locationModelTextF.text = currentModel[@"name"];
            
        }else{
            locationModelTextF.text = @"";
            currentModel = nil;
            [SVProgressHUD showErrorWithStatus:@"请先维护巡检点模型！"];
        }
    }else if (v.tag == 200){
        
        currentModel  =  array[0];
        locationModelTextF.text = currentModel[@"name"];

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

@end
