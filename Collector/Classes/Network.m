//
//  Network.m
//  Pods
//
//  Created by LBH on 2016/9/10.
//
//

#import "Network.h"
#import <netinet/in.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>

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
@property (assign, nonatomic) SCNetworkReachabilityRef reachabilityRef;

@end

@implementation Network

+ (NSString *)type{
    Network *status = [[Network alloc]init];
    if ([status _isReachable])
    {
        if ([status isReachableViaWiFi])
        {
            return @"WiFi";
        }
        else
        {
            switch ([status currentWWANtype]) {
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
    }
    else
    {
        return @"Not networking";
    }
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        _reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &address);
        
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

- (BOOL)_isReachable
{
    SCNetworkReachabilityFlags flags;
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        return NO;
    }
    else
    {
        return [self isReachableWithFlags:flags];
    }
}

#pragma WWAN type

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

#pragma Network type

-(BOOL)isReachableViaWiFi
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        if((flags & kSCNetworkReachabilityFlagsReachable))
        {
            if((flags & kSCNetworkReachabilityFlagsIsWWAN))
            {
                return NO;
            }
            
            return YES;
        }
    }
    
    return NO;
}


- (BOOL)isReachableViaWWAN
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        if(flags & kSCNetworkReachabilityFlagsReachable)
        {
            if(flags & kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // if target host is not reachable
        return NO;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that you're on Wi-Fi
        return YES;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            return YES;
        }
    }
    
    return NO;
}
@end
