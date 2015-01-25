//
//  AppDelegate.h
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <AskingPoint/AskingPoint.h>

@class BannerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSArray *paths;
@property (nonatomic, retain) NSString *documentsDirectory;
@property (nonatomic, retain) NSString *writableDBPath;
@property (nonatomic, retain) FMDatabase *databaseName;

@end
