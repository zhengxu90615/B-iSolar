//
//  CheckLocationViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CheckUpDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>
#import <CoreNFC/CoreNFC.h>
#import "BMKCustomAnnotationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckLocationViewController : BaseTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}

- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary*)lo andFather:(CheckUpDetailViewController*)faV;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

NS_ASSUME_NONNULL_END
