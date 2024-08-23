//
//  SelectStationHeaderView.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/17.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface Select3StationHeaderView : UIView
{
    NormalBlock myBlock;
    UIButton * button0,*button1,*button2;
}
- (void)setTitle0:(NSString *)title0 title1:(NSString *)title1 title2:(NSString *)title2 ;
- (instancetype)initWithTitle:(NSArray *)threeTitles       andButtonClick:(NormalBlock)block;
- (void)hideBtn;
@end

NS_ASSUME_NONNULL_END
