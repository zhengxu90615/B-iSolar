//
//  MissionDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/24.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MissionDetailViewController : BaseTableViewController
{
    UIView *buttonView;
    
    UIButton*button1;
    UIButton*button2;
}


- (id)initWithMission:(NSDictionary*)miss;

- (id)initWithNoti:(NSDictionary*)miss;

@end

NS_ASSUME_NONNULL_END
