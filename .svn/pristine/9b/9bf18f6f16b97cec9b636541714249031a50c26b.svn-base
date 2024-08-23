//
//  OneAuthUtil.m
//  B-iWeather
//
//  Created by Mark.zheng on 2020/11/10.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "OneAuthUtil.h"

@implementation OneAuthUtil
+(BOOL)isPhone:(NSString *)mobile{
    
    
    if (mobile.length != 11) {

        return false;

       } else {

           /**

            * 移动号段正则表达式

            */
        
           NSString *CM_NUM = @"^1[3456789]\\d{9}$";

           /**

            * 联通号段正则表达式

            */

           NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[0-9])|(18[5,6]))\\d{8}$";

           /**

            * 电信号段正则表达式

            */

           NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];

           BOOL isMatch1 = [pred1 evaluateWithObject:mobile];

           NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];

           BOOL isMatch2 = [pred2 evaluateWithObject:mobile];

           NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
           BOOL isMatch3 = [pred3 evaluateWithObject:mobile];

           if (isMatch1 || isMatch2 || isMatch3) {
               return TRUE;
           } else {
               return false;
           }
       }
    return false;
}
@end
