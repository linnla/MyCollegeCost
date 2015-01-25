//
//  APAlertView.h
//  AskingPointLib
//
//  Copyright (c) 2012 KnowFu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APAlertViewDelegate;

@interface APAlertView : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, assign) id<APAlertViewDelegate> delegate;
@property(nonatomic) NSInteger cancelButtonIndex;
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<APAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSInteger)addButtonWithTitle:(NSString *)title andInfo:(id)info;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (id)buttonInfoAtIndex:(NSInteger)buttonIndex;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)show;

@end

@protocol APAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(APAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(APAlertView *)alertView;

- (void)willPresentAlertView:(APAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(APAlertView *)alertView;  // after animation

- (void)alertView:(APAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(APAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

@interface APAlertView (APCommand) <APAlertViewDelegate>

@property(nonatomic,readonly) NSString *commandId;

// When the view is created with this, the delegate is also set to self
-(id)initWithCommand:(NSDictionary*)command;

@end
