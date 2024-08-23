//
//  BMKCustomAnnotationView.m
//  BMKCustomAnnotationDemo
//
//  Created by Baidu on 2020/5/19.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BMKCustomAnnotationView.h"

@implementation BMKCustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier andStatus:(int)sta{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, 20, 20);
        UIImageView *annotationImage = [[UIImageView alloc] initWithFrame:self.frame];
        NSString*imgName =@"pin-gray";
        if (sta == 1) {
            imgName =@"pin-green";
        }else if (sta== -1){
            imgName =@"pin-red";
        }
        annotationImage.animationImages = @[[UIImage imageNamed:imgName]];
        annotationImage.animationDuration = 0.75 * 2;
        annotationImage.animationRepeatCount = 0;
        [annotationImage startAnimating];
        [self addSubview:annotationImage];
    }
    return self;
}

@end
