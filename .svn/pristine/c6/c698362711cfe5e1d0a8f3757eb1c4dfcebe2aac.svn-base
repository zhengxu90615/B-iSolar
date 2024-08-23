//
//  NSDate+Formatting.m
//  Messaging
//
//  Created by shijing on 14-5-13.
//  Copyright (c) 2014年 Jing Shi. All rights reserved.
//

#import "NSDate+Formatting.h"

@implementation NSDate (Formatting)

+ (NSInteger)day
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay)
                                               fromDate:[NSDate date]];
    return [components day];
}
+ (NSInteger)month
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay)
                                               fromDate:[NSDate date]];
    return [components month];
}

+ (NSInteger)year
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay)
                                               fromDate:[NSDate date]];
    return [components year];
}


- (BOOL)isSameDay:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay)
                                               fromDate:self];
    NSDateComponents* otherComponents = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay)
                                                    fromDate:date];
    return ([components year] == [otherComponents year]) && ([components month] == [otherComponents month]) && ([components day] == [otherComponents day]);
}




- (NSString*)getReadableStringMessageDetail
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:[NSDate date]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate* today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];
    
    NSDate* tomorrow = [NSDate dateWithTimeInterval:86400
                                          sinceDate:today];
    
    NSDate* future = [NSDate dateWithTimeInterval:172800
                                        sinceDate:today];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate* yesterday = [cal dateByAddingComponents:components
                                             toDate:today
                                            options:0];
    
    NSDate* Thedaybeforeyesterday = [cal dateByAddingComponents:components
                                                         toDate:yesterday
                                                        options:0];
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                        fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate* thisWeek = [cal dateFromComponents:components];
    
    [components setDay:1];
    [components setMonth:1];
    NSDate* thisYear = [cal dateFromComponents:components];
    
    if ([self compare:future] == NSOrderedDescending) {
        return NSLocalizedString(@"Future", @"Future");
    } else if ([self compare:tomorrow] == NSOrderedDescending) {
        return NSLocalizedString(@"Tomorrow", @"Tomorrow");
    } else if ([self compare:today] == NSOrderedDescending) {
        return NSLocalizedString(@"Today", @"Today");
    } else if ([self compare:yesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"Yesterday", @"Yesterday");
    } else if ([self compare:Thedaybeforeyesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"Thedaybeforeyesterday", @"Thedaybeforeyesterday");
    } else if ([self compare:thisWeek] == NSOrderedDescending) {
        return [self getWeekString];
    } else if ([self compare:thisYear] == NSOrderedDescending) {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M月d日"];
        NSString* str = [formatter stringFromDate:self];
        return str;
        
    } else {
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yy年M月d日"];
        return [dateformatter stringFromDate:self];
    }
}




- (NSString*)getReadableString
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:[NSDate date]];

    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate* today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];

    NSDate* tomorrow = [NSDate dateWithTimeInterval:86400
                                          sinceDate:today];
    
    NSDate* future = [NSDate dateWithTimeInterval:172800
                                          sinceDate:today];

    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate* yesterday = [cal dateByAddingComponents:components
                                             toDate:today
                                            options:0];

    NSDate* Thedaybeforeyesterday = [cal dateByAddingComponents:components
                                             toDate:yesterday
                                            options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                        fromDate:[[NSDate alloc] init]];

    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate* thisWeek = [cal dateFromComponents:components];

    [components setDay:1];
    [components setMonth:1];
    NSDate* thisYear = [cal dateFromComponents:components];

    if ([self compare:future] == NSOrderedDescending) {
        return NSLocalizedString(@"Future", @"Future");
    } else if ([self compare:tomorrow] == NSOrderedDescending) {
        return NSLocalizedString(@"Tomorrow", @"Tomorrow");
    } else if ([self compare:today] == NSOrderedDescending) {
        return [self stAgo];
    } else if ([self compare:yesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"Yesterday", @"Yesterday");
    } else if ([self compare:Thedaybeforeyesterday] == NSOrderedDescending) {
        return NSLocalizedString(@"Thedaybeforeyesterday", @"Thedaybeforeyesterday");
    }
    else if ([self compare:thisWeek] == NSOrderedDescending) {
        return [self getWeekString];
    } else if ([self compare:thisYear] == NSOrderedDescending) {
        return [self getInYearString];
    } else {
        return [self dateString];
    }
}


