//
//  MonitorViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/8.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomPicker.h"
#import "ZYSpreadButton.h"

NS_ASSUME_NONNULL_BEGIN
@interface MonitorViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    NSMutableArray *hideSectionArr;
    ZYSpreadButton *zButton;
    CustomPicker *pickerV;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) NSMutableArray *hideSectionArr;
@property (strong, nonatomic) CustomPicker *pickerV;
@end

NS_ASSUME_NONNULL_END
