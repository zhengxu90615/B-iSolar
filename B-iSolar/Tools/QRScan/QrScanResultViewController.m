//
//  QrScanResultViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/14.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "QrScanResultViewController.h"
#import <CoreNFC/CoreNFC.h>

@interface QrScanResultViewController ()<NFCTagReaderSessionDelegate>
{
    NSString *resultStr;
}


@property(strong,nonatomic)id<NFCNDEFTag> cuurentTag;
@property(strong,nonatomic)NFCNDEFReaderSession *session;
@end

@implementation QrScanResultViewController
- (id)initWithRes:(NSString *)st{
    if (self = [super init]){
        resultStr = st;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    resLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    resLabel.textColor = COLOR_TABLE_TITLE;
    resLabel.text = resultStr;
    
    [copyBtn setTintColor:WHITE_COLOR];
    [copyBtn setBackgroundColor:MAIN_TINIT_COLOR];
    copyBtn.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    copyBtn.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    copyBtn.clipsToBounds = YES;
    
//    if ([resultStr hasPrefix:@"writenfc:"]) {
//        self.title = @"NFC写卡";
//          [copyBtn setTitle:@"点击写卡" forState:UIControlStateNormal];
//    }
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClick:(id)sender {
    
//    if ([resultStr hasPrefix:@"writenfc:"]) {
//
//        self.session = [[NFCTagReaderSession alloc]
//                            initWithPollingOption:(NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO15693) delegate:self queue:dispatch_get_main_queue()];
//
//        self.session.alertMessage = @"准备写入卡片，请将卡片靠近手机";
//
//        [self.session beginSession]; //开始识别 弹出识别提示框
//
//
//
//    }else{
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:resultStr];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
//    }
    
   
}




- (void)tagReaderSession:(NFCTagReaderSession *)session  didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags{

    if ([tags firstObject].type == NFCTagTypeMiFare) {

        id<NFCMiFareTag> mifareTag = [[tags firstObject] asNFCMiFareTag];
        NSData *data = mifareTag.identifier;
        
//        NFCNDEFMessage *message = [ NFCNDEFMessage alloc] initw
        
        [mifareTag writeNDEF:@"22222222" completionHandler:^(NSError * error) {
            NSLog(@"%@",error);
        }];
    }
    [self.session invalidateSession];


}
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
   // 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
   NSLog(@"错误回调 : %@", error);
}

- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, macos, tvos);
{
    NSLog(@"错误回调 : %@", error);

}
@end
