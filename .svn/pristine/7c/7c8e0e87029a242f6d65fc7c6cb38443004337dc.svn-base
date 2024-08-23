//
//  WriteNFCViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/14.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreNFC/CoreNFC.h>

NS_ASSUME_NONNULL_BEGIN

@interface WriteNFCViewController : BaseViewController
{
    NormalBlock myBlock;
}
@property(strong, nonatomic)NFCNDEFReaderSession *session;
@property(strong, nonatomic)id<NFCNDEFTag>currentTag;



- (id)initWithString:(NSString *)str;
- (id)initWithString:(NSString *)str andBack:(NormalBlock)block;

@end

NS_ASSUME_NONNULL_END
