//
//  BaseViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/28.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BResponseModel;
@interface BaseViewController : UIViewController
{
    BResponseModel *dataModel;
    BHttpRequest * requestHelper;
    NSInteger    pageIndex;
}

@property (strong, nonatomic) BHttpRequest * requestHelper;
@property (strong, nonatomic) BResponseModel *dataModel;
@property (readwrite, nonatomic) NSInteger    pageIndex;
-(BOOL) dismissAllKeyBoardInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
