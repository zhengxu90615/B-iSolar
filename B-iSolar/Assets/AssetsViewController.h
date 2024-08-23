//
//  AssetsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/2.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *stationTableV;

    IBOutlet UIScrollView *deviceScrollV;
    
    NSMutableArray *deviceArr;
    NSString *currentStationId;
}
@property (strong, nonatomic) IBOutlet UITableView *stationTableV;
@property (strong, nonatomic) UIScrollView *deviceScrollV;
@property (strong, nonatomic) NSMutableArray *hideSectionArr,*deviceArr;
@property (strong, nonatomic) NSString *currentStationId;


@end

NS_ASSUME_NONNULL_END
