//
//  EntryViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

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
    self.navigationController.navigationBar.hidden = YES;
        
    //[[UIButton appearance] setBackgroundImage:[UIImage imageNamed:@"backNormal.png"]
      //                                                forState:UIControlStateNormal
        //                                            barMetrics:UIBarMetricsDefault];
    
    //[[UIButton appearance] setBackgroundImage:[UIImage imageNamed:@"backSelected.png"]
          //                                            forState:UIControlStateSelected
            //                                        barMetrics:UIBarMetricsDefault];
}

- (IBAction)rateAppInAppStore:(id)sender
{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@289382458", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(void)viewWillAppear
{
    // This doesn't work
    //self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidAppear
{
    // This doesn't work
    //self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // This doesn't work
    //self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    // This doesn't work
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCalculateMyCost:nil];
    [self setSearchForCollege:nil];
    [self setRateMe:nil];
    [super viewDidUnload];
}
@end
