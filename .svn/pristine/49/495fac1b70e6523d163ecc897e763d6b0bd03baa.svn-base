//
//  MKSliderSegmentView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MKSliderSegmentView.h"


#define DefaultCurrentBtnColor UIColorFromHex(0x909399)
#define DefaultCurrentBtnClickColor UIColorFromHex(0x303133)
#define DefaultTinitColor UIColorFromHex(0x019AD8)

@interface MKSliderSegmentView ()
{
    NSUInteger _btnCount; // 按钮总数
    UIView *sliderView;
    CGFloat _btnWidth; // 按钮宽度
    
    UIButton *_currentBtn;   // 指示视图当前所在的按钮
        
    BOOL _isSelectedBegan; // 是否设置了selectedBegan
}

@property (nonatomic, strong) NSMutableArray *buttons; // 存放button

@end



@implementation MKSliderSegmentView



- (instancetype)initWithSegment:(NSArray*)contentArray frame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
    
        [self setTitles:contentArray];
    }
    return self;
}
- (void)setSegFrame:(CGRect)frame{
    self.frame = frame;
}
/**
 *  设置按钮标题数组
 */
- (void)setSegTitles:(NSArray *)titles
{
    _titles = [titles copy];
    
    _btnCount = [_titles count];
    
    [self createUI];
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


#pragma mark 创建视图
- (void)createUI
{
//    self.layer.cornerRadius  = LAYER_CORNERRADIUS;
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = UIColorFromHex(0xE4E5E8).CGColor;
//    self.layer.borderWidth = .5f;
    self.backgroundColor = [UIColor clearColor];
    
    
    
    _btnWidth = self.frame.size.width;
    
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
        
        [btn setBackgroundColor:[UIColor clearColor]];
        
        [self.buttons addObject:btn]; // 加入数组
    }
    sliderView = [[UIView alloc] init];
    sliderView.frame = CGRectMake(0 , 41 ,49,3);
    UIColor *color = self.sliderColder ? self.sliderColder : DefaultTinitColor;
    sliderView.layer.backgroundColor = [UIColor colorWithRed:1/255.0 green:154/255.0 blue:216/255.0 alpha:1.0].CGColor;
    sliderView.layer.cornerRadius = 1.5;
    [self addSubview:sliderView];

    // 第一个设置字体颜色
    _currentBtn = (UIButton *)self.buttons[0];
    // 如果没有设置background，就为默认颜色
    color = self.titleSelectColor ? self.titleSelectColor : DefaultCurrentBtnClickColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
    
    sliderView.center = CGPointMake(_currentBtn.center.x, btnHeight - 1.5);
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
   
}

/** 选开始的设置 */
- (void)selectedEnd
{
    if (!_isSelectedBegan) return;
    
    _isSelectedBegan = NO;
        
    // 如果没有设置background，就为默认颜色
    weak_self(ws);
    UIColor *color = self.titleSelectColor ? self.titleSelectColor : DefaultCurrentBtnClickColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
    [UIView animateWithDuration:.3f animations:^{
        sliderView.center = CGPointMake(_currentBtn.center.x, CGRectGetHeight(ws.frame) - 1.5);
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
