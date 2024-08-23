//
//  PointErrorsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointErrorsViewController : BaseTableViewController
{
    
    
}

- (id)initWithCheck:(NSDictionary *)check andLocation:(NSDictionary *)lo andPoint:(NSDictionary*)po;
@end

NS_ASSUME_NONNULL_END
