//
//  SendErrorViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "SendErrorViewController.h"
#import "CheckDetailTableHeader.h"
#import "CheckLocationCell.h"
#import "CheckDetailFootView.h"
#import "CheckLocationViewController.h"
#import "ZBarSDK.h"
#import "ErrorTableViewCell.h"
#import "ErrorInputTableViewCell.h"

@interface SendErrorViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate>
{
    NSDictionary *checkWork,*location,*point,*error;
    CheckDetailTableHeader *headV;
    CheckDetailFootView * footV;
    UIView *footV2;
    UIButton *confirmButton;
    NSDictionary *selectLocation;
    ZBarReaderViewController *zbarR;
    NSString *locationString;
    NSMutableDictionary *errorDiction;
}
@property(nonatomic,readwrite)BOOL added,isLoaded;
@property(nonatomic,strong)CheckDetailFootView * footV;

@end

@implementation SendErrorViewController

@synthesize footV;
@synthesize pickerV;
- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary *)lo andPoint:(NSDictionary*)po andError:(nonnull NSDictionary *)err
{
    if (self = [super init]) {
        checkWork = check;
        location = lo;
        point = po;
        error = err;
    }
    return self;
}

- (void)viewDidLoad {
    self.title = point[@"name"];
    weak_self(ws);
    self.isLoaded = NO;
    errorDiction = [[NSMutableDictionary alloc] init];
    errorDiction[@"label0"] = @"异常设备";
    errorDiction[@"label1"] = @"未符合标准";
    errorDiction[@"label2"] = @"问题描述";

   self.pickerV = [[CustomPicker alloc] init];
   self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
   self.pickerV.delegate = self;
    
    footV = [[CheckDetailFootView alloc] initWithTitle:@"设备照片" andButtonClick:^(id x) {
    
        UIImagePickerController *impV = [[UIImagePickerController alloc] init];
        impV.modalPresentationStyle = UIModalPresentationFullScreen;
        impV.sourceType = UIImagePickerControllerSourceTypeCamera;
        selectLocation = nil;

        impV.delegate = ws;
        [ws.navigationController presentViewController:impV animated:YES completion:^{
        
        }];
    }];
    
    footV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundColor:MAIN_TINIT_COLOR];
    confirmButton.frame = CGRectMake(10, 0, MAINSCREENWIDTH-20, 44);
    [confirmButton setTitle:@"提交" forState:UIControlStateNormal];
//    confirmButton.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    [footV2 addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [super viewDidLoad];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];
   
}
- (void)confirmClick:(UIButton*)sender{
    if (!errorDiction[@"device_id"]) {
        [SVProgressHUD showErrorWithStatus:String(@"请选择异常设备")];
        return;
    }
    if (!errorDiction[@"rule_name"]) {
       [SVProgressHUD showErrorWithStatus:String(@"请选择未符合的规则")];
       return;
   }
    if (!errorDiction[@"note"] || [errorDiction[@"note"] isEqualToString:@""]) {
       [SVProgressHUD showErrorWithStatus:String(@"请添加问题描述")];
       return;
   }
    if (!errorDiction[@"img_path"]) {
          [SVProgressHUD showErrorWithStatus:String(@"请上传照片")];
          return;
      }
    
    
    weak_self(ws);
     [requestHelper stop];
     NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
     [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
    [parmDic setObject:TOSTRING(location[@"id"]) forKey:@"location_id"];
    [parmDic setObject:TOSTRING(point[@"id"]) forKey:@"point_id"];
    [parmDic setObject:TOSTRING(errorDiction[@"device_id"]) forKey:@"device_id"];
    if (!error) {
            [parmDic setObject:@"0" forKey:@"mission_error_id"];
    }else{
        [parmDic setObject:TOSTRING(error[@"id"]) forKey:@"mission_error_id"];
    }
    [parmDic setObject:errorDiction[@"rule_name"] forKey:@"rule"];
    [parmDic setObject:errorDiction[@"img_path"] forKey:@"path"];
    [parmDic setObject:errorDiction[@"note"] forKey:@"note"];

     requestHelper.needShowHud =@0;
     [requestHelper startRequest:parmDic uri:API_CHECK_POINT_ERROER_SAVE result:^(BResponseModel * _Nonnull respModel) {
         if (respModel.success) {
             [SVProgressHUD showSuccessWithStatus:@"成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [ws.navigationController popViewControllerAnimated:YES];
             });
         }else{
             [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
         }
         [ws.mainTableV.mj_header endRefreshing];
         [ws.mainTableV reloadData];
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.mainTableV.mj_header.isRefreshing) {
        [self.mainTableV.mj_header beginRefreshing];
    }
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
        _locationManager.distanceFilter=1000.0f;//设备移动后获取位置信息的最小距离
        _locationManager.delegate=self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.added = NO;

    locationString = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f\n高度:%3.5f",
                             self.locationManager.location.coordinate.longitude,
                             self.locationManager.location.coordinate.latitude,
                             self.locationManager.location.altitude];
    NSLog(@"%@",locationString);
    weak_self(ws)
    
    //创建CLGeocoder对象
       CLGeocoder *geocoder = [CLGeocoder new];
    
       //对应经纬度的详细信息(addressDictionary)
       [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
           if (error == nil) {
               for (CLPlacemark *placemark in placemarks) {
                   NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                   if (lines.count >0 && !ws.added)
                   {
                       ws.added = YES;
                       locationString = [locationString stringByAppendingString:@"\n"];
                       locationString = [locationString stringByAppendingString:placemark.addressDictionary[@"FormattedAddressLines"][0]];
                   }
                   NSLog(@"%@",locationString);

                   
               }
           }
       }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"E:%@",error);
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler;
{
    
}


- (void)getData:(id)sender{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    if (!error) {
        [self.mainTableV.mj_header endRefreshing];
        return;
    }else{
        if (self.isLoaded) {
            [self.mainTableV.mj_header endRefreshing];
            return;
        }
    }
    
    weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:TOSTRING(error[@"id"]) forKey:@"mission_error_id"];

    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:API_CHECK_POINT_ERROER_DETAIL result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
            ws.isLoaded = YES;
            errorDiction[@"note"] = ws.dataModel.data[@"mission_error_data"][@"note"];
            
            errorDiction[@"rule_name"] = ws.dataModel.data[@"mission_error_data"][@"rule"];
            errorDiction[@"device_id"] = ws.dataModel.data[@"mission_error_data"][@"device_id"];
            errorDiction[@"device_name"] = ws.dataModel.data[@"mission_error_data"][@"device_name"];
            errorDiction[@"img_path"] = ws.dataModel.data[@"mission_error_data"][@"path"];
            [ws.mainTableV reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        
    }];
    
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 144;
    }
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (error) {
        if (self.dataModel) {
            return 2;
        }else{
            return 0;
        }
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 264;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        [footV setData:@{@"fatigueName":@"请拍摄未符合标准的设备照片",@"fatiguePath":errorDiction[@"img_path"]?errorDiction[@"img_path"]:@""}];
        return footV;
    }else{
        return footV2;
    }
