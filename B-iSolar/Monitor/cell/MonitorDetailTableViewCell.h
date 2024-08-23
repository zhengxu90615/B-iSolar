//
//  MonitorDetailTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/15.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MonitorClick)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MonitorDetailTableViewCell : UITableViewCell
{
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UILabel *label5;

    
    IBOutlet UILabel *desc0;
    IBOutlet UILabel *desc1;
    IBOutlet UILabel *desc2;
    IBOutlet UILabel *desc3;
    IBOutlet UILabel *desc4;
    IBOutlet UILabel *desc5;

    IBOutlet UIView *line0;
    IBOutlet UIView *line1;
    IBOutlet UIView *line2;
    
    IBOutlet UIButton *btn0;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    IBOutlet UIButton *btn4;
    IBOutlet UIButton *btn5;

    
    
}
@property (copy, nonatomic) MonitorClick clickBlock;

- (void)setData:(NSDictionary *)data;
- (IBAction)btn0Click:(id)sender;

@end

NS_ASSUME_NONNULL_END
