//
//  DeviceTypeBtn.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/12/3.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^DeviceTypeBtnBlock)();


@interface DeviceTypeBtn : UIView
{
    UIImageView * imgV;
    UILabel *titleLabel;
    UIButton * btn;
    DeviceTypeBtnBlock myBlock;
}
- (void)setData:(NSDictionary *)data withEvent:(DeviceTypeBtnBlock)block;

@end

NS_ASSUME_NONNULL_END
