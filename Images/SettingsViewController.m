//
//  SettingsViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize incomeLevelSelected, lastIndexPath, lastSelected, incomeArray, tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    incomeLevelSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"] == nil) incomeLevelSelected = [NSNumber numberWithInt:99];
    else incomeLevelSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"];
    
    // Set tableView background
    self.tableView.opaque = NO;
    self.tableView.backgroundView  = nil;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundGreen.png"]];
    self.tableView.backgroundColor = background;
    
    [self createBarButtons];
    [self loadData];
    
    lastSelected = 98;
}

-(void)loadData{
    self.incomeArray = [NSArray arrayWithObjects: @"$0 - $30,000", @"$30,001 - $48,000", @"$48,001 - $75,000", @"$75,001 - $110,000", @"$110,000 and above", nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)createBarButtons
{
    // Reset Button
    UIImage *resetButtonNormal = [UIImage imageNamed:@"ResetButtonNormal_60.png"];
    UIImage *resetButtonSelected = [UIImage imageNamed:@"ResetButtonSelected_60.png"];
    
    CGRect resetFrame = CGRectMake(0, 0, resetButtonNormal.size.width, resetButtonNormal.size.height);
    UIButton *resetButton = [[UIButton alloc] initWithFrame:resetFrame];
    
    [resetButton setBackgroundImage:resetButtonNormal forState:UIControlStateNormal];
    [resetButton setBackgroundImage:resetButtonSelected forState:UIControlStateSelected];
    
    [resetButton setShowsTouchWhenHighlighted:NO];
    
    [resetButton addTarget:self action:@selector(resetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *resetBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:resetButton];
    
    // Calculate Button
    UIImage *calculateButtonNormal = [UIImage imageNamed:@"CalculateButtonNormal_60.png"];
    UIImage *calculateButtonSelected = [UIImage imageNamed:@"CalculateButtonSelected_60.png"];
    
    CGRect calculateFrame = CGRectMake(0, 0, calculateButtonNormal.size.width, calculateButtonNormal.size.height);
    UIButton *calculateButton = [[UIButton alloc] initWithFrame:calculateFrame];
    
    [calculateButton setBackgroundImage:calculateButtonNormal forState:UIControlStateNormal];
    [calculateButton setBackgroundImage:calculateButtonSelected forState:UIControlStateSelected];
    
    [calculateButton setShowsTouchWhenHighlighted:NO];
    
    [calculateButton addTarget:self action:@selector(calculateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *calculateBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:calculateButton];
    
    // Add Buttons to Array of Bar Button Items
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:calculateBarButtonItem, resetBarButtonItem, nil];
}

-(void)calculateButtonClicked
{
    //CollegeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"College"];
    
    MasterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Master"];
    
    NSArray *viewControllers = nil;
    
    viewControllers = [NSArray arrayWithObjects:vc, nil];
    
    //[self.navigationController pushViewController:collegeViewController animated:YES];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

-(void)resetButtonClicked
{
    incomeLevelSelected = [NSNumber numberWithInt:99];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:incomeLevelSelected forKey:@"incomeLevel"];
    [defaults setObject: @"rankUSNewsUniversities" forKey:@"selectedSort"];
    [defaults synchronize];
    
    // When this runs in background it doesn't always save before CollegeViewController is pushed and populateCollege run from viewDidLoad
    //[self runMethodInBackground:@"saveDefaultForIncomeLevel:" methodParameter:incomeLevelSelected];
    
    [self calculateButtonClicked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [incomeArray count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Setup view and background color
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight)];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    // Setup look of header titles
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.tableView.bounds.size.width - 10, 18)];
    headerText.backgroundColor=[UIColor clearColor];
    headerText.shadowColor = [UIColor blackColor];
    headerText.shadowOffset = CGSizeMake(0,1);
    headerText.textColor = [UIColor whiteColor];
    headerText.font = [UIFont boldSystemFontOfSize:17.0];
    //headerText.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0];
    
    headerText.text = @"Household Income";
    
    [headerView addSubview:headerText];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS 5 compatible
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.incomeArray objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    NSInteger row = [indexPath row];
    
    int selectedIncome = [incomeLevelSelected intValue];
   
    if (selectedIncome == 99) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (lastSelected != row) {
        // User selected a different income level
        
        //Assign income selected to the row clicked
        if (selectedIncome == row){
        //if ([incomeLevelSelected integerValue] == row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastSelected = row;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        // User clicked on same row
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        // reset last selected row --- row 0 exists so can't reset to 0 --- Can't reset to same value as incomeLevelSelected or this "else" will become an endless loop
        lastSelected = 98;
        // reset income selected --- row 0 exists so can't reset to 0 --- Can't reset to same value as lastSelected or this "else" will become an endless loop
        //incomeLevelSelected = [NSNumber numberWithInt:99];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndexPath = indexPath;
    NSNumber *incomeLevelSelectedLast = incomeLevelSelected;
    incomeLevelSelected = [NSNumber numberWithInt:[indexPath row]];
    
    if (incomeLevelSelectedLast == incomeLevelSelected) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        incomeLevelSelected = [NSNumber numberWithInt:99];
        [self runMethodInBackground:@"saveDefaultForIncomeLevel:" methodParameter:incomeLevelSelected];
    } else {
        incomeLevelSelected = [NSNumber numberWithInt:[indexPath row]];
        [self runMethodInBackground:@"saveDefaultForIncomeLevel:" methodParameter:incomeLevelSelected];
    }
    
    [self.tableView reloadData];
}

// Run method in background with parameter
-(void)runMethodInBackground:(NSObject *)method methodParameter:(NSObject *)parameter
{
    //Operation Queue init (autorelease)
    NSOperationQueue *queue = [NSOperationQueue new];
    
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveDefaultForIncomeLevel:) object:parameter];
    
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
