//
//  MarkAlert.h
//  Operator
//
//  Created by Mark on 14-10-16.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarkAlert;

@protocol MarkAlertDelegate <NSObject>

- (void)markAlert:(MarkAlert*)alert  clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MarkAlert : UIView<UITextViewDelegate>
{
    id<MarkAlertDelegate>delegate;
    
}
SHARED_INSTANCE_DEFINE(MarkAlert)

@property (nonatomic,readwrite)   BOOL showed;

@property (nonatomic,readwrite)   float money;
//- (id)initWithTitle:(NSString *)title andMessage:(NSString*)message  delegate:(id<MarkAlertDelegate>)dele;  //message短
//- (id)initWithMessage:(NSString*)message  delegate:(id<MarkAlertDelegate>)dele;

- (id)initWithTitle:(NSString *)title andMessage:(NSString*)message  andButton0:(NSString *)btn0 andButton1:(NSString *)btn1  delegate:(id<MarkAlertDelegate>)dele;

- (id)initWithPayTitle:(NSString *)title andMessage:(NSString*)message  andButton0:(NSString *)btn0 andButton1:(NSString *)btn1  delegate:(id<MarkAlertDelegate>)dele;

-(id) initWithPayAction:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result;

-(id) initWithPayActionOnlyOne:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result;


-(id) initWithPayAction:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result andSelected:(NSArray*)arr;
-(id)initWithShareAction:(NSString*)title channel:(NSArray*)channels result:(void (^)(NSInteger))result;

- (id)initWithLoginPlace:(NSString *)loginPlace andInfoPlace:(NSString *)infoPlace andNeedLoginOut:(BOOL)needLogout;

- (id)initWithElec;

- (void)show;

-(void)show:(void (^)(NSInteger aaa))result inView:(UIView *)v andbizType:(int)biz;

-(void)show:(void (^)(NSInteger aaa))result;

- (void)dismiss;

@end
