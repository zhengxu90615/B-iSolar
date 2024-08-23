//
//  AlarmsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlarmNewViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    
    
    IBOutlet UIView *sepView;
    IBOutlet UIButton *alarmBtn;
    IBOutlet UIButton *guzhangBtn;
    
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) CustomPicker *pickerV;
- (IBAction)btnClick:(id)sender;

- (id)initWithStation:(NSDictionary *)station andOrinization:(NSDictionary*)org   ;
@end

NS_ASSUME_NONNULL_END
