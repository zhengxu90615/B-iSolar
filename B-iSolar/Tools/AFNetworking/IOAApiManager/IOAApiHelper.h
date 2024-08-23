//
//  IOAApiHelper.h
//  IOAMall
//
//  Created by Mac on 2018/1/31.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "YTKNetwork.h"
#import "AFNetworking.h"


@interface IOAApiHelper : NSObject
//base in YTKNetwork

+ (void)configNetworkWithBaseUrl:(NSString *)baseUrl;
/**
 network ip setting
 */
//+ (void)configNetwork;

/**
 https setting
 */
//+ (void)configHttps;
/**
 common pragma
 */
+ (NSMutableDictionary *)getCommomParametersWith:(NSString *)service token:(NSString *)token;
/**
 api version control
 */
+ (NSMutableDictionary *)getParametersWithService:(NSString *)service;


/**
 net Monitoring
 */
+ (void)startNetworkMonitoring:(void(^)(void))completeBlock;
+ (void)stopNetworkMonitoring;
+ (BOOL)isNetworkReachable;
+ (AFNetworkReachabilityStatus)getNetworkStatus;


/**
 token control ，
 when have token control ，
 save token and use in request
 */
+ (void)saveToken:(NSString *)token;
+ (NSString *)getToken;
@end
