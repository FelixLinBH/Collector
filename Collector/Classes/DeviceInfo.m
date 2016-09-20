//
//  DeviceInfo.m
//  Pods
//
//  Created by LBH on 2016/9/17.
//
//

#import "DeviceInfo.h"

@implementation DeviceInfo

+ (NSDictionary *)info{
    NSDictionary *info = [[NSDictionary alloc]initWithObjects:@[[[UIDevice currentDevice]model],[[UIDevice currentDevice]localizedModel],[[UIDevice currentDevice]systemName],[[UIDevice currentDevice]systemVersion]] forKeys:@[@"Model",@"LocalModel",@"SystemName",@"SystemVersion"]];
    return info;
}

@end
