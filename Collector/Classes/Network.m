//
//  Network.m
//  Pods
//
//  Created by LBH on 2016/9/10.
//
//

#import "Network.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

typedef NS_ENUM(NSInteger, WWANAccessType) {
    WWANTypeUnknown = -1, /// maybe iOS6
    WWANType4G = 0,
    WWANType3G = 1,
    WWANType2G = 3
};

@interface Network()

@property (nonatomic,strong) NSArray *typeStrings4G;
@property (nonatomic,strong) NSArray *typeStrings3G;
@property (nonatomic,strong) NSArray *typeStrings2G;

@end

@implementation Network

+ (NSString *)type{
    WWANAccessType type = [[[Network alloc]init]currentWWANtype];
    switch (type) {
        case WWANTypeUnknown:
            return @"Unkonw";
            break;
        case WWANType4G:
            return @"4G";
            break;
        case WWANType3G:
            return @"3G";
            break;
        case WWANType2G:
            return @"2G";
            break;
    }

}

- (instancetype)init{
    self = [super init];
    if (self) {
        _typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        _typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        _typeStrings4G = @[CTRadioAccessTechnologyLTE];

    }
    return self;
}

- (WWANAccessType)currentWWANtype
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([accessString length] > 0)
        {
            return [self accessTypeForString:accessString];
        }
        else
        {
            return WWANTypeUnknown;
        }
    }
    else
    {
        return WWANTypeUnknown;
    }
}
- (WWANAccessType)accessTypeForString:(NSString *)accessString
{
    if ([self.typeStrings4G containsObject:accessString])
    {
        return WWANType4G;
    }
    else if ([self.typeStrings3G containsObject:accessString])
    {
        return WWANType3G;
    }
    else if ([self.typeStrings2G containsObject:accessString])
    {
        return WWANType2G;
    }
    else
    {
        return WWANTypeUnknown;
    }
}


@end
