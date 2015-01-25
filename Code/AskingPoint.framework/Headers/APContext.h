//
//  APContext.h
//  AskingPoint
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#define AP_VERSION @"1.5.0"
extern NSString * const APVersion;

@interface APContext : NSObject

@property(nonatomic,copy) NSString *localizedAppName;
@property(nonatomic,copy) NSString *appVersion;

+(void)startup:(NSString *)appKey;
+(APContext *)sharedContext;

@end

@class APAnalytics;
@interface APContext (APAnalytics)
+(APAnalytics *)sharedAnalytics;
@end

@class APCommandManager;
@interface APContext (APCommandManager)
+(APCommandManager *)sharedCommandManager;
@end