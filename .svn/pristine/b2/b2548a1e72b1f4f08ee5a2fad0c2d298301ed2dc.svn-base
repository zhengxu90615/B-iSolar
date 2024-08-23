//
//  DottedLineView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "DottedLineView.h"

@implementation DottedLineView

- (void)drawRect:(CGRect)rect { // 可以通过 setNeedsDisplay 方法调用 drawRect:
   // Drawing code

   CGContextRef context =UIGraphicsGetCurrentContext();
   // 设置线条的样式
   CGContextSetLineCap(context, kCGLineCapRound);
   // 绘制线的宽度
   CGContextSetLineWidth(context, 2.0);
   // 线的颜色
   CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
   // 开始绘制
   CGContextBeginPath(context);
   // 设置虚线绘制起点
   CGContextMoveToPoint(context, 0, 0);
   // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
   CGFloat lengths[] = {5,5};
   // 虚线的起始点
   CGContextSetLineDash(context, 0, lengths,2);
   // 绘制虚线的终点
    CGContextAddLineToPoint(context, 0, rect.size.height);
   // 绘制
   CGContextStrokePath(context);
   // 关闭图像
   CGContextClosePath(context);
}
@end
