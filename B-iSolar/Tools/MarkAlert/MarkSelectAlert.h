//
//  MarkAlert.h
//  Operator
//
//  Created by Mark on 14-10-16.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkAlert.h"
@class MarkSelectAlert;



@interface MarkSelectAlert : UIView<UITextViewDelegate>
{
    id<MarkAlertDelegate>delegate;
    
}
SHARED_INSTANCE_DEFINE(MarkAlert)

@property (nonatomic,readwrite)   BOOL showed;

@property (nonatomic,readwrite)   float money;



- (id)initUsers:(NSArray *)users andSelected:(NSArray*)sel result:(void (^)(NSArray*))result;;



- (void)show;



- (void)dismiss;

@end
