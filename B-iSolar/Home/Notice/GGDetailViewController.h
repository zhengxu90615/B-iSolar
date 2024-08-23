//
//  GGDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GGDetailViewController : BaseViewController
{
    NSInteger type;
    IBOutlet NSLayoutConstraint *bottomCon;
    IBOutlet NSLayoutConstraint *filesTableHeght;
    IBOutlet UITableView *filesTableV;
    IBOutlet UIView *filesView;
    
    UITableView *mainTableV;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;


- (id)initWithNotice:(NSDictionary *)notice andType:(NSInteger)ty;

@end
NS_ASSUME_NONNULL_END