- (NSString*)dateDisPlay:(NSTimeInterval)inServerTime
{
    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"MM-dd HH:mm"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSString* displayTime = nil;
    NSDate *date = [NSDate date];
    NSTimeInterval intervalSince1970 = [date timeIntervalSince1970];
    
    if (inServerTime >intervalSince1970) {
        
        displayTime = [NSString stringWithFormat:@"0分钟前"];
        
    }else
    {
        NSTimeInterval intervalSinceServerTime = intervalSince1970 - inServerTime;
        
        if (intervalSinceServerTime <3600) {//差值小于1H
            
            displayTime = [NSString stringWithFormat:@"%d%@",(int) intervalSinceServerTime/60,NSLocalizedString(@"分钟前", @"")];
        }else
        {
            NSDate *dateServer = [NSDate dateWithTimeIntervalSince1970:inServerTime];
            
            if (intervalSinceServerTime<24*3600)
            {
 
                int hour =  intervalSinceServerTime/3600;
                displayTime = [timeFormat stringFromDate:dateServer];
                displayTime = [NSString stringWithFormat:@"%d小时前",hour];
            }else
            {
                int day =  intervalSinceServerTime/(3600*24);
                
                displayTime = [NSString stringWithFormat:@"%d天前",day];
            }
        }
    }
    if ([displayTime isEqualToString:@"0分钟前"]) {
        displayTime = @"刚刚";
    }
    return displayTime;
}


- (NSString*)getWeekString
{
    NSArray* weaks = @[
        NSLocalizedString(@"Sunday", @"Sunday"),
        NSLocalizedString(@"Monday", @"Monday"),
        NSLocalizedString(@"Tuesday", @"Tuesday"),
        NSLocalizedString(@"Wednesday", @"Wednesday"),
        NSLocalizedString(@"Thursday", @"Thursday"),
        NSLocalizedString(@"Friday", @"Friday"),
        NSLocalizedString(@"Saturday", @"Saturday")
    ];

    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnit)kCFCalendarUnitWeekday
                                               fromDate:self];
    return weaks[[components weekday] - 1];
}

- (NSString*)getInYearString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d"];
    NSString* str = [formatter stringFromDate:self];
    return str;
}

- (NSString*)dateString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yy-M-d"];
    return [dateformatter stringFromDate:self];
}
- (NSString*)dateyyyyMMddString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    return [dateformatter stringFromDate:self];
}
- (NSString*)dateyyyyMMString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    return [dateformatter stringFromDate:self];
}
- (NSString*)dateDDString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"d"];
    return [dateformatter stringFromDate:self];
}
- (NSString*)dateDotedString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy.MM.dd"];
    return [dateformatter stringFromDate:self];
}

- (NSString*)dLastModifyTime
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yy-M-d HH:mm:ss"];
    return [dateformatter stringFromDate:self];
}

- (NSString*)timeString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    return [dateformatter stringFromDate:self];
}

- (NSString*)AmPmtimeString
{
  
    
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"aaa h:mm"];
    
    [dateformatter setAMSymbol:@"上午"];
    [dateformatter setPMSymbol:@"下午"];
    
    NSString *TimeStrin = [dateformatter stringFromDate:self];
    NSString *hh = [TimeStrin substringToIndex:2];
    if ([hh isEqualToString:@"上午"] || [hh isEqualToString:@"下午"]) {
        return TimeStrin;
    }else
    {
        int hhInt = [hh intValue];
        if (hhInt <= 12 )
        {
            if ([[TimeStrin substringToIndex:1] isEqualToString:@"0"]) {
                
                return  [@"上午 " stringByAppendingString:[TimeStrin substringFromIndex:1]];
            }
            return [@"上午 " stringByAppendingString:TimeStrin];
        }else
        {
            hhInt = hhInt-12;
            
            return [NSString stringWithFormat:@"下午 %d:%@",hhInt,[TimeStrin substringFromIndex: TimeStrin.length-2]];
        }
    }
    
    return [dateformatter stringFromDate:self];
}

