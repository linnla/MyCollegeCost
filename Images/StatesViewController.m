//
//  StatesViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "StatesViewController.h"

@interface StatesViewController ()

@end

@implementation StatesViewController

@synthesize statesArray, lastIndexPath, selectedState;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedState = [[NSUserDefaults standardUserDefaults] stringForKey:@"homeState"];
    
    self.statesArray = [NSArray arrayWithObjects: @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California",@"Colorado",@"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"Washington DC", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[[self navigationController] setNavigationBarHidden:NO animated:NO];
    //self.navigationItem.hidesBackButton = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.statesArray objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:selectedState]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastIndexPath = indexPath;
    
    // If user selected a row that was already selected
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        self.selectedState = [self.statesArray objectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedState forKey:@"homeState"];
        [defaults synchronize];
    }
    
    // To update SettingsTableViewController
    [tableView reloadData];
    
    // Virginia Brewer request
    /* Prevented the back button from returning to MasterViewController -- NEEDS WORK
    // After user select a state, return to SettingsViewController
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
     */
}


@end
