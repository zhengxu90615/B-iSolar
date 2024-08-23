//
//  NewLocationViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/14.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@class CustomPicker;
NS_ASSUME_NONNULL_BEGIN

@interface NewLocationViewController : BaseViewController
{
    CustomPicker *pickerV;
}

@property(nonatomic,strong) CustomPicker *pickerV;
@property (nonatomic,strong) CLLocationManager *locationManager;



- (id)initWithStation:(NSDictionary *)staDic;
@end

NS_ASSUME_NONNULL_END
