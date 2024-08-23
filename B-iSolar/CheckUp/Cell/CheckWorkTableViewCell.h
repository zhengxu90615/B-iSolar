//
//  CheckWorkTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/23.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckWorkTableViewCell : UITableViewCell
{
    IBOutlet UIButton *button;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    
    
    IBOutlet UILabel *stationLabel;
    NormalBlock myBlock;
    NormalBlock myBlock1;
    NormalBlock myBlock2;
    IBOutlet UILabel *dateLabel;
}

- (void)setData:(NSDictionary *)data andButtonClick:(NormalBlock)blcok andButton1Click:(NormalBlock)blcok1 andButton2Click:(NormalBlock)blcok2;
- (IBAction)buttonClick:(id)sender;


@end

NS_ASSUME_NONNULL_END
