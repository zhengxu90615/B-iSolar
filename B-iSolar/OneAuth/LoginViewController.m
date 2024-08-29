//
//  LoginViewController.m
//  B-iWeather
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "LoginViewController.h"
#import "PwdChangeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "OneAuth.h"
#import "UIKit+AFNetworking.h"

@interface LoginViewController ()<UIWebViewDelegate,UITextFieldDelegate,WKNavigationDelegate,WKUIDelegate>
{
    IBOutlet UIImageView *logoImV;
    
    IBOutlet UIButton *smsBtn;
    IBOutlet UIButton *sendBtn;
    IBOutlet UIButton *forgotBtn;
    
    NSTimer *btnTimer;
    NSString *tenantID;
}
@property (strong, nonatomic) IBOutlet WKWebView *webV;
@property (strong, nonatomic) NSTimer *btnTimer;
@end

@implementation LoginViewController
@synthesize btnTimer;


#pragma mark 懒加
- (WKWebView*)webV{
    if (_webV == nil) {
        
    
        
        // 初始化配置定制
          WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//        // 用户拷贝网页内容的时候的粒度
//          configuration.selectionGranularity = WKSelectionGranularityDynamic;

        [configuration.userContentController addScriptMessageHandler:self name:@"loadFinish"];

        [configuration.userContentController addScriptMessageHandler:self name:@"hidder"];
        
        _webV = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,10,10) configuration:configuration];
        [self.view addSubview:_webV];
          // 有两种代理：UIDelegate负责界面弹窗；navigationDelegate负责加载、跳转等
        _webV.UIDelegate = self;
        _webV.navigationDelegate = self;

        
    }
    return _webV;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self reSetBtn:smsBtn];
    
    self.webV.hidden = YES;

    CGRect frame = self.accountT.frame;
    frame.size.width = 10;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.accountT.leftViewMode = UITextFieldViewModeAlways;
    self.accountT.leftView = leftview;
    
    frame = self.pwdT.frame;
    frame.size.width = 10;
    leftview = [[UIView alloc] initWithFrame:frame];
    self.pwdT.leftViewMode = UITextFieldViewModeAlways;
    self.pwdT.leftView = leftview;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * lastLoginAcc = [defaults objectForKey:@"ws.accountT.text"];
    if (lastLoginAcc){
        self.accountT.text = lastLoginAcc;
    }
    
    [_webV setBackgroundColor:[UIColor clearColor]];
    [_webV setOpaque:NO];
