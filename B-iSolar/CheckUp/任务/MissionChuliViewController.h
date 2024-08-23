//
//  MissionChuliViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MissionChuliViewController : BaseTableViewController
{
    UIView *buttonView;
    
    UIButton*button1;
}
- (id)initWithMission:(NSDictionary*)miss;

@end

NS_ASSUME_NONNULL_END
