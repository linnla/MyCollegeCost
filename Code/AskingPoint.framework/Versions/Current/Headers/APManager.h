//
//  APManager.h
//  AskingPointLib
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AskingPoint/APCommandManager.h>
#import <AskingPoint/APAnalytics.h>

@class CLLocation;

void APManagerDefaultRatingPrompt(NSDictionary *ratingPrompt);
typedef void (^APManagerRatingPromptHandler)(NSDictionary *ratingPrompt);
typedef void (^APManagerRatingPromptResponse)(NSString *response);

void APManagerDefaultSurveyPrompt(NSDictionary *surveyPrompt);
typedef void (^APManagerSurveyPromptHandler)(NSDictionary *surveyPrompt);

@interface APManager : NSObject <APCommandManagerWebDelegate, APCommandManagerAlertDelegate, APAnalyticsDelegate>

// System root view controller
// defaults to [[[UIApplication sharedApplication] keyWindow] rootViewController] if available
@property(nonatomic,retain) UIViewController *rootViewController;
@property(nonatomic,copy) APManagerRatingPromptHandler ratingPromptHandler;
@property(nonatomic,copy) APManagerRatingPromptResponse ratingPromptResponse;
@property(nonatomic,copy) APManagerSurveyPromptHandler surveyPromptHandler;

+(APManager *)sharedManager;
+(void)startup:(NSString *)apiKey;
+(void)setLocalizedAppName:(NSString*)localizedAppName;
+(NSString*)localizedAppName;

+(void)setAppVersion:(NSString*)appVersion;

+(void)addEventWithName:(NSString *)name;
+(void)addEventWithName:(NSString *)name andData:(NSDictionary *)data;

+(void)startTimedEventWithName:(NSString *)name;
+(void)startTimedEventWithName:(NSString *)name andData:(NSDictionary *)data;
+(void)stopTimedEventWithName:(NSString *)name;
+(void)stopTimedEventWithName:(NSString *)name andData:(NSDictionary *)data;

+(void)setGender:(NSString *)gender;     // M or F
+(void)setAge:(int)age;
+(void)setLocation:(CLLocation *)location;

+(void)sendIfNeeded;
+(void)popNextQueuedCommand;

+(void)setOptedOut:(BOOL)optedOut;
+(BOOL)optedOut;

+(void)setRootViewController:(UIViewController*)rootViewController;

@end
