//
//  MKLineChartView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/30.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MKLineChartView.h"
@interface MKLineChartView ()
{
    NSArray *_dataArr;
    UIColor *_color;
}
@end

@implementation MKLineChartView




- (void)setData:(NSArray *)arr andColor:(UIColor *)color andUnit:(NSString *)unit{
    _dataArr = [arr copy];
    _color = color;
    [self createUI];
}

- (void)createUI{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    CGFloat _w = CGRectGetWidth(self.frame);
    CGFloat _h = CGRectGetHeight(self.frame)/_dataArr.count;
    
    CGFloat startX = 65.5f;
    
    CGFloat max = 0;
    for (NSDictionary *data in _dataArr) {
        if ([data[@"value"] floatValue] > max){
            max = [data[@"value"] floatValue];
        }
    }
    
    UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
    _atest.text = [NSString stringWithFormat:@"%.1f",max];
    _atest.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize baseSize = CGSizeMake(80, _h);
    CGSize labelsize = [_atest sizeThatFits:baseSize];
    
    CGFloat numWidth = labelsize.width > 80 ? 80 :  labelsize.width;
    
    CGFloat maxAreaWidth = _w - startX - 20 - numWidth;
    
    
    for (int i= 0 ; i < _dataArr.count ; i++) {
        NSDictionary *data = _dataArr[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i *_h, 65, _h)];
        label.text = data[@"name"];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromHex(0x606266);
        
        [self addSubview:label];
        
        UIView *view = [[UIView alloc] init];
        
        float v = [data[@"value"] floatValue] / max *  maxAreaWidth + 10;
        if ([data[@"value"] floatValue]  == 0)
        {
            v = 0;
        }
        
        view.frame = CGRectMake(startX,i * _h + (_h - 12)/2, 0,12);
        view.backgroundColor = _color;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
        byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
        cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        [view.layer setMasksToBounds:YES];
        view.layer.mask = maskLayer;
        maskLayer.path = maskPath.CGPath;
        
        [self addSubview:view];
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectMake(startX + CGRectGetWidth(view.frame) + 10, i*_h, 80, _h)];
        _atest.text = [NSString stringWithFormat:@"%.1f",[data[@"value"] floatValue]];
        _atest.font = [UIFont systemFontOfSize:12];
        _atest.textColor = COLOR_TABLE_TITLE;
        [self addSubview:_atest];
        
        
        [UIView animateWithDuration:0.5f animations:^{
            view.frame = CGRectMake(startX,i * _h + (_h - 12)/2, v,12);
            view.backgroundColor = _color;
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
            byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
            cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = view.bounds;
            [view.layer setMasksToBounds:YES];
            view.layer.mask = maskLayer;
            maskLayer.path = maskPath.CGPath;
            
            _atest.frame = CGRectMake(startX + CGRectGetWidth(view.frame) + 10, i*_h, 80, _h);
        }];
        
       
        

        
    }
    
    
    
}


@end
