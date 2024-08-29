//
//  FGTPwdViewController.m
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/10.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "PwdChangeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "OneAuthAPIHelper.h"
#import "OneAuthResponseModel.h"
#import "OneAuthUtil.h"
#import "OARequest.h"
@interface MyTextField ()
@end
@implementation MyTextField

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColorFromHex(0xE9EBEE).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}
@end
    
@interface PwdChangeViewController ()<UIWebViewDelegate,UITextFieldDelegate,WKNavigationDelegate,WKUIDelegate>
{
    IBOutlet UITextField *accountT;
    IBOutlet UITextField *codeT;
    IBOutlet UITextField *pwdT;
    IBOutlet UITextField *pwd2T;
    IBOutlet UIButton *sendBtn;
    IBOutlet UIButton *confirmBtn;
    
    IBOutlet UILabel *titleLabel;
    BOOL isForget;
}

@property (strong, nonatomic) IBOutlet WKWebView *webV;
@property (strong, nonatomic)  UITextField *accountT;
@property (strong, nonatomic)  UITextField *pwdT;
@property (strong, nonatomic)  UITextField *codeT;
@property (strong, nonatomic)  UITextField *pwd2T;
@end

@implementation PwdChangeViewController
@synthesize accountT,pwdT,codeT,pwd2T;

- (instancetype)initWithForget{
    if (self = [super init]) {
        isForget = YES;
    }
    return self;
}


- (WKWebView*)webV{
    if (_webV == nil) {
        // 初始化配置定制
          WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//        // 用户拷贝网页内容的时候的粒度
//          configuration.selectionGranularity = WKSelectionGranularityDynamic;
//          // 允许在网页内部播放视频
//          configuration.allowsInlineMediaPlayback = YES;
//
//          WKPreferences *preferences = [WKPreferences new];
//        // 是否支持 JavaScript
//          preferences.javaScriptEnabled = YES;
//          // 不通过用户交互，是否可以打开窗口
//          preferences.javaScriptCanOpenWindowsAutomatically = YES;
//          configuration.preferences = preferences;
 
          // WKWebView
        
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetTextField:(UITextField *)textF{
    
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.title = @"忘记密码";
    // Do any additional setup after loading the view from its nib.
    self.webV.hidden = YES;

    self.webV.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (isForget) {
        self.title = @"修改密码";
        titleLabel.text = @"修改密码";
        self.navigationController.navigationBarHidden = YES;

        NSDictionary *uInfo = [BAPIHelper getUserInfo];

        self.accountT.text = [uInfo objectForKey:@"phone"];
        self.accountT.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isForget) {
           self.navigationController.navigationBarHidden = YES;
    }
}
- (IBAction)bgClick:(id)sender {
    [self.accountT resignFirstResponder];
    [self.pwdT resignFirstResponder];
    [self.pwd2T resignFirstResponder];
    [self.codeT resignFirstResponder];
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int MAXLENGTH = 100;
    if (codeT == textField) {
        MAXLENGTH = 10;
    }
    
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;

    NSUInteger newLength = oldLength - rangeLength + replacementLength;

    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;

    return newLength <= MAXLENGTH || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountT) {
        [self.codeT becomeFirstResponder];
    }else if(textField == self.codeT)
    {
        [self.pwdT becomeFirstResponder];
    }else if(textField == self.pwdT)
    {
        [self.pwd2T becomeFirstResponder];

    }
    else{
        [self loginClick:nil];
    }
    return true;
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
    
    self.webV.frame = CGRectMake(10, MIN((MAINSCREENHEIGHT-((MAINSCREENWIDTH-20)*1.1) )/2, 87 + 77), MAINSCREENWIDTH-20, (MAINSCREENWIDTH-20)*1.1);
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"007"
                               ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                            encoding:NSUTF8StringEncoding
                              error:nil];
    [self.webV loadHTMLString:htmlCont baseURL:baseURL];
    [_webV setBackgroundColor:[UIColor clearColor]];
    [_webV setOpaque:NO];
    self.webV.hidden = NO;
}



- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
 
    if ([message.name isEqualToString:@"hidder"]) {
        self.webV.hidden = YES;
    }else if ([message.name isEqualToString:@"loadFinish"]) {
        NSDictionary *dic = [message.body  mj_JSONObject];
        [self sendSmsCode:dic];
        self.webV.hidden = YES;
    }
}

- (void)sendSmsCode:(NSDictionary *)dic{
    
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    [newDic setObject:@"pwd_change_sms_code" forKey:@"op"];
    [newDic setObject:self.accountT.text forKey:@"phone"];
    OARequest * apiBlock = [[OARequest alloc] initWithDictionary:nil respEntityName:nil];
    weak_self(ws);
    
    [apiBlock startRequest:newDic apiName:@"getSmsCode" result:^(OneAuthResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            //[SVProgressHUD showErrorWithStatus:String(@"开始倒计时")];
            [ws startTimer];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
}



- (IBAction)loginClick:(id)sender {
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    
    if (self.accountT.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入手机号码")];
        [self.accountT becomeFirstResponder];
        return;
    }
    if (![OneAuthUtil isPhone:self.accountT.text] ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入正确的手机号码")];
        [self.accountT becomeFirstResponder];
        return;
    }
    
    if (self.codeT.text.length ==0 ) {
        [SVProgressHUD showErrorWithStatus:String(@"请输入验证码")];
        [self.codeT becomeFirstResponder];
        return;
    }
    
    if (self.pwdT.text.length ==0 ) {
           [SVProgressHUD showErrorWithStatus:String(@"请输入新密码")];
           [self.pwdT becomeFirstResponder];
           return;
       }
    
    if (self.pwd2T.text.length ==0 ) {
           [SVProgressHUD showErrorWithStatus:String(@"请再次输入新密码")];
           [self.pwd2T becomeFirstResponder];
           return;
       }
    
    if (![self.pwdT.text isEqualToString:self.pwd2T.text] ) {
           [SVProgressHUD showErrorWithStatus:String(@"两次输入的密码不一致")];
           [self.pwd2T becomeFirstResponder];
           return;
       }
    
    
    [newDic setObject:self.accountT.text forKey:@"phone"];
    [newDic setObject:self.codeT.text forKey:@"sms_code"];

    OARequest * apiBlock = [[OARequest alloc] initWithDictionary:nil respEntityName:nil];
    weak_self(ws);
    
    [apiBlock startRequest:newDic apiName:@"pwdChangeSmsCode0" result:^(OneAuthResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
            [newDic setObject:ws.accountT.text forKey:@"phone"];
            [newDic setObject:[[self.pwdT.text stringFromMD5] lowercaseString] forKey:@"new_pwd"];
            [newDic setObject:respModel.data[@"ticket"] forKey:@"ticket"];

            OARequest * apiBlock = [[OARequest alloc] initWithDictionary:nil respEntityName:nil];
            
            [apiBlock startRequest:newDic apiName:@"pwdChangeSmsCode1" result:^(OneAuthResponseModel * _Nonnull respModel) {
                if (respModel.success) {
                    
                    
                        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:String(@"提示") message:String(@"密码重置成功") preferredStyle:UIAlertControllerStyleAlert] ;
                        UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:String(@"登录") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                            NSLog(@"UIAlertActionStyleDestructive");
                            [ws backBtnClick:nil];
                        }];
                        [alertController addAction: destructiveBtn];
                    
                        [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
                }
            }];
            
            
            
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
