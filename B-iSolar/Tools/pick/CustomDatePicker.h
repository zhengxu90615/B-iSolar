//
//  CustomDatePicker.h
//  ceshi
//
//  Created by jt on 16/1/27.
//  Copyright © 2016年 SJWL. All rights reserved.
//
#import "CustomPicker.h"
#import <UIKit/UIKit.h>
@class CustomDatePicker;
@protocol CustomDatePickerDelegate <NSObject>

@required
- (void)pickerViewSureClick :(CustomDatePicker*)v ;

@optional
//视图已经隐藏
- (void)alreadyHiddtnDatePicker;

@end

@interface CustomDatePicker : UIView

//设置时间选择器当前时间
@property (nonatomic, strong)NSDate *customDate;

//显示、显示
@property (nonatomic, assign)BOOL hiddenCustomPicker;


@property (nonatomic, strong)id<CustomDatePickerDelegate> delegate;

- (void)setType:(PickerType)type  andTag:(NSInteger)tag andDatas:(nullable NSArray *)datas;

- (void)setCurrentY:(NSInteger)year M:(NSInteger)month D:(NSInteger)day;

- (void)setMinDate:(NSDate*)date;
- (void)setMaxDate:(NSDate*)date;
@end
