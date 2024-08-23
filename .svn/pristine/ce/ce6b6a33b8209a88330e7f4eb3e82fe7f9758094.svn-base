//
//  WriteNFCViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/14.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "WriteNFCViewController.h"
#import "CoreNFC/NFCTag.h"
@interface WriteNFCViewController ()<NFCNDEFReaderSessionDelegate,NFCTagReaderSessionDelegate>
{
    NSString *writeString;
}
@end

@implementation WriteNFCViewController


- (id)initWithString:(NSString *)str{
    if (self = [super init]) {
        
        writeString = [NSString stringWithString:str];
    }
    return self;
}
- (id)initWithString:(NSString *)str andBack:(NormalBlock)block;
{
    if (self = [super init]) {
        myBlock = block;
        writeString = [NSString stringWithString:str];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self writeBtn:nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)writeBtn:(id)sender {
    
    
    if (@available(iOS 13.0,*)) {

       if (NFCNDEFReaderSession.readingAvailable == YES) {
           if ([NFCNDEFReaderSession readingAvailable]) {
               
               
               self.session = [[NFCTagReaderSession alloc]

                                   initWithPollingOption:(NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO15693) delegate:self queue:dispatch_get_main_queue()];

               self.session.alertMessage = @"写入卡片，请将卡片靠近手机";

               [self.session beginSession]; //开始识别 弹出识别提示框
               
               
//               self.session =
//                  [[NFCNDEFReaderSession alloc] initWithDelegate:self
//                                                           queue:nil
//                                        invalidateAfterFirstRead:YES];
//                  // 开始扫描
//                [self.session beginSession];
           }
       }else {
           [SVProgressHUD showErrorWithStatus:@"该机型不支持NFC功能!"];
           
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self dismissViewControllerAnimated:YES completion:^{
                   if (myBlock) {
                       myBlock(nil);
                   }
               }];
           });
           
           
       }
    }else {

        [SVProgressHUD showErrorWithStatus:@"当前系统不支持NFC功能!"];
        NSLog(@"this device not support iOS 11.0");
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                if (myBlock) {
                    myBlock(nil);
                }
            }];
        });
    }
    
}



#pragma mark -- NFC

-(void)tagReaderSession:(NFCTagReaderSession *)session  didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags{

  self.currentTag = [tags firstObject];
    
//
    id<NFCMiFareTag> mifareTag = [[tags firstObject] asNFCMiFareTag];
    NSData *identifierData = mifareTag.identifier;
    
    
    NSString *type = @"T";
    NSData *typeData = [type dataUsingEncoding:NSUTF8StringEncoding];

    
    NSString *payload1 = writeString;
    NSData *payloadData = [payload1 dataUsingEncoding:NSUTF8StringEncoding];

    NFCNDEFPayload *NDEFPayload1 = [[NFCNDEFPayload alloc]initWithFormat:NFCTypeNameFormatNFCWellKnown type:typeData identifier:identifierData payload:payloadData];
    NFCNDEFMessage *essage = [[NFCNDEFMessage alloc]initWithNDEFRecords:@[NDEFPayload1]];
    
    
    [_session connectToTag:self.currentTag completionHandler:^(NSError * _Nullable er) {
        if (er) {
            [SVProgressHUD showErrorWithStatus:er.userInfo.description];
            [session invalidateSession];
        }else{
            [mifareTag writeNDEF:essage completionHandler:^(NSError * error) {
                [session invalidateSession];
                if (error) {
                        [SVProgressHUD showErrorWithStatus:error.userInfo.description];

                    }else{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //2.0秒后追加任务代码到主队列，并开始执行
                            //打印当前线程
                            [SVProgressHUD showSuccessWithStatus:@"写入成功"];

                            [self dismissViewControllerAnimated:YES completion:^{
                                if (myBlock) {
                                    myBlock(nil);
                                }
                            }];
                            NSLog(@"xx");
                        });
                    }
            }];
        }
        
        
    }];


    
    
//
//
//

}
- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error{
    // 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
    NSLog(@"错误回调 : %@", error);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (myBlock) {
                myBlock(nil);
            }
        }];
    });
    
}

