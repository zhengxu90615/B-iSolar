//
//  LoginViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIButton *loginBtn;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accTopCon;
@property (weak, nonatomic) IBOutlet UITextField *accountT;
@property (weak, nonatomic) IBOutlet UITextField *pwdT;
- (IBAction)loginClick:(id)sender;
- (IBAction)forgotClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
