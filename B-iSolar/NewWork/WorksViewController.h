//
//  HomeViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorksViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableV;
    BResponseModel *dataModel;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) BResponseModel *dataModel;

- (void)reloadV;
@end

NS_ASSUME_NONNULL_END
