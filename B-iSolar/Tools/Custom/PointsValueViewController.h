//
//  PointsValueViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/18.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomPicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface PointsValueViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    CustomPicker *pickerV;
    NSString *selectTime;

}
@property (strong, nonatomic) CustomPicker *pickerV;
@property (strong, nonatomic) NSString *selectTime;

@property (strong, nonatomic) IBOutlet UITableView *mainTableV;

- (id)initWithStationID:(NSString *)str1 andPointID:(NSString*)str2;
@end

NS_ASSUME_NONNULL_END
