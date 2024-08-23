//
//  BAPIHelper.h
//  B-iWeather
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "IOAApiManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface OneAuthAPIHelper : IOAApiHelper
{
    
}
+ (void)saveUserInfo:(nullable NSDictionary *)dic;
+ (NSDictionary*)getUserInfo;
@end

NS_ASSUME_NONNULL_END
