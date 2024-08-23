//
//  AlarmNewCellTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/4.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LeftButtonClick)(NSDictionary *data);

@interface AlarmNewCellTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    
    IBOutlet UILabel *descLabel0;

    

    NSDictionary *myDic;
}
@property (copy, nonatomic) LeftButtonClick leftClickBlock;

- (IBAction)delClick:(id)sender;
- (void)setData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