//    if (self.dataModel)
//    {
//        [footV setData:self.dataModel.data[@"check_detail"]];
//        return footV;
//    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorTableViewCell"];
        cell.tag = 0;
        [cell setData:errorDiction andBlock:^(id x) {
            
            NSMutableArray *stationArray = [[NSMutableArray alloc] init];
             [stationArray addObjectsFromArray:location[@"device"]];
             [self.pickerV setType:PickerTypeOne andTag:0 andDatas:stationArray];
             self.pickerV.hiddenCustomPicker = NO;
            
        }];
        return cell;
    }else if (indexPath.row == 1){
        ErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorTableViewCell"];
        cell.tag = 1;
        [cell setData:errorDiction andBlock:^(id x) {
            NSMutableArray *stationArray = [[NSMutableArray alloc] init];
            for (NSString *s in point[@"rule"]) {
                [stationArray addObject:@{@"name":s}];
            }
            [self.pickerV setType:PickerTypeOne andTag:1 andDatas:stationArray];
            self.pickerV.hiddenCustomPicker = NO;

        }];
        return cell;
    }else {
        ErrorInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
        cell.tag = 2;
       [cell setData:errorDiction andBlock:^(id x) {
           errorDiction[@"note"] = (NSString *)x;

       }];
       return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
    [requestHelper startUploadImage:image withP:parmDic uri:API_CHECK_MISSION_FILE_UPLOAD result:^(BResponseModel * _Nonnull resp) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [ws.footV setImage:image orUrl:nil];
        }];
        
    }];
}
- (void)  imagePickerController: (UIImagePickerController*) picker
didFinishPickingMediaWithInfo: (NSDictionary*) info
{
        UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        
        image = [image imageWithStringRightBottom:[NSString stringWithFormat:@"%@ %@\n%@",[BAPIHelper getUserInfo][@"username"],[[NSDate date] portableString],locationString]];
        
        weak_self(ws);
        requestHelper.needShowHud =@1;
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

        [requestHelper startUploadImage:image withP:parmDic uri:API_CHECK_SIMPLE_FILR_UPLOAD result:^(BResponseModel * _Nonnull resp) {
            if (resp.success) {

                errorDiction[@"img_path"] = resp.data[@"path"];
                [picker dismissViewControllerAnimated:YES completion:^{
                    [ws.footV setImage:image orUrl:nil];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:resp.errorMessage?resp.errorMessage:resp.message];
            }
            
            
        }];
  
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
withRetry: (BOOL) retry
{
    
}


#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 0) {
        errorDiction[@"device_name"] = array[0][@"name"];
        errorDiction[@"device_id"] = array[0][@"id"];
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }else  if (v.tag == 1) {
        errorDiction[@"rule_name"] = array[0][@"name"];
        [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    
}

@end
