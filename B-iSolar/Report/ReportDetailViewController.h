//
//  ReportDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/25.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"
#import "ZYSpreadButton.h"

NS_ASSUME_NONNULL_BEGIN
@interface ReportDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    BResponseModel *dataModel;
    CustomPicker *pickerV;
    NSString *selectTime;
    int showTag;
    ZYSpreadButton *zButton;

}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) BResponseModel *dataModel;
@property (strong, nonatomic) CustomPicker *pickerV;
@property (strong, nonatomic) NSString *selectTime;


- (id)initWithStation:(NSDictionary*)stationDic andDate:(NSString *)dateString;
@end

NS_ASSUME_NONNULL_END
