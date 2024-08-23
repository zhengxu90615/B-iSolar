//
//  CheckUpDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <CoreNFC/CoreNFC.h>
#import "BMKCustomAnnotationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckUpDetailViewController : BaseTableViewController<CLLocationManagerDelegate>
{
    
    
}
//@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
- (id)initWithCheck:(NSDictionary *)check;
- (void)nfcCheckEnd:(NSDictionary*)location;
@end

NS_ASSUME_NONNULL_END
