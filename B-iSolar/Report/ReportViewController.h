//
//  ReportViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/24.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYSpreadButton.h"
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    BResponseModel *dataModel;
    NSMutableArray *hideSectionArr;
    ZYSpreadButton *zButton;
    CustomPicker *pickerV;
    NSString *selectTime;
    int showTag;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) BResponseModel *dataModel;
@property (strong, nonatomic) CustomPicker *pickerV;
@property (strong, nonatomic) NSString *selectTime;
@property (strong, nonatomic) NSMutableArray *hideSectionArr;


- (void)loadDataOfDay:(NSString *)dataString;
@end

NS_ASSUME_NONNULL_END
