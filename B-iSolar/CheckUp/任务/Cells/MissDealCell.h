//
//  MissDealCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissDealCell : UITableViewCell<UITextFieldDelegate>
{
    
    NormalBlock myBlock;
    NormalBlock myBlock2;
    IBOutlet UILabel *perLabbel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextField *contentTextF;
    IBOutlet NSLayoutConstraint *rightCon;
    
    UIDatePicker *datePicker ;
    BOOL canEd;
}
- (void)setContentX:(NSString *)x;
- (void)setMutiLine:(BOOL)muti;
- (void)setDataAndName:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2;
@end

NS_ASSUME_NONNULL_END
