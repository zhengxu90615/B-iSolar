//
//  ReportSunsortViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/3/10.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportSunsortViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    CustomPicker *pickerV;
    NSString *selectTime;
    int showTag;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) BResponseModel *dataModel;
@property (strong, nonatomic) CustomPicker *pickerV;
@property (strong, nonatomic) NSString *selectTime;

- (id)initWithSelectTime:(NSString *)dataString;
- (void)loadDataOfDay:(NSString *)dataString;
@end

NS_ASSUME_NONNULL_END