//    smsBtn.hidden = YES;
    
    if ([AppDelegate logoPath]) {
        
        [logoImV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_HOST_MAIN,[AppDelegate logoPath]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    
//    self.accountT.text = @"18501501107";
//    self.pwdT.text = @"iostest123@A";
    
//    self.accountT.text = @"18501501106";
//    self.pwdT.text = @"123456@A";

}

- (void)startTimer{
    //启动倒计时
    [self performSelector:@selector(reflashGetKeyBt:)withObject:[NSNumber numberWithInt:60] afterDelay:0];
}

//倒数
- (void)reflashGetKeyBt:(NSNumber *)second
{
   if ([second integerValue] == 0)
    {
        sendBtn.userInteractionEnabled=YES;
        [sendBtn setTitle:@"重新获取"forState:(UIControlStateNormal)];
    }
   else
    {
        sendBtn.userInteractionEnabled=NO;
       int i = [second intValue];
        [sendBtn setTitle:[NSString stringWithFormat:@"重新获取(%i)",i]forState:(UIControlStateNormal)];
        [self performSelector:@selector(reflashGetKeyBt:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
    
}



- (void)reSetBtn:(UIButton *)btn{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    CGFloat btnImageWidth = btn.imageView.bounds.size.width;
    CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
    CGFloat margin = 3;

    btnImageWidth += margin;
    btnLabelWidth += margin;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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





- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int MAXLENGTH = 10;
    if (smsBtn.tag == 0) {
        MAXLENGTH = 100;
    }
    
    if (textField == self.accountT) {
        MAXLENGTH = 100;
    }
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;

    NSUInteger newLength = oldLength - rangeLength + replacementLength;

    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;

    return newLength <= MAXLENGTH || returnKey;
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
//
//- (void)checkEnable{
//    
//}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
 
    if ([message.name isEqualToString:@"hidder"]) {
        self.webV.hidden = YES;
    }else if ([message.name isEqualToString:@"loadFinish"]) {
        NSDictionary *dic = [message.body  mj_JSONObject];
        [self sendSmsCode:dic];
        self.webV.hidden = YES;
    }
}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    weak_self(ws);
//    
//    context[@"console"][@"log"] = ^(JSValue *msg){
//        NSLog(@"************    JavaScript: %@ -- log: %@    ************", [JSContext currentContext], [msg toString]);
//    };
//    context[@"loadFinish"] = ^(JSValue *msg){
////        NSLog(@"************    JavaScript: %@ -- log: %@    ************", [JSContext currentContext], );
//        NSDictionary *dic = [[msg toString] mj_JSONObject];
//        [ws sendSmsCode:dic];
//    };
//    context[@"hidder"] = ^(JSValue *msg){
//        ws.webV.hidden = YES;
//    };
//    
//    //    self.navigationItem.title = _webView.title;
//    //    NSLog(@"self.title=%@",self.title);
//}


- (void)sendSmsCode:(NSDictionary *)dic{
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    [newDic setObject:@"login" forKey:@"op"];
    [newDic setObject:self.accountT.text forKey:@"phone"];
    OARequest * apiBlock = [[OARequest alloc] initWithDictionary:nil respEntityName:nil];
    weak_self(ws);
    
    [apiBlock startRequest:newDic apiName:@"getSmsCode" result:^(OneAuthResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [ws startTimer];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
}



- (IBAction)loginClick:(nonnull id)sender {
    [self bgClick:nil];
    
    if (_accountT.text.length ==0 ) {
        if (smsBtn.tag == 0) {
            [SVProgressHUD showErrorWithStatus:String(@"请输入账号或手机号")];
            [self.accountT resignFirstResponder];
        }else{
            [SVProgressHUD showErrorWithStatus:String(@"请输入手机号")];
            [self.accountT resignFirstResponder];
        }
        return;
    }
    
    if (_pwdT.text.length ==0 ) {
        if (smsBtn.tag == 0) {
            [SVProgressHUD showErrorWithStatus:String(@"请输入密码")];
            [self.pwdT resignFirstResponder];
        }else{
            [SVProgressHUD showErrorWithStatus:String(@"请输入验证码")];
            [self.pwdT resignFirstResponder];
        }
        return;
    }
    NSLog(@"pwd=%@",self.pwdT.text);
    NSMutableDictionary* dic =[[NSMutableDictionary alloc] initWithDictionary:@{@"version":@"v2",@"account":self.accountT.text}];
    
    if (smsBtn.tag == 0) {
        [dic setObject:[self.pwdT.text stringFromMD5] forKey:@"password"];
    }else{
        [dic setObject:self.pwdT.text forKey:@"sms_code"];
    }
    
    if (tenantID) {
        [dic setObject:tenantID forKey:@"tenantId"];
        tenantID = nil;
    }
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);

    [apiBlock startRequest:dic uri:API_LOGIN result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            NSDictionary *data = respModel.data;
            if ([[data allKeys] containsObject:@"list"] ){
                
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择租户" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                for (NSDictionary * proj in [data objectForKey:@"list"] ) {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:proj[@"tenant"][@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"proj=%@",proj);
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults synchronize];
                        tenantID = [NSString stringWithFormat:@"%@", proj[@"tenant"][@"id"]];
                        [ws loginClick:nil];
                   }];
                    [actionSheet addAction:action1];
                }
         
                   //相当于之前的[actionSheet show];
                [self presentViewController:actionSheet animated:YES completion:nil];
                
            }else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:ws.accountT.text forKey:@"ws.accountT.text"];
                [defaults synchronize];
                
                
                [BAPIHelper saveUserInfo:  [respModel.data isKindOfClass:[NSDictionary class]]?respModel.data : respModel.data[0]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ws dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN object:nil];
                    }];
                });
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
    
