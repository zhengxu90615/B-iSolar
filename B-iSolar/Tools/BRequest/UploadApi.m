//
//  UploadApi.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "UploadApi.h"

@implementation UploadApi
- (void)setUrl:(NSString*)url andBaseUrl:(NSString*)bUrl
{
    baseUrl = bUrl;
    reqUrl = url;
}
#pragma mark- 头部参数
- (NSDictionary *)requestHeaderFieldValueDictionary {
    NSString *token = [IOAApiHelper getToken];
    if (token.length == 0) {
        return @{@"platform":PLARFORM_IOS};
    }
    token = [NSString stringWithFormat:@"%@",token];
    return @{@"platform":PLARFORM_IOS,
             @"token": token};
}

- (NSString *)baseUrl {
    return baseUrl;
}
- (NSString *)requestUrl {

    return reqUrl;
}

@end
