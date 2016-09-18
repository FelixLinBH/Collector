//
//  Collector.m
//  Pods
//
//  Created by LBH on 2016/9/5.
//
//

#import "Collector.h"

@implementation Collector

+ (Collector *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];

    });
    
    return sharedInstance;
}



@end
