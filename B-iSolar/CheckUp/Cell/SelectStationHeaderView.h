//
//  SelectStationHeaderView.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/17.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface SelectStationHeaderView : UIView
{
    NormalBlock myBlock;
    UIButton * button;
    UILabel *la ;
}
- (void)setNameLabel:(NSString *)nameLabel;
- (void)setTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block;
- (void)hideBtn;
@end

NS_ASSUME_NONNULL_END
