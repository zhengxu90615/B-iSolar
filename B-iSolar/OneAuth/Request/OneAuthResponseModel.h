//
//  BResponseModel.h
//  B-iWeather
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneAuthResponseModel : NSObject

@property(nonatomic,readwrite) BOOL success;
@property(nonatomic,strong) NSString* flag;
@property(nonatomic,strong) NSString* errorMessage;
@property(nonatomic,strong) NSString* message;
@property(nonatomic,strong) id data;
@property(nonatomic,readwrite) NSInteger pageindex;
@property(nonatomic,readwrite) NSInteger pagenum;



@end

NS_ASSUME_NONNULL_END
