//
//  CustomDatePicker.m
//  ceshi
//
//  Created by jt on 16/1/27.
//  Copyright © 2016年 SJWL. All rights reserved.
//
#import "NSDate+Formatting.h"
#define YEAR_LAST 5
#import "CustomPicker.h"
#define JTSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define JTSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define CUSTOMDATEPICKER_HEIGHT 200

#define BUTTON_HEIGHT 30

@interface CustomPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
{

    //确定
    UIButton *_sureButton;
    //取消
    UIButton *_cancelButton;
    //时间选择器
    UIPickerView *_datePicker;
    
    
    NSMutableArray *dataArray;
    UIView *cover;
    PickerType pickType;
}
//选择的时间
@property (nonatomic, copy)NSString *selectDateStr;
//传入的时间格式
@property (nonatomic, copy)NSString *dateType;
@property(nonatomic,assign) NSInteger proIndex;

@end

@implementation CustomPicker

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
    
    
    _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT, JTSCREEN_WIDTH, CUSTOMDATEPICKER_HEIGHT-BUTTON_HEIGHT)];
    _datePicker.dataSource = self;
    _datePicker.delegate = self;
    
    [self addSubview:_datePicker];
    
}

- (void)setType:(PickerType)type  andTag:(NSInteger)tag andDatas:(nullable NSArray *)datas;
{
    pickType = type;
    self.tag = tag;
    [dataArray removeAllObjects];
    if (datas) {
        [dataArray addObjectsFromArray:datas];
        _proIndex = 0;
    }
    _proIndex = [_datePicker selectedRowInComponent:0];
    [_datePicker reloadAllComponents];
    
}
- (void)setCurrentY:(NSInteger)year M:(NSInteger)month D:(NSInteger)day{
    
    if (pickType == PickerTypeYYYYMMDD) {
        NSInteger yearIndex = year - [NSDate year] +YEAR_LAST-1;
        
        [_datePicker selectRow:yearIndex inComponent:0 animated:NO];
        [_datePicker selectRow:month-1 inComponent:1 animated:NO];
        [_datePicker selectRow:day-1 inComponent:2 animated:NO];

    }else if (pickType == PickerTypeYYYYMM){
        NSInteger yearIndex = year - [NSDate year] +YEAR_LAST-1;

        [_datePicker selectRow:yearIndex inComponent:0 animated:NO];
        [_datePicker selectRow:month-1 inComponent:1 animated:NO];
        
    }else if (pickType == PickerTypeYYYY){
        NSInteger yearIndex = year - [NSDate year] +YEAR_LAST-1;

        [_datePicker selectRow:yearIndex inComponent:0 animated:NO];

        
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (pickType) {
        case PickerTypeOne:
            return 1;
            break;
        case PickerTypeTwo:
            return 2;
            break;
        case PickerTypeYYYY:
            return 1;
            break;
        case PickerTypeYYYYMM:
            return 2;
            break;
        case PickerTypeYYYYMMDD:
            return 3;
            break;
        default:
            break;
    }
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickType) {
        case PickerTypeOne:
            return dataArray.count;
            break;
        case PickerTypeTwo:
        {
            if (component == 0) {
                return dataArray.count;
            }
            return [dataArray[_proIndex][@"list"] count];
        }
            break;
        case PickerTypeYYYY:
            return YEAR_LAST;
            break;
        case PickerTypeYYYYMM:
        {
            if (component == 0) {
                return YEAR_LAST;
            }else{
                return 12;
            }
        }
            return 2;
            break;
        case PickerTypeYYYYMMDD:
            {
                switch (component) {
                    case 0:
                        return YEAR_LAST;
                        break;
                    case 1:
                        return 12;
                    case 2:
                    {
                        NSInteger yearIndex = [pickerView selectedRowInComponent:0];
                        NSInteger monthIndex = [pickerView selectedRowInComponent:1];
                        
                        return [self getDaysInYear:[NSDate year] +yearIndex -YEAR_LAST+1 month:monthIndex+1];
                    }
                    default:
                        break;
                }
                return 1;
            }
            break;
        default:
            break;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickType) {
        case PickerTypeOne:
            return dataArray[row][@"name"];
            break;
        case PickerTypeTwo:
        {
            if (component == 0) {
                return dataArray[row][@"name"];
            }else{
                return dataArray[_proIndex][@"list"][row][@"name"];
            }
        }
            break;
        case PickerTypeYYYY:
        {
            return [NSString stringWithFormat:@"%d年",[NSDate year] +row -YEAR_LAST+1];
        }
            break;
        case PickerTypeYYYYMM:
        {
            if (component == 0) {
                return [NSString stringWithFormat:@"%d年",[NSDate year] +row -YEAR_LAST+1];
            }else{
                return [NSString stringWithFormat:@"%d月",1+row ];
            }
        }
            break;
        case PickerTypeYYYYMMDD:
        {
            switch (component) {
                case 0:
                {
                    return [NSString stringWithFormat:@"%d年",[NSDate year] +row -YEAR_LAST+1];
                }
                    break;
                case 1:
                {
                    return [NSString stringWithFormat:@"%d月",1+row ];
                }
                    break;
                case 2:
                {
                    return [NSString stringWithFormat:@"%d日",1+row ];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return @"";
}

- (int)getDaysInYear:(int)year month:(int)imonth {
    // imonth == 0的情况是应对在CourseViewController里month-1的情况
    if((imonth == 0)||(imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (pickType) {
        case PickerTypeOne:
        {
        }
            break;
        case PickerTypeTwo:
        {
            _proIndex = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
        }
            break;
        case PickerTypeYYYY:
        {
        }
            break;
        case PickerTypeYYYYMM:
        {
            [pickerView reloadComponent:1];
        }
            break;
        case PickerTypeYYYYMMDD:
        {
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)tapCover{
    self.hiddenCustomPicker = YES;
}

#pragma mark -- 确定、取消按钮点击事件
//确定
- (void)sureButtonAction:(UIButton *)button {

    switch (pickType) {
        case PickerTypeOne:
        {
            NSInteger first = [_datePicker selectedRowInComponent:0];
            [self pickerViewSelected:@[dataArray[first]] andIndexPath:[NSIndexPath indexPathForRow:0 inSection:first]];
        }
            break;
        case PickerTypeTwo:
        {
            NSInteger first = [_datePicker selectedRowInComponent:0];
            NSInteger second = [_datePicker selectedRowInComponent:1];
            [self pickerViewSelected:@[dataArray[first], dataArray[first][@"list"][second]] andIndexPath:[NSIndexPath indexPathForRow:second inSection:first]];
        }
            break;
        case PickerTypeYYYY:
        {
            NSInteger first = [_datePicker selectedRowInComponent:0];
            first = [NSDate year] +first -YEAR_LAST+1;
            [self pickerViewSelected:@[@(first)] andIndexPath:nil];
        }
            break;
        case PickerTypeYYYYMM:
        {
            NSInteger first = [_datePicker selectedRowInComponent:0];
            first = [NSDate year] +first -YEAR_LAST+1;
            NSInteger second = [_datePicker selectedRowInComponent:1]+1;
            [self pickerViewSelected:@[@(first),@(second)] andIndexPath:nil];
        }
            break;
        case PickerTypeYYYYMMDD:
        {
            NSInteger first = [_datePicker selectedRowInComponent:0];
            first = [NSDate year] +first -YEAR_LAST+1;
            NSInteger second = [_datePicker selectedRowInComponent:1]+1;
            NSInteger third = [_datePicker selectedRowInComponent:2]+1;

            [self pickerViewSelected:@[@(first),@(second),@(third)] andIndexPath:nil];
        }
            break;
        default:
            break;
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
- (void)datePickerChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *dateFormatter = [self dateFormatter:self.dateType];
    
    self.selectDateStr = [dateFormatter stringFromDate:datePicker.date];
}


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

#pragma mark -- dateFormatter 
- (NSDateFormatter *)dateFormatter:(NSString *)dateFormatterStr {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (dateFormatterStr.length == 0)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else
    {
        [dateFormatter setDateFormat:self.dateType];
    }

    return dateFormatter;
}

#pragma mark -- CustomDatePicker delegate
- (void)pickerViewSelected:(NSArray *)array andIndexPath:(NSIndexPath*)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selected:andIndexPath:)]) {
        [self.delegate pickerView:self selected:array andIndexPath:indexPath];
    }
}


//视图已经隐藏
- (void)alreadyHiddtnDatePicker {

    if (self.delegate && [self.delegate respondsToSelector:@selector(alreadyHiddtnDatePicker)]) {
        [self.delegate alreadyHiddtnDatePicker];
    }

}



@end

