//
//  APAnalytics.h
//  AskingPoint
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <AskingPoint/APContext.h>

extern NSString * const APAnalyticsMaxFileSizeKey;
extern NSString * const APAnalyticsMaxPendingFilesKey;
extern NSString * const APAnalyticsMaxSendFrequencyKey;
extern NSString * const APAnalyticsServerKey;
extern NSString * const APAnalyticsOptOut;

extern NSString * const APUserGender;   // @"M" or @"F"
extern NSString * const APUserAge;
extern NSString * const APUserLocation; // CLLocation

typedef enum APEventType {
    APEventStartup      = 1,
    APEventShutdown     = 2,
    APEventEnvironment  = 3,
    APEventCustom       = 4,
    APEventUserData     = 7, // User info: age, gender, location
    APEventCommand      = 8, // Events triggered by user actions on a command (eg. webview)
    APEventCustomStart  = 9,
    APEventCustomStop   = 10
} APEventType;

@interface APEvent : NSObject
@property(nonatomic,readonly) APEventType type;
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSDictionary *data;

+(id)eventWithName:(NSString*)name;
+(id)eventWithName:(NSString *)name andData:(NSDictionary*)data;

// Dictionary with APUser* fields
+(id)eventWithUserData:(NSDictionary*)userData;

@end

@interface APEvent (APRatingsBooster)

@property(nonatomic,readonly) NSString *ratingResponse;

@end

// Timed event start event. Call stopEvent to create a matching stop event.
@interface APTimedStartEvent : APEvent
@property(nonatomic,readonly) NSString *timedEventId;

-(APEvent*)stopEvent;
-(APEvent*)stopEventWithData:(NSDictionary*)data;

@end

@protocol APEventStore <NSObject>
@property(nonatomic,copy) NSString *server;
- (void)addEvent:(APEvent *)event withDate:(NSDate*)date;
- (void)sendIfNeeded;
@end

@protocol APAnalyticsDelegate <NSObject>
@optional
- (void)analytics:(APAnalytics*)analytics willSendEvent:(APEvent*)event;
@end

@interface APAnalytics : NSObject

@property(nonatomic) BOOL optedOut;
@property(nonatomic,assign) id<APAnalyticsDelegate> delegate;

-(void)addEvent:(APEvent *)event;
-(void)sendIfNeeded;

@end
