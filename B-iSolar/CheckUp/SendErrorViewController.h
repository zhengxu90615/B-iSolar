//
//  SendErrorViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendErrorViewController : BaseTableViewController<CustomPickerDelegate>
{
    CustomPicker *pickerV;

}
@property (nonatomic,strong) CLLocationManager *locationManager;

@property(nonatomic,strong) CustomPicker *pickerV;

- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary *)lo andPoint:(NSDictionary*)po andError:(NSDictionary*)err;

@end

NS_ASSUME_NONNULL_END
