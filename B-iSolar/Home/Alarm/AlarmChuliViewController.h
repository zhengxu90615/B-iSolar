//
//  MissionChuliViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CustomPicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface AlarmChuliViewController : BaseTableViewController<CustomPickerDelegate>
{
    UIView *buttonView;
    
    UIButton*button1;
    CustomPicker *dealPickerV;
    

}
- (id)initWithMission:(NSDictionary*)miss;
@property(nonatomic,strong) CustomPicker *dealPickerV;

@end

NS_ASSUME_NONNULL_END
