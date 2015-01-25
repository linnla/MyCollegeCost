//
//  AppDelegate.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "AppDelegate.h"
#import "EntryViewController.h"
#import "BannerViewController.h"

@implementation AppDelegate
{
    BannerViewController *_bannerViewController;
}

@synthesize databaseName, paths, writableDBPath, documentsDirectory, window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *navigationController = (UINavigationController*)appDelegate.window.rootViewController;
   
    _bannerViewController = [[BannerViewController alloc] initWithContentViewController:navigationController];
    self.window.rootViewController = _bannerViewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    [self customizeAppearanceiPhone];
    
    /*
    // AllMyColleges Keys
    #ifdef DEBUG
        [APManager startup:@"HACUAEQCUeIqW4-UUf8jL3F2CLaY3TxwDcpcEp-wkJM"]; // Test API_Key
    #else
        [APManager startup:@"rQCJAEQCUeJNue3yoHypnj_G83MA2Br9HzW2GE1ck0k"]; // Release API_Key
    #endif
     */
    
    // MyCollegeCost Keys
    #ifdef DEBUG
        [APManager startup:@"9wB2AEcCUeKTyxSvde53mRUDHW0XnH3DpkKdREpsnjc"]; // Test API_Key
    #else
        [APManager startup:@"HAB3AEcCUeIw-SupxI-pey_YJ7hwWOWkKskqjTyF90g"]; // Release API_Key32222
    #endif

    // Set database name
    self.databaseName = @"db_MyCollegeCost.sqlite";
    
    // Find documents directory
    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];
    
    // Writeable path = path plus database file name
    self.writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    // See if the named database exists at writeable path, if not, create database
    [self createAndCheckDatabase];
    
    // Used for Deubgging purposes to reset user defaults
    // This data is null upon first entry into app because database was just created in the writeable path
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:[NSNumber numberWithInt:99] forKey:@"incomeLevel"];
    [defaults setObject: @"rankUSNewsUniversities" forKey:@"selectedSort"];
    [defaults synchronize];
    
    return YES;
}

-(void) customizeAppearanceiPhone
{
    // Navigation Bar
    // Create resizable images
    UIImage *gradientImage44 = [[UIImage imageNamed:@"MenuBar.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImage32 = [[UIImage imageNamed:@"MenuBar.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                       forBarMetrics:UIBarMetricsLandscapePhone];
    
    // Customize the title text for *all* UINavigationBars
    /*
    [[UINavigationBar appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
    UITextAttributeTextColor,
    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
    UITextAttributeTextShadowColor,
    [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
    UITextAttributeTextShadowOffset,
    [UIFont fontWithName:@"Arial-BoldMT" size:18.0],
    UITextAttributeFont,
    nil]];
     */
    
    // Set Back Button Background Image
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"BackNormal.png"]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"BackSelected.png"]
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:[UIImage imageNamed:@"BackNormal.png"]
                                                                                    forState:UIControlStateNormal
                                                                                  barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:[UIImage imageNamed:@"BackSelected.png"]
                                                                                    forState:UIControlStateSelected
                                                                                  barMetrics:UIBarMetricsDefault];
    
    // These didn't work, unrecognized selector sent to instance
   // [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"backNormal.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
   // [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"backSelected.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
   // [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"backSelected.png"]
     //                              forBarMetrics:UIBarMetricsDefault];
    
    UIColor *menuBarColor = [UIColor colorWithRed:1/256.0 green:96.0/256.0 blue:34.0/256.0 alpha:1.0];
    [[UISearchBar appearance] setTintColor:menuBarColor];

}

-(void) createAndCheckDatabase
{
    // See if the database exists at the writeable path
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    // If database is found in writeable path, return --- otherwise create database in writeable path
    if (success) return;
    else {
        
        // The database was not found in writeable path, get path and database name from bundle
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db_MyCollegeCost.sqlite"];
        
        // Copy the database from the bundle to the writeable path
        [fileManager copyItemAtPath:databasePathFromApp toPath:writableDBPath error:nil];
    }
    
    // Debug code
    //NSLog(@"Does file exist in the writable path --- %@", success ? @"YES" : @"NO");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
