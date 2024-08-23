//
//  QrScanUploadViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/14.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QrScanUploadViewController : BaseViewController
{
    IBOutlet UIImageView *imgV;
    IBOutlet UIButton *copyBtn;
}
- (id)initWithMessage:(NSString*)mess;
- (IBAction)btnClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
