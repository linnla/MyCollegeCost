//
//  SettingsTableViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize incomeLevelSelected, lastIndexPath, segmentedControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           
    incomeLevelSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    // Set background for tableview
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundBlueParchment.png"]];
    self.tableView.backgroundColor = background;

}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl
{
    //NSLog(@"indexDidChangeForSegmentedControl started");
    
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:{
            incomeLevelSelected = [NSNumber numberWithInt:99];
            [self runMethodInBackground:@"saveDefaultForIncomeLevel:" methodParameter:incomeLevelSelected];

            break;
        }
        case 1:{
            SettingsContainerViewController *settingsContainerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsContainer"];
            [self.navigationController pushViewController:settingsContainerViewController animated:YES];
            break;
        }
    }
}

-(void)createSegmentedControl
{
    // Set background images
    UIImage *segmentNormal = [[UIImage imageNamed:@"SegmentNormal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelected = [[UIImage imageNamed:@"SegmentSelected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    // Set divider images
    UIImage *segmentRightSelected = [UIImage imageNamed:@"SegmentRightSelected.png"];
    UIImage *segmentLeftSelected = [UIImage imageNamed:@"SegmentLeftSelected.png"];
    UIImage *segmentDividerNormal = [UIImage imageNamed:@"SegmentDividerNormal.png"];
    
    segmentedControl.momentary = YES;
    
    // Set divider images
    [[UISegmentedControl appearance] setDividerImage:segmentDividerNormal
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentLeftSelected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentRightSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentNormal
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS 5 compatible
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section) {
        case 0:
            if ([incomeLevelSelected integerValue] >=0 && [incomeLevelSelected integerValue] <= 4) {
                if (row == [incomeLevelSelected integerValue]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;   
                }
            else if ([incomeLevelSelected integerValue] == 99){
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndexPath = indexPath;
    
    // If user selected a row that was already selected
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        incomeLevelSelected = [NSNumber numberWithInt:[indexPath row]];
        [self runMethodInBackground:@"saveDefaultForIncomeLevel:" methodParameter:incomeLevelSelected];
    } else {
        incomeLevelSelected = [NSNumber numberWithInt:99];
    }
    
    [self.tableView reloadData];
}

// Run method in background with parameter
-(void)runMethodInBackground:(NSObject *)method methodParameter:(NSObject *)parameter
{
    //Operation Queue init (autorelease)
    NSOperationQueue *queue = [NSOperationQueue new];
    
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveDefaultForIncomeLevel:) object:incomeLevelSelected];
    
    //Add the operation to the queue
    [queue addOperation:operation];
}

-(void)saveDefaultForIncomeLevel:(NSObject *)newDefaultValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newDefaultValue forKey:@"incomeLevel"];
    [defaults setObject:@"YES" forKey:@"needsRefresh"];
    [defaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If user presses on a college to see college details
    if ([[segue identifier] isEqualToString:@"calculate"]) {
        
        // Create an instance of our DetailViewController
        CollegeViewController *vc = [[CollegeViewController alloc]init];
        
        //Set the DVC to the destinationViewController property of the segue
        vc = [segue destinationViewController];
        vc.incomeLevel = incomeLevelSelected;
    }
}


@end
