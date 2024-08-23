//
//  MKSegmentControl.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKSegmentControl;
#pragma mark - MKSegmentControlDelegate
@protocol MKSegmentControlDelegate <NSObject>

/** 选中某个按钮时的代理回调 */
- (void)segmentControl:(MKSegmentControl *)segment didSelectedIndex:(NSInteger)index;

@end


@interface MKSegmentControl : UIView
{
    
}


/**
 *  按钮标题数组
 */
@property (nonatomic, copy) NSArray *titles;
/** 按钮圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 未选中时的按钮文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, strong) UIColor *tinitColor;

@property (nonatomic, weak) id<MKSegmentControlDelegate> delegate;

- (instancetype)initWithSegment:(NSArray*)contentArray frame:(CGRect)frame;

- (void)setSegFrame:(CGRect)frame;


/** 设置segment的索引为index的按钮处于选中状态 */
- (void)setSelectedIndex:(NSInteger)index;

/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan;

/** 选开始的设置 */
- (void)selectedEnd;



@end

NS_ASSUME_NONNULL_END
