//
//  ProDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/26.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProDetailChartsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    IBOutlet UIView *sepView;
    IBOutlet UIButton *monthBtn;
    IBOutlet UIButton *yearBtn;
    
    BResponseModel *dataModel;
    CustomPicker *pickerV;
    NSString *selectTime;
    NSInteger currentSelect;
    IBOutlet UITableView *mainTableV;
    BHttpRequest * apiBlock ;
}
@property(nonatomic,strong)UIView *sepView;
@property (strong, nonatomic) BResponseModel *dataModel;
@property (strong, nonatomic) CustomPicker *pickerV;
@property (strong, nonatomic) NSString *selectTime;
@property (strong, nonatomic) UITableView *mainTableV;

- (IBAction)sepBtnClick:(UIButton *)sender;
- (id)initWithDate:(NSString *)selectDateString andDataDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
