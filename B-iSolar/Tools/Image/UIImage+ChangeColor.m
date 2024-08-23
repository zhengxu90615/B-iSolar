//
//  UIImage+ChangeColor.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/1.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "UIImage+ChangeColor.h"

@implementation UIImage (ChangeColor)

//绘图
-(UIImage*)imageChangeColor:(UIColor*)color
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//绘图
-(UIImage*)imageChangeColor:(UIColor*)color WithNumberRight:(NSString *)numString
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @ {
        NSForegroundColorAttributeName:[UIColor redColor],
        NSBackgroundColorAttributeName:[UIColor clearColor],
        NSFontAttributeName:FONTSIZE_TABLEVIEW_CELL_DESCRIPTION2,
        NSParagraphStyleAttributeName:paragraph,
        NSObliquenessAttributeName:@0.2
    };
    
    [[UIColor redColor] set];
    
    if (![numString isEqualToString:@"0"] && ![numString isEqualToString:@"<null>"]) {
        [numString drawInRect:CGRectMake(0, 2, self.size.width, self.size.height) withAttributes:attributes];
    }
    
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



//拍照水印
-(UIImage*)imageWithStringRightBottom:(NSString *)string
{
    NSUInteger inputWidth = self.size.width;
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(self.size);
    
    //    开始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    NSInteger targetGhostWidth = inputWidth * 0.3;
    
    
    //画logo
    UIImage *logoImage=[UIImage imageNamed:@"icon_logo"];
    CGFloat logoW=self.size.width/30;
    CGFloat logoH=self.size.width/30;
    [logoImage drawInRect:CGRectMake(10, 10, logoW, logoH)];

    //    渲染文字
    NSUInteger wordFont = self.size.width/40;
    NSUInteger wordHigh = 520;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:wordFont], NSForegroundColorAttributeName:WHITE_COLOR , NSParagraphStyleAttributeName:paragraphStyle};
    [string drawInRect:CGRectMake(logoW+20, 20, self.size.width*0.9, wordHigh) withAttributes:dic];
   

    dic = @{NSFontAttributeName:[UIFont systemFontOfSize:wordFont], NSForegroundColorAttributeName:MAIN_TINIT_COLOR, NSParagraphStyleAttributeName:paragraphStyle};
    [string drawInRect:CGRectMake(logoW+20+2, 22, self.size.width*0.9, wordHigh) withAttributes:dic];
    
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



- (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment
{
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    

    CGSize size = CGSizeMake(MAINSCREENHEIGHT, MAINSCREENHEIGHT);
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)])
    {
        if (UIScreen.mainScreen.scale == 2.0)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        } else
        {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [MAIN_BACKGROUND_COLOR set];
    
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    CGContextFillRect(context, rect);
    
    size = [string boundingRectWithSize:CGSizeMake(width, 10000)
                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                            attributes:attributeDic
                               context:nil].size;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = textAlignment;
    NSDictionary *attributes = @ {
    NSForegroundColorAttributeName:COLOR_TABLE_TITLE,
    NSBackgroundColorAttributeName:[UIColor clearColor],
    NSFontAttributeName:font,
    NSParagraphStyleAttributeName:paragraph,
    NSObliquenessAttributeName:@0.2
    };

    
    for (int x = 0-size.width*0.5; x<MAINSCREENHEIGHT; x+=size.width*1.8) {
        for (int y = 0; y<MAINSCREENHEIGHT; y+=size.height*10) {
            rect = CGRectMake(x, y, size.width + 1, size.height + 1);
            [string drawInRect:rect withAttributes:attributes];
        }
    }
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
