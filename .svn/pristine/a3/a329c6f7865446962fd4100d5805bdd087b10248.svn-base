//
//  BHttpRequest.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BHttpRequest.h"
#import "UploadApi.h"
@implementation BHttpRequest


- (instancetype)instance{
    BHttpRequest * apiBlock = [BHttpRequest new];
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
    NSString *token = [IOAApiHelper getToken];
    if (token.length == 0) {
        return @{@"platform":PLARFORM_IOS};
    }
    token = [NSString stringWithFormat:@"%@",token];
    return @{@"platform":PLARFORM_IOS,
             @"token": token};
}

- (void)startRequest:(id)model
                 uri:(NSString *)uri
              result:(IOAResponseResultResponseBlock)resultBlock{
    if (![uri hasPrefix:@"http"]) {
        uri = API_URL(uri);
    }
    [self startInBlockWithType:YTKRequestMethodPOST model:model uri:uri respEntityName:@"BResponseModel" result:^(IOAResponse *resp) {
        BResponseModel *respModel = (BResponseModel*)resp.responseObject;
        if (!respModel.success && [respModel.flag isEqualToString:API_NOT_LOGIN_FLAG]) {
            //remove token
            [BAPIHelper saveUserInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_LOGIN object:nil];
        }
        if (!respModel) {
           respModel = [[BResponseModel alloc] init];
           respModel.success = false;
           respModel.errorMessage = self.error.localizedDescription;
       }
        resultBlock(respModel);
    }];
}
+ (id)new{
    return [[BHttpRequest alloc] initWithModel:nil respEntityName:nil];
}
- (void)startUploadImage:(UIImage *)image
                   withP:(NSDictionary*)dic
                     uri:(NSString *)uri
                  result:(IOAResponseResultResponseBlock)resultBlock
{
//    uri = API_URL(uri);

    
    //资源上传
    UploadApi * uploadApi = [[UploadApi alloc] initWithModel:dic respEntityName:@"BResponseModel"];
    [uploadApi setUrl:uri andBaseUrl:API_HOST];

    [uploadApi uploadImageDic:@{@"img_file":image}];
    
    [uploadApi startWithBlockWithResult:^(IOAResponse *resp) {

        BResponseModel *respModel = (BResponseModel*)resp.responseObject;
        if (!respModel.success && [respModel.flag isEqualToString:API_NOT_LOGIN_FLAG]) {
            //remove token
            [BAPIHelper saveUserInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_LOGIN object:nil];
        }
        resultBlock(respModel);
        
    }];
}


- (void)startUploadImage2:(UIImage *)image
                   withP:(NSDictionary*)dic
                     uri:(NSString *)uri
                  result:(IOAResponseResultResponseBlock)resultBlock
{
//    uri = API_URL(uri);

    
    //资源上传
    UploadApi * uploadApi = [[UploadApi alloc] initWithModel:dic respEntityName:@"BResponseModel"];
    [uploadApi setUrl:uri andBaseUrl:API_HOST];

    [uploadApi uploadImageDic:@{@"upload_file":image}];
    uploadApi.needShowHud = @0;
    [uploadApi startWithBlockWithResult:^(IOAResponse *resp) {

        BResponseModel *respModel = (BResponseModel*)resp.responseObject;
        if (!respModel.success && [respModel.flag isEqualToString:API_NOT_LOGIN_FLAG]) {
            //remove token
            [BAPIHelper saveUserInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOT_LOGIN object:nil];
        }
        resultBlock(respModel);
        
    }];
}


@end
