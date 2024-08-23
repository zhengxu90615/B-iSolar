//
//  Util.h
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/6.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject
{
    
}

+ (NSString*)encodeToken:(NSString*)token andSk:(NSString *)sk;
+ (NSString*)decodeToken:(NSString*)token andSk:(NSString *)sk;


+(NSString *)HmacSha1:(NSString *)key content:(NSString *)data;
+(NSString *)HmacSha256:(NSString *)secret content:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
