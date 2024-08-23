//
//  CheckLocationViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckLocationViewController.h"
#import "SelectStationHeaderView.h"
#import "CheckPointTableViewCell.h"
#import "CheckModelTableViewCell.h"
#import "MarkAlert.h"
#import "SendErrorViewController.h"
#import "PointErrorsViewController.h"
#import "ModelDevicesViewController.h"
#import "CheckUpImgCell2.h"
#import "YBImageBrowser.h"
#import "ErrorInputTableViewCell.h"
@interface CheckLocationViewController ()<CLLocationManagerDelegate>
{
    NSMutableDictionary *checkWork,*location;
    SelectStationHeaderView * headView;
    UITableViewCell *tmpCell;
    id tmpExValue;
    NSIndexPath *tmpIndexPath;
    NSString * locationString,*city;
    CheckUpDetailViewController *myFatherV;
}
@property(nonatomic,readwrite)BOOL added,isLoaded;

@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation CheckLocationViewController


- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary*)lo andFather:(CheckUpDetailViewController*)faV;
{
    if (self = [super init]) {
        checkWork = [NSMutableDictionary dictionaryWithDictionary:check];
        location = [NSMutableDictionary dictionaryWithDictionary:lo];
        myFatherV = faV;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mainTableV.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];

    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.title = location[@"name"];
    weak_self(ws)
    NSString *title = @"当前电站";
    headView = [[SelectStationHeaderView alloc] initWithTitle:title andButtonClick:^(id x) {
        
    }];
    [headView hideBtn];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckPointTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckPointTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckModelTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckModelTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckUpImgCell2" bundle:nil] forCellReuseIdentifier:@"CheckUpImgCell2"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];

    // Do any additional setup after loading the view.
}




