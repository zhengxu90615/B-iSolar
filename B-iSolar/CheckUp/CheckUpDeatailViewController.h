//
//  CheckUpDeatailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckUpDeatailViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    UITableView *mainTableV;
    IBOutlet UITextField *nameLabel;
    IBOutlet UITextField *peopleLabel;
 
    
    IBOutlet UIView *footView;
    IBOutlet UIButton *submitBtn;
    CustomPicker *pickerV;
}
@property (strong, nonatomic) CustomPicker *pickerV;

@property (strong, nonatomic) UITableView *mainTableV;
@property (nonatomic,strong) CLLocationManager *locationManager;

- (IBAction)submitClick:(id)sender;

- (id)initWithData:(NSString *)dic andEdit:(BOOL)canEdit;
- (void)resetDataWithSection:(int)section row:(int)row andCell:(UITableViewCell*)cell andEx:(id)exValue andtype:(int)type;  //0:seg 1:img 2:input

@end

NS_ASSUME_NONNULL_END
