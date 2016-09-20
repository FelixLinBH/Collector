//
//  UserInfo.m
//  Pods
//
//  Created by LBH on 2016/9/20.
//
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSString *)localTimeZoneName{
    return [[NSTimeZone localTimeZone]name];
}

+ (NSString *)getCurrentLocalTime{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"Y-M-d hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return [dateFormatter stringFromDate:now];
}
@end