- (void)getData:(id)sender{
    
    [mainTableV.mj_header endRefreshing];
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *ruleItems = location[@"ruleItems"];
    if (indexPath.row < ruleItems.count)  {
       
        NSString *desc = ruleItems[indexPath.row][@"rules"];
        
        CGFloat width = MAINSCREENWIDTH-20-80;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        
        return labelsize.height + 90;
    }else if (indexPath.row == ruleItems.count )
    {
        return 100;
    }else
    {
        return 120;
    }
    
    return 66;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [location[@"ruleItems"] count] + 2 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section!=0) {
        return .1f;
//    }
//    return 44+5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section!=0){
        return nil;
//    }
//    [headView setNameLabel:self.dataModel.data[@"check_detail"][@"location_name"]];
//    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *ruleItems = location[@"ruleItems"];
    
    if (indexPath.row < ruleItems.count) {
        CheckModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckModelTableViewCell"];
        NSDictionary *rule = ruleItems[indexPath.row];
        
        [cell setData:rule andBlock:^(id x) {
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:rule];
            newDic[@"value"] = x;
            NSMutableArray *newArr = [[NSMutableArray alloc] initWithArray:ruleItems];
            [newArr replaceObjectAtIndex:indexPath.row withObject:newDic];
            location[@"ruleItems"] = newArr;
            location[@"checkFlag"] = @(1);
        }];
        return cell;

    }else{
        if (indexPath.row == ruleItems.count) {
            
            CheckUpImgCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckUpImgCell2"];
            NSArray *imgList = location[@"imgList"];
            weak_self(ws)
            
            [cell setData:location  canEdit:YES andBlock:^(id x) {
                int index = [x intValue];
                
                if(index >= 1000)
                {
                    NSLog(@"新增图片%d",index-1000);
//                        ws
                    
                    [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:@(index-1000) andtype:3];

                }else{
                    NSMutableArray *datas = [NSMutableArray array];
//                    for (NSString * urlstring in imgList) {
                        NSURL *url = [NSURL URLWithString:API_FILE_URL([imgList[index] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
                        YBIBImageData *data = [YBIBImageData new];
                        data.imageURL = url;
                        data.projectiveView =[cell viewWithTag:1000+index];
                        [datas addObject:data];
//                    }
                    
                    YBImageBrowser *browser = [YBImageBrowser new];
                    browser.dataSourceArray = datas;
                    browser.currentPage = 1;
                    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                    [browser show];
                }
            } andDelImgBlock:^(id x) {
                NSLog(@"删除图片%@",x);
                [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:1];

            }];
            
            return cell;
            
            //tupian
        }else{
            //beizhu
            //没有子集，只有一个input框
            weak_self(ws)
            ErrorInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
            
            [cell setData:@{@"value":location[@"note"]} andCanEdit:YES andBlock:^(id x) {
                float h = kNavigationHeight + kBottomSafeAreaHeight;
                ws.mainTableV.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT-h- 44*0 + 2) ;
                location[@"checkFlag"] = @(1);
                [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:2];
            }andBlock2:^(id x) {
                location[@"checkFlag"] = @(1);
                float h = kNavigationHeight + kBottomSafeAreaHeight;
                ws.mainTableV.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT-h- 44*0 + 2 - 256) ;
                            [ws.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

            }];
            return cell;
        }
        return [[UITableViewCell alloc] init];
//        NSDictionary * point = model[@"point"][indexPath.row - 1];
//        CheckPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckPointTableViewCell"];
//        weak_self(ws)
//        [cell setData:point andBlock:^(id x) {
//            UISegmentedControl *control = x;
//            if (control.selectedSegmentIndex == 0) {
//                
//                [ws performRuleAlert:point andIndexPath:indexPath andToValue:control.selectedSegmentIndex];
//            }else{
//                [ws changeCheckPoint:point andIndexPath:indexPath andToValue:control.selectedSegmentIndex];
//            }
//        } andLeftClick:^(id x) {
//            SendErrorViewController *se = [[SendErrorViewController alloc] initWithCheck:checkWork andLocation:model andPoint:point andError:nil];
//            [ws.navigationController pushViewController:se animated:YES];
////                [SVProgressHUD showErrorWithStatus:@"left"];
//
//        } andRightClick:^(id x) {
//            PointErrorsViewController *se = [[PointErrorsViewController alloc] initWithCheck:checkWork andLocation:model andPoint:point];
//            [ws.navigationController pushViewController:se animated:YES];
//            
//        }];
//        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * model = self.dataModel.data[@"check_detail"][@"modelList"][indexPath.section];
    if (indexPath.row == 0) {
        
    }else{
        
        
    }
    
}

- (void)changeCheckPoint:(NSDictionary*)point andIndexPath:(NSIndexPath*)indexPath andToValue:(NSInteger)va{

    NSString *isNormal = @"-1";
    NSString *value = @"-1";
    if (va==0) {
        //无异常
        isNormal = @"0";
        value = @"1";
    }else if(va==2){
        
    }
    
    weak_self(ws);
     [requestHelper stop];
     NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
     [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
    [parmDic setObject:TOSTRING(location[@"location_id"]) forKey:@"location_id"];
    
    [parmDic setObject:TOSTRING(point[@"id"]) forKey:@"point_id"];

    [parmDic setObject:value forKey:@"point_value"];
    [parmDic setObject:isNormal forKey:@"point_isNormal"];

     requestHelper.needShowHud =@1;
     [requestHelper startRequest:parmDic uri:API_CHECK_MISSION_LOCATION_POINT_SAVE result:^(BResponseModel * _Nonnull respModel) {
         if (respModel.success) {
         }else{
             [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
         }
         

         NSMutableDictionary *newPoint = [NSMutableDictionary dictionaryWithDictionary:point];
         newPoint[@"value"]= value;
         newPoint[@"isNormal"] = isNormal;
         
         NSMutableArray *newPointList = [NSMutableArray arrayWithArray:ws.dataModel.data[@"check_detail"][@"modelList"][indexPath.section][@"point"]];
         
         NSMutableArray *newModelList = [NSMutableArray arrayWithArray:ws.dataModel.data[@"check_detail"][@"modelList"]];
         NSMutableDictionary*newModel = [NSMutableDictionary dictionaryWithDictionary:ws.dataModel.data[@"check_detail"][@"modelList"][indexPath.section]];
         NSMutableDictionary*newDetail = [NSMutableDictionary dictionaryWithDictionary:ws.dataModel.data[@"check_detail"]];
        
        
         [newPointList replaceObjectAtIndex:indexPath.row-1 withObject:newPoint];
         newModel[@"point"] =newPointList;
         [newModelList replaceObjectAtIndex:indexPath.section withObject:newModel];
         newDetail[@"modelList"] = newModelList;
         BResponseModel *model = [[BResponseModel alloc] init];
         NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:ws.dataModel.data];
         newData[@"check_detail"] = newDetail;
         model.data = newData;
         ws.dataModel = model;
        
         [ws.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
     }];
    
}




// 刷新数据
- (void)resetDataWithSection:(int)section row:(int)row andCell:(UITableViewCell*)cell andEx:(id)exValue andtype:(int)type  
//0:seg 1:img del 2:input 3:img new  4:up img
{
    location[@"checkFlag"] = @(1);

    NSArray *ruleItems = location[@"ruleItems"];

    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithDictionary:ruleItems[section]];
    
    NSMutableArray * dataChildren = [[NSMutableArray alloc] initWithArray:data[@"children"]];

    int x1 = (int)cell.tag/1000;
    int x2 = cell.tag%1000;
    
    if(type == 0)
    {
        
        
//        data2[@"value"] = exValue;
//        
//        data2Children[x2] = data2;
//        
//        data1[@"children"] = data2Children;
//        dataChildren[x1] = data1;
//        
//        data[@"children"] = dataChildren;
//        loca[section] = data;
    }else if(type == 1){
        int index = [exValue intValue];
        NSMutableArray * imgListArr = [[NSMutableArray alloc] initWithArray:location[@"imgList"]];

        if (imgListArr.count == 0) {
//            [imgListArr addObject:exValue[1]];
        }else if (imgListArr.count == 1){
            
            [imgListArr removeAllObjects];
            
        }else{
            [imgListArr removeObjectAtIndex:index];
        }
        
        location[@"imgList"] = imgListArr;

    }else if(type == 2){
        location[@"note"] = exValue;
//        newCheckDataArray[section] = data;
        
        
    }else if (type ==3){
        tmpIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        tmpCell = cell;
        tmpExValue = exValue;
        
        
        [self showActions];
        
        return;
    }else if (type ==4){
        
        int index = [exValue[0] intValue];
        NSMutableArray * imgListArr = [[NSMutableArray alloc] initWithArray:location[@"imgList"]];
//        if (imgListArr.count == 0) {
//            [imgListArr addObject:exValue[1]];
//        }else if (imgListArr.count == 1){
//            [imgListArr addObject:exValue[1]];
//            
//            
//        }else{
            imgListArr[index] = exValue[1];
//        }
        
        location[@"imgList"] = imgListArr;
        
    }
    
    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
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
    requestHelper.needShowHud =@1;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
}
- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    NSData *imgD = UIImageJPEGRepresentation(image, 0.5f);
    if (imgD.length > 1024 * 1024 * 5) {
        imgD = UIImageJPEGRepresentation(image, 0.2f);
    }
    image =  [UIImage imageWithData:imgD];

    
    weak_self(ws);
    requestHelper.needShowHud =@1;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    
    if(city)
        if([[city substringFromIndex:city.length-1] isEqualToString:@"市"])
            city = [city substringToIndex:city.length-1];
        parmDic[@"city"] = city;
    if(locationString)
        parmDic[@"location"] = locationString;
    
    if(_added)
    {
        parmDic[@"longAndLat"] = [NSString stringWithFormat:@"%.6f,%.6f",
                                                           self.locationManager.location.coordinate.longitude,
                                  self.locationManager.location.coordinate.latitude];

    }

    [requestHelper startUploadImage:image withP:parmDic uri:API_ExternalPicUploadApi result:^(BResponseModel * _Nonnull resp) {
         if (resp.success) {
            [ws resetDataWithSection:tmpIndexPath.section row:tmpIndexPath.row andCell:tmpCell andEx:@[tmpExValue, resp.data[@"filePath"]] andtype:4];

            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:resp.errorMessage?resp.errorMessage:resp.message];
        }
    }];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    if ([location[@"checkFlag"] intValue] == 1) {
        [myFatherV nfcCheckEnd:location];
    }
}

- (CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter= 5.0f;//设备移动后获取位置信息的最小距离
        _locationManager.delegate=self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.added = NO;

//    locationString = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f\n高度:%3.5f",
//                             self.locationManager.location.coordinate.longitude,
//                             self.locationManager.location.coordinate.latitude,
//                             self.locationManager.location.altitude];
//    NSLog(@"%@",locationString);
    weak_self(ws)
    
    //创建CLGeocoder对象
       CLGeocoder *geocoder = [CLGeocoder new];
    
       //对应经纬度的详细信息(addressDictionary)
       [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
           if (error == nil) {
               for (CLPlacemark *placemark in placemarks) {
                   NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                   city = placemark.addressDictionary[@"City"];
                   
                   if (lines.count >0 && !ws.added)
                   {
                       ws.added = YES;
//                       locationString = [locationString stringByAppendingString:@"\n"];
                       locationString = placemark.addressDictionary[@"FormattedAddressLines"][0];
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
@end
