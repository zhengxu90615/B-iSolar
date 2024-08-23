//
//  ErrorInputTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorInputTableViewCell : UITableViewCell<UITextViewDelegate>
{
    IBOutlet UILabel *nameLabel;
    
    IBOutlet UITextView *inputText;
    NormalBlock myBlock;
    NormalBlock myBlock2;
    NSMutableDictionary *dataDic;
}
- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block;
- (void)setData:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)bloc;
- (void)setDataAndName:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2;

@end

NS_ASSUME_NONNULL_END
