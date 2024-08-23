//
//  CheckDetailTableHeader.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckDetailTableHeader : UIView
{
    NormalBlock myBlock;
    UIButton * button;
    UILabel *la ;
}

- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block;
- (void)setTitle:(NSString *)title withBgColor:(UIColor *)bColor withTitleColor:(UIColor *)tColor;
- (void)setTitle:(NSString *)title andBtnTitle:(NSString *)btnTitle withBgColor:(UIColor *)bColor withTitleColor:(UIColor *)tColor;
@end

NS_ASSUME_NONNULL_END
