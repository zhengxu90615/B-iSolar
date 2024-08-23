//
//  CheckTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckTableViewCell : UITableViewCell
{
    IBOutlet UIView *view0;
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    NormalBlock myBlock;

}
- (IBAction)btnClick:(id)sender;

- (void)setData:(NSDictionary *)data andButtonClick:(nonnull NormalBlock)blcok;
@end

NS_ASSUME_NONNULL_END
