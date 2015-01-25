//
//  APWebViewController.h
//  AskingPointLib
//
//  Created by AskingPoint on 1/1/12.
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class APWebViewController;
@protocol APWebViewControllerDelegate
@required
- (void)apWebViewControllerDone:(APWebViewController*)apWebView withError:(NSError*)error;
@end

@interface APWebViewController : UIViewController <UIWebViewDelegate>

@property(assign) id<APWebViewControllerDelegate> delegate;

@end

@interface APWebViewController (APCommand)

-(id)initWithCommand:(NSDictionary*)command;
- (void)show;

@end