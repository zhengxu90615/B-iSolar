//
//  MonitorDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/15.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonitorDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *sepView;
    IBOutlet UIButton *monthBtn;
    IBOutlet UIButton *yearBtn;
    
    NSInteger currentSelect;
    IBOutlet UITableView *mainTableV;
}
@property(nonatomic,strong)UIView *sepView;
@property (strong, nonatomic) NSString *selectTime;
@property (strong, nonatomic) UITableView *mainTableV;

- (IBAction)sepBtnClick:(UIButton *)sender;
- (id)initWithMonitor:(NSDictionary *)monitor;

@end

NS_ASSUME_NONNULL_END
