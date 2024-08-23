//
//  CDZQRCodeViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/14.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface CDZQRScanViewController : UIViewController
{
    NormalBlock myBlock;
}
- (id)initWithAction:(NormalBlock)block;
@end
