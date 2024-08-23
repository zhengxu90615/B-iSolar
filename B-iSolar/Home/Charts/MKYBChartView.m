//
//  MKYBChartView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "MKYBChartView.h"
@implementation TriangleView
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw a triangle
    CGContextBeginPath(context);
    CGContextMoveToPoint   (context, self.bounds.size.width/2, 0);  // top
    CGContextAddLineToPoint(context, 0, self.bounds.size.height/2);  // right
    CGContextAddLineToPoint(context, self.bounds.size.width,self.bounds.size.height/2);  // left
    CGContextClosePath(context);
        
    CGContextSetRGBFillColor(context, 249/255.0, 126/255.0, 44/255.0, 1);
    CGContextFillPath(context);
    
}


@end



@interface MKYBChartView()
{
    NSString *titleStr;
    NSNumber *rate, * lastRate;
    UILabel *titleLabel, *descLabel;
    UIView * centerV;
    NSMutableArray *sepView;
    
    
    CGPoint centerPoint;
    
    CAShapeLayer *shapeLayer1;
    
    TriangleView *ArrawView;
    
    
}
@property(nonatomic,strong)TriangleView *ArrawView;
@end

@implementation MKYBChartView
@synthesize ArrawView;


- (void)setTitle:(NSString *)title andNum:(NSNumber *)rat
{
    self.backgroundColor = [UIColor whiteColor];

    rate = rat;
    titleStr = title;

    [self loadRate];
}

- (void)loadRate{
    descLabel.text = titleStr;
    titleLabel.text = [NSString stringWithFormat:@"%@%%",rate];
    
 
    shapeLayer1.strokeEnd = [rate integerValue]/100.0f;

    
    CGFloat total = 45 + 180;
           
   total = [rate integerValue]/100.0f * total;
   CGFloat an = ((float) total/180.0f) + (float)-112.5/180.0f  ;
    weak_self(ws)
    if (an >= 0.5) {
        [UIView animateWithDuration:.35f animations:^{
            ws.ArrawView.transform = CGAffineTransformMakeRotation(0.4 * M_PI);
            
                ws.ArrawView.transform = CGAffineTransformMakeRotation(an * M_PI);
        }];
    }else if (an< -0.5){
        [UIView animateWithDuration:.35f animations:^{
                ws.ArrawView.transform = CGAffineTransformMakeRotation(-0.4 * M_PI);
                
                    ws.ArrawView.transform = CGAffineTransformMakeRotation(an * M_PI);
        }];
    }
    else{
        [UIView animateWithDuration:.3f animations:^{
            ws.ArrawView.transform = CGAffineTransformMakeRotation(an * M_PI);
        }];
    }
    

}

- (void)createUI
{
    if (titleLabel) {
        return;
    }
    centerPoint =CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 + 20);

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 44, CGRectGetWidth(self.frame) , 20)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = UIColorFromHex(0x303133);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 22, CGRectGetWidth(self.frame)  , 20)];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = UIColorFromHex(0x606266);
    descLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:descLabel];
    
    ArrawView = [[TriangleView alloc] initWithFrame:CGRectMake(centerPoint.x-4,centerPoint.y - centerPoint.y * 0.4, 8, centerPoint.y * 0.8)];
    ArrawView.backgroundColor = [UIColor clearColor];
    [self addSubview:ArrawView];
    
    ArrawView.transform = CGAffineTransformMakeRotation(M_PI * (float)-112.5/180.0f);


    
    
    centerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    centerV.backgroundColor = UIColorFromHex(0xFADAC5);
    centerV.layer.masksToBounds = YES;
    centerV.layer.cornerRadius = 10.5;
    centerV.layer.borderWidth = 3;
    centerV.layer.borderColor = UIColorFromHex(0xF97E2C).CGColor;
    [self addSubview:centerV];
    centerV.center = centerPoint;
    
    sepView = [[NSMutableArray alloc] init];

    
    
    //主要解释一下各个参数的意思
    //center  中心点（可以理解为圆心）
    //radius  半径
    //startAngle 起始角度
    //endAngle  结束角度
    //clockwise  是否顺时针
    UIBezierPath *cicrle     = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:centerPoint.y*1
                                                              startAngle:- M_PI -M_PI/8
                                                              endAngle: M_PI/8
                                                              clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth     = centerPoint.y *0.15;
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   =UIColorFromHex(0xcdeaf6).CGColor;
    shapeLayer.path          = cicrle.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    if (1) {
        UIBezierPath *cicrle     = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                  radius:centerPoint.y*1
                                                                  startAngle:- M_PI -M_PI/8
                                                                  endAngle: M_PI/8
                                                                  clockwise:YES];
        shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.lineWidth     = centerPoint.y *0.15;
        shapeLayer1.fillColor     = [UIColor clearColor].CGColor;
        shapeLayer1.strokeColor   =UIColorFromHex(0x019AD8).CGColor;
        shapeLayer1.path          = cicrle.CGPath;
        [self.layer addSublayer:shapeLayer1];
    }
    
    
    CGFloat perAngle = (M_PI + (float)45 / 180 *M_PI) / 10;
    
    CGFloat start = -M_PI - (float)22.5 / 180 *M_PI;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 0; i< 11; i++) {
            
        CGFloat startAngel = (start  + perAngle * i) - (float)1/360 * M_PI;
        CGFloat endAngel   = startAngel + (float)2/360 * M_PI;

        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:centerPoint.y*0.8 startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = UIColorFromHex(0xF97E2C).CGColor;
        perLayer.lineWidth   = centerPoint.y *0.1;

        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
            
        if (i%2 ==0) {
            CGPoint point      = [self calculateTextPositonWithArcCenter:centerPoint Angle:-startAngel h:centerPoint.y*0.6];
            NSString *tickText = [NSString stringWithFormat:@"%d",(i)*10];

            UILabel *text      = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 25, 14)];
            text.text          = tickText;
            text.font          = [UIFont systemFontOfSize:12];
            text.textColor     = UIColorFromHex(0x606266);
            text.textAlignment = NSTextAlignmentCenter;
            [self addSubview:text];
        }
    }

    
    
    
    
    [self loadRate];
    
}


 
//默认计算半径135
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
                                           h:(CGFloat)h
{
    CGFloat x = h * cosf(angel);
    CGFloat y = h * sinf(angel);

    return CGPointMake(center.x + x, center.y - y);
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    [self createUI];
    

    
}


@end
