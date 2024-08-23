//
//  BHttpRequest.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "IOAApiManager.h"
@class BResponseModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^IOAResponseResultResponseBlock)(BResponseModel * resp);

@interface BHttpRequest : IOARequest
@property (nonatomic, readwrite, copy) NSString *serverResponseMessage;
@property (nonatomic, readwrite, assign) NSInteger serverResponseStatusCode;

+ (id)new;
- (void)startRequest:(nullable id)model uri:(NSString *)uri result:(IOAResponseResultResponseBlock)resultBlock;
- (void)startUploadImage:(UIImage *)image
withP:(NSDictionary*)dic

                     uri:(NSString *)uri
                  result:(IOAResponseResultResponseBlock)resultBlock;

- (void)startUploadImage2:(UIImage *)image
                   withP:(NSDictionary*)dic
                     uri:(NSString *)uri
                   result:(IOAResponseResultResponseBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
