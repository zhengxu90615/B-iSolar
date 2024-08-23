//
//  BAPIHelper.m
//  B-iWeather
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "OneAuthAPIHelper.h"

@implementation OneAuthAPIHelper


+ (NSMutableDictionary*)removeNullValue:(NSDictionary *)dic{
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    for (NSString *key in newDic.allKeys) {
        if (newDic[key] == NULL || [newDic[key] isKindOfClass:[NSNull class]]) {
            newDic[key] = @"";
        }else if ([newDic[key] isKindOfClass:[NSDictionary class]]){
            newDic[key] = [OneAuthAPIHelper removeNullValue:newDic[key]];
        }
    }
    return newDic;
}

+ (void)saveUserInfo:(nullable NSDictionary  *)dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (dic == NULL) {
        [BAPIHelper saveToken:@""];
        [defaults removeObjectForKey:@"userInfo"];
        [defaults synchronize];
        return;
    }
    NSMutableDictionary *newDic = [OneAuthAPIHelper removeNullValue:dic];
    
    [BAPIHelper saveToken:newDic[@"token"]];
    [defaults setObject:newDic forKey:@"userInfo"];
    [defaults synchronize];
}
+ (NSDictionary*)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [defaults objectForKey:@"userInfo"];
    //    IOADLog(@"token is %@", token);
    
    if (info) {
        return info;
    }
    else {
        return nil;
    }
}
@end