//- (void)readerSession:(NFCNDEFReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCNDEFTag>> *)tags{
//    self.currentTag = [tags firstObject];
//    
//    [self.session connectToTag:self.currentTag completionHandler:^(NSError * _Nullable error) {
//        [self.currentTag queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
//            if (status == NFCNDEFStatusReadWrite) {
//                
//                NSString *type = @"T";
//                NSData *typeData = [type dataUsingEncoding:NSUTF8StringEncoding];
//                NSString *identifier = @"";
//                NSData *identifierData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
//                NSString *payload1 = writeString;
//                NSData *payloadData = [payload1 dataUsingEncoding:NSUTF8StringEncoding];
//
//                NFCNDEFPayload *NDEFPayload1 = [[NFCNDEFPayload alloc]initWithFormat:NFCTypeNameFormatNFCWellKnown type:typeData identifier:identifierData payload:payloadData];
//                NFCNDEFMessage *essage = [[NFCNDEFMessage alloc]initWithNDEFRecords:@[NDEFPayload1]];
//                
//                
//                [self.currentTag writeNDEF:essage completionHandler:^(NSError * _Nullable err) {
//                   
//                    if (err) {
//                        [SVProgressHUD showErrorWithStatus:err.userInfo.description];
//
//                    }else{
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            //2.0秒后追加任务代码到主队列，并开始执行
//                            //打印当前线程
//                            [SVProgressHUD showSuccessWithStatus:@"写入成功"];
//
//                            [self dismissViewControllerAnimated:YES completion:^{
//                                if (myBlock) {
//                                    myBlock(nil);
//                                }
//                            }];
//                            NSLog(@"xx");
//                        });
//                    }
//                    
//                    
//                    
//                }];
//                
//            }else{
//                [SVProgressHUD showErrorWithStatus:@"当前卡片不支持写入!"];
//                [self dismissViewControllerAnimated:YES completion:^{
//                    if (myBlock) {
//                        myBlock(nil);
//                    }
//                }];
//
//            }
//            
//            [session invalidateSession];
//        }];
//    
//    }];
//}


//- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
//    for (NFCNDEFMessage *message in messages) {
//        for (NFCNDEFPayload *payload in message.records) {
//            NSLog(@"Payload: %@", payload);
//            const NSDate *date = [NSDate date];
//            dispatch_async(dispatch_get_main_queue(), ^{
//               NSString * str = [NSString stringWithFormat:
//                                     @"[%@] Identifier: %@ (%@)\n"
//                                     @"[%@] Type: %@ (%@)\n"
//                                     @"[%@] Format: %d\n"
//                                     @"[%@] Payload: %@ (%@)\n",
//                                     date,
//                                     payload.identifier,
//                                     [[NSString alloc] initWithData:payload.identifier
//                                                           encoding:NSASCIIStringEncoding],
//                                     date,
//                                     payload.type,
//                                     [[NSString alloc] initWithData:payload.type
//                                                           encoding:NSASCIIStringEncoding],
//                                     date,
//                                     payload.typeNameFormat,
//                                     date,
//                                     payload.payload,
//                                     [[NSString alloc] initWithData:payload.payload
//                                                           encoding:NSASCIIStringEncoding]
//                                    ];
//                [SVProgressHUD showErrorWithStatus:str];
//
//            });
//        }
//    }
//}


//// 扫描到的回调
//-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
//
//    /*
//     数组messages中是NFCNDEFMessage对象
//     NFCNDEFMessage对象中有一个records数组，这个数组中是NFCNDEFPayload对象
//     参考NFCNDEFMessage、NFCNDEFPayload类
//     */
//    weak_self(ws);
//    for (NFCNDEFMessage *message in messages) {
//        for (NFCNDEFPayload *record in message.records) {
//
//
//            NSString *dataStr = [[NSString alloc] initWithData:record.payload
//                                                      encoding:NSUTF8StringEncoding];
//            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"zh" withString:@""];
//            dataStr =[dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            dataStr =[dataStr stringByReplacingOccurrencesOfString:@"\x02" withString:@""];
//            NSLog(@"扫描结果 ：%@", dataStr);
//
//
//
//        }
//    }
//    // 主动终止会话，调用如下方法即可。
//    [session invalidateSession];
//}




// 错误回调
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
    // 识别出现Error后会话会自动终止，此时就需要程序重新开启会话
    NSLog(@"错误回调 : %@", error);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (myBlock) {
                myBlock(nil);
            }
        }];
    });
    
   
}

- (void)readerSessionDidBecomeActive:(NFCNDEFReaderSession *)session{
    NSLog(@"readerSessionDidBecomeActive");
}

@end
