//
//  APCommandType.h
//  AskingPointLib
//
//  Created by AskingPoint on 3/27/12.
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <AskingPoint/APContext.h>

extern NSString * const APCommandManagerServerKey;
extern NSString * const APCommandManagerMaxRequestFrequencyKey;

extern NSString * const APCommandTypeKey;
extern NSString * const APCommandQueuedKey;
extern NSString * const APCommandTimerIntervalKey;

extern NSString * const APCommandURLKey;

extern NSString * const APCommandIdKey;
extern NSString * const APCommandTitleKey;
extern NSString * const APCommandMessageKey;
extern NSString * const APCommandButtonsKey;
extern NSString * const APCommandCancelKey;
extern NSString * const APCommandOpenURLKey;

extern NSString * const APCommandRateId;

typedef enum APCommandType {
    APCommandTypeWeb     = 1,
    APCommandTypeAlert   = 2
} APCommandType;

@protocol APCommandManagerWebDelegate <NSObject>
@required
- (void)commandManager:(APCommandManager*)commandManager webCommand:(NSDictionary*)command;
@end

@protocol APCommandManagerAlertDelegate
@required
- (void)commandManager:(APCommandManager*)commandManager alertCommand:(NSDictionary*)command;
@end

@interface APCommandManager : NSObject

@property(nonatomic,assign) id<APCommandManagerWebDelegate> webCommandDelegate;
@property(nonatomic,assign) id<APCommandManagerAlertDelegate> alertCommandDelegate;

@end
