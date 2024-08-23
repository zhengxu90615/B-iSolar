//
//  LoginViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    IBOutlet UIImageView *logoImV;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    loginBtn.backgroundColor = MAIN_TINIT_COLOR;
    loginBtn.layer.cornerRadius = BUTTON_CORNERRADIUS;
    
    
    UIImage *image = logoImV.image;
    logoImV.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [logoImV setTintColor:MAIN_TINIT_COLOR];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastLoginAcc = [defaults objectForKey:@"ws.accountT.text"];
    if (lastLoginAcc){
        self.accountT.text = lastLoginAcc;
    }
//    logoImV.image = [logoImV.image imageChangeColor:MAIN_TINIT_COLOR];
    // Do any additional setup after loading the view from its nib.
}

//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat rects = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 +50);
    
    if (rects <= 0) {
        weak_self(ws)
        [UIView animateWithDuration:0.3 animations:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect frame = ws.view.frame;
                frame.origin.y = rects;
                ws.view.frame = frame;
            });
        }];
    }
    return YES;
}

//结束编辑时键盘下去 视图下移动画
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    weak_self(ws);
    [UIView animateWithDuration:0.3 animations:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = ws.view.frame;
            frame.origin.y = 0.0;
            ws.view.frame = frame;
        });
        
        
    }];
    return YES;
}


- (IBAction)bgClick:(id)sender {
    [self.accountT resignFirstResponder];
    [self.pwdT resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountT) {
        [self.pwdT becomeFirstResponder];
    }else{
        [self loginClick:nil];
    }
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginClick:(nonnull id)sender {
    [self bgClick:nil];
    
    if (_accountT.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入账号")];
        return;
    }
    if (_pwdT.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入密码")];
        return;
    }
    
    NSDictionary *dic = @{@"account":self.accountT.text,@"password":[self.pwdT.text stringFromMD5]};
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
              
    [apiBlock startRequest:dic uri:API_LOGIN result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:ws.accountT.text forKey:@"ws.accountT.text"];
            [defaults synchronize];
            
            [BAPIHelper saveUserInfo:respModel.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN object:nil];
                }];
            });
            
           
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
}



- (IBAction)forgotClick:(id)sender {
    [self bgClick:nil];
    
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:String(@"提示") message:String(@"请联系客服\nbisolar@boe.com.cn") preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:String(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"UIAlertActionStyleDestructive");
    }];
    [alertController addAction: destructiveBtn];

    [self presentViewController:alertController animated:YES completion:nil];

    
}


@end
