//
//  CheckUpViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/16.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface InCheckViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CustomPickerDelegate>
{
    
    IBOutlet UIView *sepView;

    
    
    NSInteger currentSelect;
    
    CustomPicker *pickerV;

    
    IBOutlet UITableView *mainTableV;
    
}

@property (strong, nonatomic) NSString *selectTime;
@property(nonatomic,strong) CustomPicker *pickerV;

@property(nonatomic,strong)UIView *sepView;
@property (strong, nonatomic) UITableView *mainTableV;

- (id)initWithAction:(int)action;

- (IBAction)sepBtnClick:(UIButton *)sender;

- (id)initWithAction:(int)action andParms:(NSDictionary *)pa;


@end

NS_ASSUME_NONNULL_END
