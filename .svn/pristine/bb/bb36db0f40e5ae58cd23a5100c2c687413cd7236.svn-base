//
//  MKSegmentControl.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MKSegmentControl.h"

#pragma mark - JRSegmentControl
#define DefaultCurrentBtnColor [UIColor whiteColor]


@interface MKSegmentControl ()
{
    NSUInteger _btnCount; // 按钮总数
    
    CGFloat _btnWidth; // 按钮宽度
    
    UIButton *_currentBtn;   // 指示视图当前所在的按钮
        
    BOOL _isSelectedBegan; // 是否设置了selectedBegan
}

@property (nonatomic, strong) NSMutableArray *buttons; // 存放button

@end


@implementation MKSegmentControl

- (instancetype)initWithSegment:(NSArray*)contentArray frame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self setTitles:contentArray];
    }
    return self;
}
- (void)setSegFrame:(CGRect)frame{
    
}
/**
 *  设置按钮标题数组
 */
- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];
    
    _btnCount = [_titles count];
    
    [self createUI];
}

/**
 *  设置圆角半径
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = _cornerRadius;
}

/**
 *  设置保存按钮的数组
 */
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

/**
 *  设置按钮上文字颜色
 */
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    for (int i = 0; i < _btnCount; i++) {
        UIButton *btn = self.buttons[i];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateHighlighted];
    }
    
    // 如果不设置backgroundColor，第一个按钮的文字颜色就会被设置为默认颜色
    [_currentBtn setTitleColor:DefaultCurrentBtnColor forState:UIControlStateNormal];
}

/**
 *  设置背景色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [_currentBtn setTitleColor:backgroundColor forState:UIControlStateNormal];
}


#pragma mark 创建视图
- (void)createUI
{
    self.layer.cornerRadius  = LAYER_CORNERRADIUS;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = UIColorFromHex(0xE4E5E8).CGColor;
    self.layer.borderWidth = .5f;
    
    _btnWidth = self.frame.size.width / _btnCount;
    CGFloat btnHeight = self.frame.size.height;
    
    // 创建各个按钮
    for (int i = 0; i < _btnCount; i++)
    {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(_btnWidth * i, 0, _btnWidth, btnHeight);
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *color = self.titleColor ? self.titleColor : DefaultCurrentBtnColor;
        [btn setTitleColor:color forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [self.buttons addObject:btn]; // 加入数组
    }
    
    // 第一个设置字体颜色
    _currentBtn = (UIButton *)self.buttons[0];
    // 如果没有设置background，就为默认颜色
    UIColor *color = self.titleSelectColor ? self.titleSelectColor : DefaultCurrentBtnColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
    
    color = self.tinitColor ? self.tinitColor : DefaultCurrentBtnColor;
    [_currentBtn setBackgroundColor:color];
}

#pragma mark 按钮点击事件处理
- (void)btnClicked:(UIButton *)btn
{
    NSInteger index = 0;
    for (UIButton *button in self.buttons) {
        if (button.frame.origin.x == btn.frame.origin.x) {
            break;
        }
        index++;
    }
    
    [self setSelectedIndex:index]; //////////////////////////////////////
}

#pragma mark 设置选中按钮
- (void)setSelectedIndex:(NSInteger)index
{
    // 告诉代理选中了哪个按钮
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectedIndex:)]) {
        [self.delegate segmentControl:self didSelectedIndex:index];
    }
    
    [self selectedBegan]; // 选中开始的设置 //////////////////////////////////////
    
    _currentBtn = self.buttons[index];
    
    [self selectedEnd]; // 选中结束的设置 //////////////////////////////////////
}

/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan
{
    if (_isSelectedBegan) return;
    
    _isSelectedBegan = YES;
    UIColor *color = self.titleColor ? self.titleColor : DefaultCurrentBtnColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
    [_currentBtn setBackgroundColor:[UIColor whiteColor]];

}

/** 选开始的设置 */
- (void)selectedEnd
{
    if (!_isSelectedBegan) return;
    
    _isSelectedBegan = NO;
        
    // 如果没有设置background，就为默认颜色
    UIColor *color = self.titleSelectColor ? self.titleSelectColor : DefaultCurrentBtnColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
    
    color = self.tinitColor ? self.tinitColor : DefaultCurrentBtnColor;
    [_currentBtn setBackgroundColor:color];

}

@end