- (NSString*)stAgo
{
    return [self timeString];
    return [self dateDisPlay:[self timeIntervalSince1970]];
}













- (NSString*)getReadableStringOfList
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:[NSDate date]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate* today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];
    
    NSDate* tomorrow = [NSDate dateWithTimeInterval:86400
                                          sinceDate:today];
    
    NSDate* future = [NSDate dateWithTimeInterval:172800
                                        sinceDate:today];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate* yesterday = [cal dateByAddingComponents:components
                                             toDate:today
                                            options:0];
    
    NSDate* Thedaybeforeyesterday = [cal dateByAddingComponents:components
                                                         toDate:yesterday
                                                        options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                        fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate* thisWeek = [cal dateFromComponents:components];
    
    [components setDay:1];
    [components setMonth:1];
    NSDate* thisYear = [cal dateFromComponents:components];
    
    if ([self compare:future] == NSOrderedDescending) {
        return NSLocalizedString(@"Future", @"Future");
    } else if ([self compare:tomorrow] == NSOrderedDescending) {
        return NSLocalizedString(@"Tomorrow", @"Tomorrow");
    }
    
    else if ([self compare:today] == NSOrderedDescending) {
        return [self AmPmtimeString];
    }
    else if ([self compare:yesterday] == NSOrderedDescending) {
        return [NSLocalizedString(@"Yesterday", @"Yesterday") stringByAppendingString:[self AmPmtimeString]];
    }
    else if ([self compare:Thedaybeforeyesterday] == NSOrderedDescending) {
        return [NSLocalizedString(@"Thedaybeforeyesterday", @"Thedaybeforeyesterday") stringByAppendingString:[self AmPmtimeString]];
    }
    else if ([self compare:thisWeek] == NSOrderedDescending) {
        return [self getWeekString];
    }
    else if ([self compare:thisYear] == NSOrderedDescending) {
        return [self getInYearString];
    }
    else {
        return [self dateString];
    }
}

+ (NSDate*)dateWithPortableString:(NSString*)string
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

- (NSString*)portableString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:self];
}
- (NSString*)dateyyyyMMddHHMMString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateformatter stringFromDate:self];
}

- (NSString *)watchAppTimeString
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:[NSDate date]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate* today = [cal dateByAddingComponents:components
                                         toDate:[[NSDate alloc] init]
                                        options:0];
    
    NSDate* tomorrow = [NSDate dateWithTimeInterval:86400
                                          sinceDate:today];
    
    NSDate* future = [NSDate dateWithTimeInterval:172800
                                        sinceDate:today];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate* yesterday = [cal dateByAddingComponents:components
                                             toDate:today
                                            options:0];
    
    NSDate* Thedaybeforeyesterday = [cal dateByAddingComponents:components
                                                         toDate:yesterday
                                                        options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                        fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate* thisWeek = [cal dateFromComponents:components];
    
    [components setDay:1];
    [components setMonth:1];
    NSDate* thisYear = [cal dateFromComponents:components];
    
    if ([self compare:future] == NSOrderedDescending) {
        return NSLocalizedString(@"Future", @"Future");
    } else if ([self compare:tomorrow] == NSOrderedDescending) {
        return NSLocalizedString(@"Tomorrow", @"Tomorrow");
    }
    
    else if ([self compare:today] == NSOrderedDescending) {
       
        return [self HHMM];
    }
    else if ([self compare:yesterday] == NSOrderedDescending) {
        return [NSLocalizedString(@"Yesterday", @"Yesterday") stringByAppendingString:[self HHMM]];
    }
    else if ([self compare:Thedaybeforeyesterday] == NSOrderedDescending) {
        return [NSLocalizedString(@"Thedaybeforeyesterday", @"Thedaybeforeyesterday") stringByAppendingString:[self HHMM]];
    }
    else if ([self compare:thisWeek] == NSOrderedDescending) {
        return [self getWeekString];
    }
    else if ([self compare:thisYear] == NSOrderedDescending) {
        return [self getInYearString];
    }
    else {
        return [self dateString];
    }
}
- (NSString *)HHMM
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    
    return [dateformatter stringFromDate:self];
}

@end
