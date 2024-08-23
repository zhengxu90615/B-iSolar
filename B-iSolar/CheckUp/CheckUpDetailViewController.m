//
//  CheckUpDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckUpDetailViewController.h"
#import "CheckDetailTableHeader.h"
#import "CheckLocationCell.h"
#import "CheckDetailFootView.h"
#import "CheckLocationViewController.h"
#import "ZBarSDK.h"

@interface CheckUpDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,BMKMapViewDelegate,NFCNDEFReaderSessionDelegate>
{
    NSMutableDictionary *checkWork;
    CheckDetailTableHeader *headV;
    CheckDetailFootView * footV;
    NSDictionary *selectLocation;
    ZBarReaderViewController *zbarR;
    NSString *locationString;
    BOOL first;
    NSTimer *timer;
    BMKPolyline *polyline;
}
@property (nonatomic, strong) BMKMapView *mapView;

@property(nonatomic,readwrite)BOOL added;
@property(nonatomic,strong)CheckDetailFootView * footV;
@end

@implementation CheckUpDetailViewController
@synthesize footV;

- (id)initWithCheck:(NSDictionary *)check{
    if (self = [super init]) {
        checkWork = [[NSMutableDictionary alloc] initWithDictionary:check];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检任务";
    weak_self(ws);
    
    zbarR = [[ZBarReaderViewController alloc] init];
    
    headV = [[CheckDetailTableHeader alloc] initWithTitle:checkWork[@"station_name"] andButtonClick:^(id x) {
        
        if (@available(iOS 11.0,*)) {
            selectLocation = nil;
            if (NFCNDEFReaderSession.readingAvailable == YES) {
                if ([NFCNDEFReaderSession readingAvailable]) {
                    NFCNDEFReaderSession *session =
                    [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                             queue:nil
                                          invalidateAfterFirstRead:YES];
                    // 开始扫描
                    [session beginSession];
                }
            }else {
                [SVProgressHUD showErrorWithStatus:@"该机型不支持NFC功能!"];
            }
        }
    }];
        
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckLocationCell" bundle:nil] forCellReuseIdentifier:@"CheckLocationCell"];
    mainTableV.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT);
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, MAINSCREENHEIGHT/2, MAINSCREENWIDTH,  0.1)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.zoomLevel = 20;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
    
    
    [self upLbs];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(upLbs) userInfo:nil repeats:YES];
}
- (void)nfcCheckEnd:(NSDictionary*)location{
    
    NSArray *locations =  checkWork[@"missionJson"][@"locationList"];
    NSMutableArray *newLocations = [[NSMutableArray alloc] initWithArray:locations];
    
    for (int i = 0; i< locations.count; i++) {
        NSDictionary *tmpDic = locations[i];
        if ([location[@"nfcQRCode"] isEqualToString:tmpDic[@"nfcQRCode"]]) {
            [newLocations replaceObjectAtIndex:i withObject:location];
        }
    }
    NSMutableDictionary *missionJsonDic = [[NSMutableDictionary alloc] initWithDictionary:checkWork[@"missionJson"]];
    missionJsonDic[@"locationList"] = newLocations;
    
    checkWork[@"missionJson"] = missionJsonDic;
        
    
    
        weak_self(ws);
    [requestHelper stop];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:checkWork[@"id"] forKey:@"missionId"];
    [parmDic setObject:[missionJsonDic mj_JSONString] forKey:@"missionJson"];
    [parmDic setObject:@"0" forKey:@"missionStatus"];

        requestHelper.needShowHud =@1;
        [requestHelper startRequest:parmDic uri:API_CHECK_SAVE result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                ws.dataModel = respModel;
    
                [ws reloadMapAnnos];
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
    [self.locationManager startUpdatingHeading];
    

    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    [_mapView viewWillDisappear];
    [timer invalidate];
}


