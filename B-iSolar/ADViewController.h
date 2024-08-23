//
//  ADViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/20.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import "ATCountdownButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADViewController : BaseViewController
{
    ATCountdownButton *button;
    
    IBOutlet UIImageView *adImage;
}
- (id)initWithADDic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
