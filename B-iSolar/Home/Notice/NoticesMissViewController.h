//
//  NoticesViewController.h
//  B-iSolar
//  通知公告
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticesMissViewController : BaseTableViewController
{

    IBOutlet UIView *sepView;
    
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    
}
- (IBAction)sepClick:(UIButton *)sender;

- (instancetype)initWithType:(int)typ;
@end

NS_ASSUME_NONNULL_END
