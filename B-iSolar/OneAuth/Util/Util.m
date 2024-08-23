//
//  Util.m
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/6.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#include "base64.h"

@implementation Util


+(NSString *)HmacSha1:(NSString *)secret content:(NSString *)text{
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    
    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    return base64EncodedResult;
}

+(NSString *)HmacSha256:(NSString *)secret content:(NSString *)content{
   const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
   const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];// 有可能有中文 所以用NSUTF8StringEncoding -> NSASCIIStringEncoding
   unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
   CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
   NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
   const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
   NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
   for (int i = 0; i < HMACData.length; ++i){
       [HMAC appendFormat:@"%02x", buffer[i]];
   }
   
   return HMAC;
}



//加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
      
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //return [GTMBase64 stringByEncodingData:resultData];
        return [self hexStringFromData:resultData];
  
    }
    free(buffer);
    return nil;
}
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      
    //NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
      
    NSData *data=[self dataForHexString:encryptText];
      
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
      
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
//        numBytesCrypted -=16;
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    }
    free(buffer);
    return nil;
}
// 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
          
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
          
        hexStr = [hexStr stringByAppendingString:newHexStr];
          
    }
    return hexStr;
}
//十六进制转Data
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            byte = *ch - 'A' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }else if('A' <= *ch && *ch <= 'F'){
                byte += *ch - 'A' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

+(NSString *)addTo16:(NSString *)sourceStr{
    int add = 0;
    if ([sourceStr length] % 16) {
        add = 16 - ([sourceStr length]  % 16);
    }
    for (int i=0; i<add; i++) {
        sourceStr = [sourceStr  stringByAppendingString: @"\0"];
    }
    return sourceStr;
}


+ (NSString*)decodeToken:(NSString*)token andSk:(NSString *)sk{
//    BSEOS098c9da3e4fb3c9292a4ae572fcea6f9
//    ZDYzYWNhYWMtYTIy
//    57a0ceb950e6b4fc17b68a1010266fa3b0c2fe984530216141e2cbe4e50933a54e23cf952d8a11c339282e400d6f73b2
    sk = @"ZDYzYWNhYWMtYTIy";
    token = @"57a0ceb950e6b4fc17b68a1010266fa3b0c2fe984530216141e2cbe4e50933a54e23cf952d8a11c339282e400d6f73b2";
//    encrypt('12345678901234567890','1234567812345678')
//    '7474a49e4498b249d8f62ef4cf5541a99be72b7c53fc8b88e4d865f2919d74db'
    
    if (sk.length > 16) {
       sk = [sk substringToIndex:16];
   }
    NSString * realToken = [Util AES128Decrypt:token key:sk];
    NSLog(@"%@",realToken);
    return @"";
}







@end
