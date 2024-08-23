//
//  MissionHeaderView.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/22.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionHeaderView : UIView<UITextFieldDelegate>
{
    NormalBlock2 myBlock;
    
    UIView *bgV0,*bgV1;
    UIButton *statusBtn,*selectUserBtn;
    UIButton *onMeBtn;
    UITextField *nameTextF;
    
    UIImageView*onMeImgV;
    UILabel *la;
    UIImageView *imV;
}
- (instancetype)initWithBlock:(NormalBlock2)block;
- (void)setData:(NSDictionary *)data;

- (void)resetData:(NSString*)status name:(NSString*)name ids:(NSString*)ids onMe:(NSString*)onme;
- (void)resignFirstResp;
@end

NS_ASSUME_NONNULL_END
