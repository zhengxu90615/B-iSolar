//
//  CustomDatePicker.h
//  ceshi
//
//  Created by jt on 16/1/27.
//  Copyright © 2016年 SJWL. All rights reserved.
//
typedef enum {
    PickerTypeOne = 1,
    PickerTypeTwo,
    PickerTypeYYYYMMDD,
    PickerTypeYYYYMM,
    PickerTypeYYYY
} PickerType;

#import <UIKit/UIKit.h>
@class CustomPicker;
@protocol CustomPickerDelegate <NSObject>

@required
- (void)pickerView :(CustomPicker*)v selected:(NSArray *)array andIndexPath:(NSIndexPath*)indexpath;

@optional
//视图已经隐藏
- (void)alreadyHiddtnDatePicker;

@end

@interface CustomPicker : UIView

//设置时间选择器当前时间
@property (nonatomic, strong)NSDate *customDate;
//设置时间选择器最大时间
@property (nonatomic, strong)NSDate *customMaxDate;
//设置时间选择器最小时间
@property (nonatomic, strong)NSDate *customMinDate;

//显示、显示
@property (nonatomic, assign)BOOL hiddenCustomPicker;


@property (nonatomic, strong)id<CustomPickerDelegate> delegate;

- (void)setType:(PickerType)type  andTag:(NSInteger)tag andDatas:(nullable NSArray *)datas;

- (void)setCurrentY:(NSInteger)year M:(NSInteger)month D:(NSInteger)day;
@end
