//
//  MKSliderSegmentView.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MKSliderSegmentView;
@protocol MKSliderSegmentControlDelegate <NSObject>

/** 选中某个按钮时的代理回调 */
- (void)segmentControl:(MKSliderSegmentView *)segment didSelectedIndex:(NSInteger)index;

@end

@interface MKSliderSegmentView : UIView
{
    
}



/**
 *  按钮标题数组
 */
@property (nonatomic, copy) NSArray *titles;
/** 未选中时的按钮文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;

/** 选中时的按钮文字颜色 */
@property (nonatomic, strong) UIColor *titleSelectColor;

@property (nonatomic, strong) UIColor *sliderColder;

@property (nonatomic, weak) id<MKSliderSegmentControlDelegate> delegate;

- (instancetype)initWithSegment:(NSArray*)contentArray frame:(CGRect)frame;

- (void)setSegFrame:(CGRect)frame;

- (void)setSegTitles:(NSArray *)titles;

/** 设置segment的索引为index的按钮处于选中状态 */
- (void)setSelectedIndex:(NSInteger)index;




@end

NS_ASSUME_NONNULL_END