//    [apiBlock startRequest:dic apiName:@"getToken" result:^(OneAuthResponseModel * _Nonnull respModel) {
//        if (respModel.success) {
//
//
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:ws.accountT.text forKey:@"ws.accountT.text"];
//            [defaults synchronize];
//
//            [BAPIHelper saveUserInfo:respModel.data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [ws dismissViewControllerAnimated:YES completion:^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN object:nil];
//                }];
//            });
//        }else{
//            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
//        }
//    }];
    
}


- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}
- (IBAction)changeClick:(id)sender {
    
    if (((UIButton*)sender).tag == 100 ){
                
        NSDictionary* dic = @{};

        BHttpRequest * apiBlock = [BHttpRequest new];
        weak_self(ws);
        apiBlock.needShowHud = @(1);
        
        [apiBlock startRequest:dic uri:[NSString stringWithFormat:@"%@%@",API_HOST_MAIN,API_PROJECT] result:^(BResponseModel * _Nonnull respModel) {
            if (respModel.success) {
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择服务商" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

                NSArray *projArr = [respModel.data[@"projList"] mj_JSONObject];
                for (NSDictionary * proj in projArr) {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:proj[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"proj=%@",proj);
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:proj forKey:@"server"];
                        [defaults synchronize];
                        
                        [logoImV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_HOST_MAIN,[AppDelegate logoPath]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                        //                        serverName.text = [AppDelegate serverName];

                   }];
                    [actionSheet addAction:action1];
                }
         
                   //相当于之前的[actionSheet show];
                [self presentViewController:actionSheet animated:YES completion:nil];

            }else{
                [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
            }
        }];
        
        return;
        
        return;
    }
    
    if (smsBtn.tag == 0) {
        smsBtn.tag = 1;
        [smsBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        self.pwdT.placeholder = @"请输入验证码";
        self.accountT.placeholder = @"请输入手机号";
        self.accountT.keyboardType = UIKeyboardTypePhonePad;

    }else{
        smsBtn.tag = 0;
        [smsBtn setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        self.pwdT.placeholder = @"请输入密码";
        self.accountT.placeholder = @"请输入账号或手机号";
        self.accountT.keyboardType = UIKeyboardTypeDefault;
    }
    [self reSetBtn:smsBtn];
    
    self.pwdT.text = @"";

    forgotBtn.hidden = (smsBtn.tag != 0);
    sendBtn.hidden = (smsBtn.tag == 0);

}

- (IBAction)sendClick:(id)sender {
    [self bgClick: nil];
    if (self.accountT.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入手机号码")];
        [self.accountT resignFirstResponder];
        return;
    }
    if (![OneAuthUtil isPhone:self.accountT.text] ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入正确的手机号码")];
        [self.accountT resignFirstResponder];
        return;
    }
     
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.webV.frame = CGRectMake(10, MIN((MAINSCREENHEIGHT-((MAINSCREENWIDTH-20)*1.1) )/2, 87 + 77), MAINSCREENWIDTH-20, (MAINSCREENWIDTH-20)*1.1);
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"007"
                                   ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                encoding:NSUTF8StringEncoding
                                  error:nil];

        [self.webV loadHTMLString:htmlCont baseURL:baseURL];
        self.webV.hidden = NO;

       });
    

}


- (IBAction)forgotClick:(id)sender {
    [self bgClick:nil];
    
    PUSHNAVI(PwdChangeViewController);
    return;

    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:String(@"提示") message:String(@"请联系客服\nbisolar@boe.com.cn") preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:String(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"UIAlertActionStyleDestructive");
    }];
    [alertController addAction: destructiveBtn];

    [self presentViewController:alertController animated:YES completion:nil];

    
}


@end
