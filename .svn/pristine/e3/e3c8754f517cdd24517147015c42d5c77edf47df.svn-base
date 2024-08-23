//
//  OARequest.m
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/9.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "OARequest.h"
#import "Util.h"
#import "GTMBase64.h"
#import "OneAuthAPIHelper.h"
#import "OneAuthResponseModel.h"
@implementation OARequest

- (instancetype)instance{
    OARequest * apiBlock = [[OARequest alloc] initWithDictionary:nil respEntityName:nil];
    apiBlock.needShowHud =@1;
    apiBlock.needAuthor = @1;
    return apiBlock;
}

- (NSTimeInterval)requestTimeoutInterval {
    return REQUESTTIMEOUT;
}
- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}

#pragma mark- 头部参数
- (NSDictionary *)requestHeaderFieldValueDictionary {
  
    NSMutableDictionary * head = [[NSMutableDictionary alloc] initWithDictionary:@{@"platform":PLATFORM,
                                                                                   @"apiName": apiName,
                                                                                   @"apiAccessKey":AK,
                                                                                   @"apiTimestamp":[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],
                                                                                   @"apiVersion":API_VERSION
    }];
    
    NSMutableDictionary * tmpDic = [[NSMutableDictionary alloc] initWithDictionary:head];
    [tmpDic addEntriesFromDictionary:self.requestModel];
    [tmpDic removeObjectForKey:@"platform"];
    
    NSArray *keyArray = [tmpDic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare: obj2 options:NSNumericSearch];
    }];          //对key进行遍历排序
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    for (NSString *sortString in sortArray) {
           [valueArray addObject:[tmpDic objectForKey: sortString]];
    }     //对排序后的key取value
    
    NSMutableArray *signArray = [NSMutableArray array];

    for (int i =0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject: keyValueStr];
    }    //输出新的数组   key=value
    NSString *sign = [signArray componentsJoinedByString:@"&"];

    NSLog(@"sign==%@",sign);
    
    NSString *sha1 = [Util HmacSha1:SK content:sign];

    [head setObject:sha1 forKey:@"apiSignature"];
    return head;
}





- (void)startRequest:(id)model
            apiName:(NSString *)name
              result:(IOAResponseResultResponseBlock2)resultBlock{
    apiName = name;
    [self startInBlockWithType:YTKRequestMethodPOST model:model uri:OneAuthURL respEntityName:@"OneAuthResponseModel" result:^(IOAResponse *resp) {
        OneAuthResponseModel *respModel = (OneAuthResponseModel*)resp.responseObject;
        if (!respModel.success && [respModel.flag isEqualToString:API_NOT_LOGIN_FLAG]) {
            //remove token
            [OneAuthAPIHelper saveUserInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_LOGIN object:nil];
        }
        resultBlock(respModel);
    }];
}



@end
