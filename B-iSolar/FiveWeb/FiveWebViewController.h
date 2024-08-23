//
//  FiveWebViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiveWebViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *mainWebV;
}
@property (strong, nonatomic) IBOutlet UIWebView *mainWebV;

@end

NS_ASSUME_NONNULL_END
