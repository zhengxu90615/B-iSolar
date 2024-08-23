//
//  ChangePwdViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/4.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()
{
    IBOutlet UITextField *oldPwdText;
    IBOutlet UITextField *newPwdText;
    
    IBOutlet UIButton *changeBtn;
    IBOutlet UIImageView *imgV1;
    IBOutlet UIImageView *imgV2;

}
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    changeBtn.backgroundColor = MAIN_TINIT_COLOR;
    changeBtn.layer.cornerRadius = BUTTON_CORNERRADIUS;
    
    oldPwdText.placeholder = String(@"请输入原密码");
    newPwdText.placeholder = String(@"请输入新密码");
    // Do any additional setup after loading the view from its nib.
    
    
    imgV1.image = [[UIImage imageNamed:@"pwd"] imageChangeColor:MAIN_TINIT_COLOR];
    imgV2.image = [[UIImage imageNamed:@"pwd"] imageChangeColor:MAIN_TINIT_COLOR];

}
- (IBAction)btnClick:(id)sender {
    
    if (oldPwdText.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入原密码")];
        return;
    }
    if (newPwdText.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入新密码")];
        return;
    }
    
    NSDictionary *dic = @{@"oldpwd":[oldPwdText.text stringFromMD5],@"pwd":[newPwdText.text stringFromMD5]};
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    
    [apiBlock startRequest:dic uri:API_PWD_CHANGE result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [SVProgressHUD showSuccessWithStatus:respModel.message];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
