//
//  DevPointsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/21.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevPointsViewController : BaseViewController
{
    
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIView *bgLineV;
    IBOutlet UIView *sliderV;
    
    
    IBOutlet UITableView *mainTableV;
    
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableV;


- (id)initWithDevID:(NSString *)devID;
- (IBAction)sepBtnClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
