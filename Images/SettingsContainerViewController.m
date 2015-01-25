//
//  SettingsContainerViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "SettingsContainerViewController.h"

@interface SettingsContainerViewController ()

@end

@implementation SettingsContainerViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.hidden = NO;
    
    // To reamain compatible with iOS 5 --- for iOS 6 connect via storyboard IBOutlets
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    SettingsTableViewController *tvc =[storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];
    
    // ensure embedded view is aligned to top
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tvc.view.frame = frame;
    
    [tvc didMoveToParentViewController:self];
       
	// Do any additional setup after loading the view.
}

@end