- (void)upLbs{
    NSLog(@"upLbs");
    if ([BAPIHelper getToken].length==0) {
        return;
    }
//    [self getCheckMissionTrail];

    if(self.userLocation.location.coordinate.longitude < 1 || self.userLocation.location.coordinate.latitude <1)
    {
        return;
    }
    
    BHttpRequest * apiBlock =  [[BHttpRequest alloc] initWithModel:nil respEntityName:nil];
    apiBlock.needShowHud =@0;
    
    NSMutableDictionary *pa = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    [location setObject:[NSString stringWithFormat:@"%.6f",self.userLocation.location.coordinate.longitude] forKey:@"lon"];
    [location setObject:[NSString stringWithFormat:@"%.6f",self.userLocation.location.coordinate.latitude] forKey:@"lat"];
    [location setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
    
    NSArray *locations = [NSArray arrayWithObject:location];
    
    NSArray *missionList = [NSArray arrayWithObject:@{@"missionId":checkWork[@"id"],@"locationList":locations}];
    
    [pa setObject:[missionList mj_JSONString] forKey:@"missionList"];

    [apiBlock startRequest:pa uri:API_setCheckMissionTrail result:^(BResponseModel * _Nonnull respModel) {
        NSLog(@"xxxx");
    }];
    
}

//- (void)getCheckMissionTrail{
//    NSLog(@"getCheckMissionTrail");
//    if ([BAPIHelper getToken].length==0) {
//        return;
//    }
//    BHttpRequest * apiBlock =  [[BHttpRequest alloc] initWithModel:nil respEntityName:nil];
//    apiBlock.needShowHud =@0;
//    
//    NSMutableDictionary *pa = [[NSMutableDictionary alloc] init];
//    [pa setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
//    weak_self(ws)
//    [apiBlock startRequest:pa uri:API_getCheckMissionTrail result:^(BResponseModel * _Nonnull respModel) {
//        [ws drawLines:respModel.data[@"positionList"]];
//    }];
//}

#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}


#pragma mark - BMKLocationManagerDelegate

/**
 @brief 连续定位回调函数。
 @param manager 定位BMKLocationManager类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
    
//    if (first) {
//        first = false;
        [self myLocation:nil];
//    }
}

- (IBAction)myLocation:(id)sender {
    
    [_mapView updateLocationData:self.userLocation];
    _mapView.showsUserLocation = YES;

    if (self.userLocation.location.coordinate.latitude < 0.00001 && self.userLocation.location.coordinate.latitude > -0.00001 ) {
        return;
    }
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    if (!self.userLocation) {
        self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
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
    [mainTableV.mj_header endRefreshing];
    [mainTableV reloadData];
//    weak_self(ws);
//    [requestHelper stop];
//    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
//    [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
//   
//    requestHelper.needShowHud =@0;
//    [requestHelper startRequest:parmDic uri:API_CHECK_DETAIL result:^(BResponseModel * _Nonnull respModel) {
//        if (respModel.success) {
//            ws.dataModel = respModel;
//            
//            [ws reloadMapAnnos];
//        }else{
//            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
//        }
//        [ws.mainTableV.mj_header endRefreshing];
//        [ws.mainTableV reloadData];
//    }];
    
}

- (void)reloadMapAnnos{
    
//    _mapView r
//    [_mapView addAnnotations:[self createAnnotations]];
    
}
- (NSArray<BMKPointAnnotation *> *)createAnnotations {
    
    NSMutableArray<BMKPointAnnotation *> *annotations = [NSMutableArray array];
    NSArray *locations = self.dataModel.data[@"check_detail"][@"check_location"];

    for (int i=0; i<locations.count; i++) {
        NSDictionary * obj = [locations objectAtIndex:i];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([obj[@"location_lat"] doubleValue], [obj[@"location_lng"] doubleValue]);
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coord;
        annotation.title = obj[@"location_name"];
//        annotation.subtitle = obj[@"location_str"];
        [annotations addObject:annotation];
    }
    return annotations;
}

#pragma mark BMKAnnotationView-- delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSString *annotationViewIdentifier = @"annotationViewIdentifier";
        BMKCustomAnnotationView *annotationView = (BMKCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            NSArray *locations = self.dataModel.data[@"check_detail"][@"check_location"];
            int sta = 0;
            for (int i=0; i<locations.count; i++) {
                NSDictionary * obj = [locations objectAtIndex:i];
                if ([obj[@"location_name"] isEqualToString:annotation.title]) {
                    sta = [obj[@"location_status"] intValue];
                }
            }
            annotationView = [[BMKCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier andStatus:sta];
        }
        annotationView.selected = NO;
        // 当拖拽当前的annotation时，当前annotation的泡泡是否隐藏，默认值为NO，V4.2.1以后支持
        annotationView.hidePaopaoWhenDrag = YES;
        // 当拖拽其他annotation时，当前annotation的泡泡是否隐藏，默认值为NO，V4.2.1以后支持
        annotationView.hidePaopaoWhenDragOthers = YES;
        // 当选中其他annotation时，当前annotation的泡泡是否隐藏，默认值为YES，V4.2.1以后支持
        annotationView.hidePaopaoWhenSelectOthers = YES;
        // 当发生双击地图事件时，当前的annotation的泡泡是否隐藏，默认值为NO，V4.2.1以后支持
        annotationView.hidePaopaoWhenDoubleTapOnMap = YES;
        // 当发生单击地图事件时，当前的annotation的泡泡是否隐藏，默认值为YES，V4.2.1以后支持
        annotationView.hidePaopaoWhenSingleTapOnMap = YES;
        // 当发生两个手指点击地图（缩小地图）事件时，当前的annotation的泡泡是否隐藏，默认值为NO，V4.2.1以后支持
        annotationView.hidePaopaoWhenTwoFingersTapOnMap = YES;
        return annotationView;
    }
    
    return nil;
}
        

#pragma mark -- 绘制运动轨迹

- (void)drawLines:(NSArray *)lines{
    if (lines.count == 0) {
        return;
    }
    
    NSInteger countIndex = lines.count;
    CLLocationCoordinate2D coords[countIndex];
    
    for (int i=0 ; i< lines.count; i++) {
        double lat = [[lines[i] objectForKey:@"lat"] doubleValue];
        double lng =  [[lines[i] objectForKey:@"lon"] doubleValue];
        coords[i] = CLLocationCoordinate2DMake(lat, lng);
    }
    if (polyline) {
        [_mapView removeOverlay:polyline];
        polyline = nil;
    }
    polyline = [BMKPolyline polylineWithCoordinates:coords count:[lines count]];
    [_mapView addOverlay:polyline];
}
                
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
         BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
         //设置polylineView的画笔颜色为蓝色
         polylineView.strokeColor = [[UIColor alloc] initWithRed:19/255.0 green:107/255.0 blue:251/255.0 alpha:1.0];
         //设置polylineView的画笔宽度为16
         polylineView.lineWidth = 2;
         //圆点虚线，V5.0.0新增
//        polylineView.lineDashType = kBMKLineDashTypeDot;
         //方块虚线，V5.0.0新增
//       polylineView.lineDashType = kBMKLineDashTypeSquare;
         return polylineView;
    }
    return nil;
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *locations = checkWork[@"missionJson"][@"locationList"];
    return [locations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44+5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    return 264;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (self.dataModel)
//    {
//        if ([TOSTRING(self.dataModel.data[@"check_detail"][@"check_status"]) isEqualToString:@"1"]) {
//            [headV setTitle:@"已完成" withBgColor:[UIColor grayColor] withTitleColor:[UIColor whiteColor]];
//        }else{
            [headV setTitle:checkWork[@"name"] andBtnTitle:@"NFC"  withBgColor:MAIN_TINIT_COLOR withTitleColor:[UIColor whiteColor]];
//        }
        return headV;
//    }
//    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataModel)
    {
//        [footV setData:self.dataModel.data[@"check_detail"]];
        return footV;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckLocationCell"];
    NSArray *locations =  checkWork[@"missionJson"][@"locationList"];
    NSDictionary *location = locations[indexPath.row];
        Location_location lo = Location_location_Normal;
    if (indexPath.row == 0){
        lo = Location_location_First;
    }else if (indexPath.row == [locations count]-1){
        lo = Location_location_Last;
    }
    weak_self(ws);
    [cell setData:location andLocation_location:lo andButtonClick:^(id x) {
        
        
//        CheckLocationViewController *loca = [[CheckLocationViewController alloc] initWithCheck:checkWork andLocation:location andFather:ws];
//        PUSHNAVICONTROLLER(loca);
//        return;
        
        if (@available(iOS 11.0,*)) {

           if (NFCNDEFReaderSession.readingAvailable == YES) {
               if ([NFCNDEFReaderSession readingAvailable]) {
                   selectLocation = location;
                   NFCNDEFReaderSession *session =
                      [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                               queue:nil
                                            invalidateAfterFirstRead:YES];
                      // 开始扫描
                    [session beginSession];
               }
           }else {
               [SVProgressHUD showErrorWithStatus:@"该机型不支持NFC功能!"];
           }
        }else {

            [SVProgressHUD showErrorWithStatus:@"当前系统不支持NFC功能!"];
            NSLog(@"this device not support iOS 11.0");
        }
        
        
        
//        CheckLocationViewController *loca = [[CheckLocationViewController alloc] initWithCheck:checkWork andLocation:selectLocation];
//        PUSHNAVICONTROLLER(loca);
        
        
//        ZBarReaderViewController *zbarR = [[ZBarReaderViewController alloc] init];
//        zbarR.modalPresentationStyle = UIModalPresentationFullScreen;
//        zbarR.showsZBarControls = YES;
//        zbarR.readerDelegate = ws;
//        [ws.navigationController presentViewController:zbarR animated:YES completion:^{
//        }];

        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- NFC

// 扫描到的回调
-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    
    /*
     数组messages中是NFCNDEFMessage对象
     NFCNDEFMessage对象中有一个records数组，这个数组中是NFCNDEFPayload对象
     参考NFCNDEFMessage、NFCNDEFPayload类
     */
    weak_self(ws);
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *record in message.records) {
            NSString *dataStr = [[NSString alloc] initWithData:record.payload
                                                      encoding:NSUTF8StringEncoding];
            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"zh" withString:@""];
            dataStr =[dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"\x02" withString:@""];
            NSLog(@"扫描结果 ：%@", dataStr);
            
            if (selectLocation) {
                if ([dataStr isEqualToString:TOSTRING(selectLocation[@"nfcQRCode"])] ) {
                    [ws upLbs];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //2.0秒后追加任务代码到主队列，并开始执行
                        //打印当前线程
                        CheckLocationViewController *loca = [[CheckLocationViewController alloc] initWithCheck:checkWork andLocation:selectLocation andFather:ws];
                        PUSHNAVICONTROLLER(loca);
                    });
                }else{
                    //                [session invalidateSessionWithErrorMessage:@"请扫描巡检点对应NFC标签"];
                    [SVProgressHUD showErrorWithStatus:String(@"请扫描巡检点对应NFC标签")];
                }
            }else{
                NSLog(@"这里寻找列表里面的巡检点");
                NSArray *locations =  checkWork[@"missionJson"][@"locationList"];
                
                for (NSDictionary * loca in locations) {
                    if ([dataStr isEqualToString:TOSTRING(loca[@"nfcQRCode"])] ) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //2.0秒后追加任务代码到主队列，并开始执行
                            //打印当前线程
                            
                            CheckLocationViewController *loV = [[CheckLocationViewController alloc] initWithCheck:checkWork andLocation:loca andFather:ws];
                            PUSHNAVICONTROLLER(loV);
                        });
                        [session invalidateSession];
                        return;

                    }
                }
                
                [SVProgressHUD showErrorWithStatus:String(@"该巡检点不在本次巡检任务内！")];
            }
        }
    }
    // 主动终止会话，调用如下方法即可。
    [session invalidateSession];
}

