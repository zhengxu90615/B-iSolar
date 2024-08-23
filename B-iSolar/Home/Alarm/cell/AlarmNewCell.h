//
//  CheckTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmNewCell : UITableViewCell
{
    IBOutlet UIView *view0;
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UILabel *label5;
        
    IBOutlet UILabel *prossTitleLabel;
    IBOutlet UIProgressView *prossV;
    
    NormalBlock myBlock;

}
- (IBAction)btnClick:(id)sender;

- (void)setData:(NSDictionary *)data andButtonClick:(nonnull NormalBlock)blcok;
@end

NS_ASSUME_NONNULL_END
