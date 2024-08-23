//
//  AlarmsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/11.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlarmsDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableV;
    
    
    UIView *buttonView;
    
    UIButton*button1;
    UIButton*button2;
    IBOutlet NSLayoutConstraint *tableVBomCon;
    
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
- (id)initWithStationId:(NSDictionary *)stationDic;

@end

NS_ASSUME_NONNULL_END