// 错误回调
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
    // 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
    NSLog(@"错误回调 : %@", error);
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
    if (selectLocation == nil) {
        UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        
        image = [image imageWithStringRightBottom:[NSString stringWithFormat:@"%@ %@\n%@",[BAPIHelper getUserInfo][@"username"],[[NSDate date] portableString],locationString]];
        
        weak_self(ws);
        requestHelper.needShowHud =@1;
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
           [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
        [requestHelper startUploadImage:image withP:parmDic uri:API_CHECK_MISSION_FILE_UPLOAD result:^(BResponseModel * _Nonnull resp) {
            if (resp.success) {
                [picker dismissViewControllerAnimated:YES completion:^{
                    [ws.footV setImage:image orUrl:nil];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:resp.errorMessage?resp.errorMessage:resp.message];
            }
        }];
    }else{
        id<NSFastEnumeration> results =[info objectForKey:ZBarReaderControllerResults];
        ZBarSymbol *symbol =nil;
        for(symbol in results)
            break;
        NSLog(@"%@",symbol.data);//打印识别的数据
        weak_self(ws)
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([symbol.data isEqualToString:selectLocation[@"location_str"]] ) {
                CheckLocationViewController *loca = [[CheckLocationViewController alloc] initWithCheck:checkWork andLocation:selectLocation andFather:ws];
                PUSHNAVICONTROLLER(loca);
            }else{
                [SVProgressHUD showErrorWithStatus:String(@"请扫描巡检点对应的二维码")];
            }
        }];
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
withRetry: (BOOL) retry
{
    
}


@end
