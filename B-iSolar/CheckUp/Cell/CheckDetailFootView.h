//
//  CheckDetailFootView.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckDetailFootView : UIView
{
    NormalBlock myBlock;
    UILabel * desLabel;
    UIImageView *bgImageV;
    UIButton *button;
}

- (instancetype)initWithTitle:(NSString *)title andButtonClick:(NormalBlock)block;
- (void)setData:(NSDictionary*)data;
- (void)setImage:(nullable UIImage*)img orUrl:(nullable NSString *)imgUrl;
@end

NS_ASSUME_NONNULL_END
