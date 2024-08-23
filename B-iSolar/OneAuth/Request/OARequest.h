//
//  OARequest.h
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/9.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "IOAApiManager.h"
#define PLATFORM @"iOS"
#define API_VERSION @"1.0.0"

//#define AK @"sadfawhadefy5re#$fg@dfa"
//#define SK @"wyeuinjksdyu9fo*#dsfs"
//#define OneAuthURL @"http://10.197.190.61/auth/main_func"

#define AK @"b756bc29888a3bf"
#define SK @"e9708259bbc03762a2ea516d6239"
#define OneAuthURL @"http://ucenter.bseos.com/auth/main_func"
//#define TENANT_ID @"1"
#define TENANT_ID [AppDelegate tenantid]



NS_ASSUME_NONNULL_BEGIN

@class OneAuthResponseModel
;typedef void(^IOAResponseResultResponseBlock2)(OneAuthResponseModel * resp);

@interface OARequest : IOARequest{
    NSString * apiName;
    
}

- (void)startRequest:(nullable id)model apiName:(NSString *)name result:(IOAResponseResultResponseBlock2)resultBlock;




@end

NS_ASSUME_NONNULL_END
