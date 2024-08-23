//
//  CustomDatePicker.m
//  ceshi
//
//  Created by jt on 16/1/27.
//  Copyright © 2016年 SJWL. All rights reserved.
//
#import "NSDate+Formatting.h"
#define YEAR_LAST 5
#import "CustomDatePicker.h"
#define JTSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define JTSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define CUSTOMDATEPICKER_HEIGHT 200

#define BUTTON_HEIGHT 30

@interface CustomDatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
{

    //确定
    UIButton *_sureButton;
    //取消
    UIButton *_cancelButton;
    //时间选择器
    UIDatePicker *_datePicker;
    
    
    NSMutableArray *dataArray;
    UIView *cover;
    PickerType pickType;
    
    UIView *v;
    
}
//选择的时间
@property (nonatomic, copy)NSString *selectDateStr;
//传入的时间格式
@property (nonatomic, copy)NSString *dateType;
@property(nonatomic,assign) NSInteger proIndex;

@end

@implementation CustomDatePicker

- (instancetype)init {
    
    if (self = [super init])
    {
        self.frame = CGRectMake(0, JTSCREEN_HEIGHT, JTSCREEN_WIDTH, CUSTOMDATEPICKER_HEIGHT);
        self.hidden = YES;
        
        //创建需要视图
        [self _createView];
        
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }
    return self;
}

- (void)_createView {
    dataArray = [[NSMutableArray alloc]init];

    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0-JTSCREEN_HEIGHT, JTSCREEN_WIDTH, JTSCREEN_HEIGHT*2)];
    cover.userInteractionEnabled = YES;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.15;
    cover.hidden = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
    [cover addGestureRecognizer:tapGestureRecognizer];
    [[UIApplication sharedApplication].delegate.window addSubview:cover];
    
    
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JTSCREEN_WIDTH, CUSTOMDATEPICKER_HEIGHT)];
    v.backgroundColor = [UIColor whiteColor];
    [self addSubview:v];
    
    //确定
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(JTSCREEN_WIDTH-50, 0, 50, BUTTON_HEIGHT);
    _sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [_sureButton setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureButton];
    
    //取消
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 0, 50, BUTTON_HEIGHT);
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:MAIN_TINIT_COLOR forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    //
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(MAINSCREENWIDTH/2 - 160, BUTTON_HEIGHT, 320, CUSTOMDATEPICKER_HEIGHT-BUTTON_HEIGHT)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.4, *)) {

        _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;

    }
    
    [self addSubview:_datePicker];
    
}

- (void)setMinDate:(NSDate*)date{
    _datePicker.minimumDate = date;
}
- (void)setMaxDate:(NSDate*)date{
    _datePicker.maximumDate = date;

}
- (NSDate*)customDate{
    
    return _datePicker.date;
}
- (void)tapCover{
    self.hiddenCustomPicker = YES;
}

#pragma mark -- 确定、取消按钮点击事件
//确定
- (void)sureButtonAction:(UIButton *)button {

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewSureClick:)]) {
        [self.delegate pickerViewSureClick:self];
    }
    /**
     *  确定之后隐藏选择器
     */
    self.hiddenCustomPicker = YES;
}

//取消
- (void)cancelButtonAction:(UIButton *)button {
    self.hiddenCustomPicker = YES;
}

#pragma mark -- 时间选择器

#pragma mark -- 显示、隐藏选择器
- (void)setHiddenCustomPicker:(BOOL)hiddenCustomPicker{
    __weak typeof(self) weakSelf = self;
    if (hiddenCustomPicker)
    {
        cover.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.hidden = YES;
            
            [self alreadyHiddtnDatePicker];
        }];
    }
    else
    {
        self.hidden = NO;
        cover.hidden = NO;

        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.transform = CGAffineTransformMakeTranslation(0, -CUSTOMDATEPICKER_HEIGHT);
        }];
        
        self.selectDateStr = @"";
    }
}

//视图已经隐藏
- (void)alreadyHiddtnDatePicker {

    if (self.delegate && [self.delegate respondsToSelector:@selector(alreadyHiddtnDatePicker)]) {
        [self.delegate alreadyHiddtnDatePicker];
    }

}



@end

