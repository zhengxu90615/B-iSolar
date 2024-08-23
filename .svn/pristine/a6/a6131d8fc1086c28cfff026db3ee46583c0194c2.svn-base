//
//  UserViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    IBOutlet UITableView *mainTableV;
    IBOutlet UIView *footV;
    CustomPicker *pickerV;

}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;
@property (strong, nonatomic) CustomPicker *pickerV;



- (IBAction)logoutClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
