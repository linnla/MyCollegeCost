//
//  MasterViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//
/*  SearchBar implementation notes
In storyboard, in order for searchBar to hide correctly and for bannerView to appear, this is the object layer order (create the objects in this order) ViewController --> View --> navigation item segmenteControl on navigation bar as titleView --> navigation item searchButton on right --> TableView --> searchBar in tableView header.  Create the objects in this order and the searchBar will appear/disappear on app entry.  viewDidAppear has the only scrollToRow command outside of the search methods.  self.tableview reload is in viewWillAppear.
 
 BannerView also displays across all screen with this configuration.
 
*/


#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize tableView, searchCancelled, searching, segmentedControl, activityIndicator, activityView, sortSelected, needsRefresh, incomeLevel, spinner, collegeNumber;

@synthesize filteredTableData, nameSections, stateSections, rankUSNewsUniversitiesSections, academicArray, searchArray, selectedSort, sortActionSheet, costArray, forbesArray, usNewsArray, netCostSections, masterDataArray, rankUSNewsUniversitiesArray;

// Segue Properties
@synthesize collegeName, collegeControl, collegeCommuter;

@synthesize collegeCityState, collegeRank, collegeSetting, collegeSize, collegePercentAdmitted, collegeAdmitted, collegeApplicants, collegeTuitionIn, collegeTuitionOut, collegeTotalIn, collegeTotalOut, collegePartTime, collegeGsA, collegeGsP, collegeSlA, collegeSlP, collegeA030, collegeA110, collegeA3048, collegeA4875, collegeA75110, collegeNp030, collegeNp110, collegeNp3048, collegeNp4875, collegeNp75110, collegeRankForbesNational, collegeRankUSNewsLiberalArts, collegeRankUSNewsUniversities, collegeStudentFacultyRatio, collegeRetentionRate, collegeIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    searchCancelled = @"YES";
    searching = @"NO";
    
    incomeLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"];
    //NSLog(@"incomeLevel %@", incomeLevel);
    if (incomeLevel == NULL) {
        incomeLevel = [NSNumber numberWithInt:99];
        //NSLog(@"incomeLevel %@", incomeLevel);
    }
    
    selectedSort = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSort"];
    sortSelected = selectedSort;
    
    [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
    [self loadData];
    [self hideActivityViewer];

    [self createBarButtons];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    // This only executes when user clicks back button in detailViewController
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- BarButtons

-(void)createBarButtons
{
    // Search Button
    UIImage *searchButtonNormal = [UIImage imageNamed:@"SearchButtonNormal_45.png"];
    UIImage *searchButtonSelected = [UIImage imageNamed:@"SearchButtonSelected_45.png"];
    
    CGRect searchFrame = CGRectMake(0, 0, searchButtonNormal.size.width, searchButtonNormal.size.height);
    UIButton *searchButton = [[UIButton alloc] initWithFrame:searchFrame];
    
    [searchButton setBackgroundImage:searchButtonNormal forState:UIControlStateNormal];
    [searchButton setBackgroundImage:searchButtonSelected forState:UIControlStateSelected];
    
    [searchButton setShowsTouchWhenHighlighted:NO];
    
    [searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    // Sort Button
    UIImage *sortButtonNormal = [UIImage imageNamed:@"SortButtonNormal_45.png"];
    UIImage *sortButtonSelected = [UIImage imageNamed:@"SortButtonSelected_45.png"];
    
    CGRect sortFrame = CGRectMake(0, 0, sortButtonNormal.size.width, sortButtonNormal.size.height);
    UIButton *sortButton = [[UIButton alloc] initWithFrame:sortFrame];
    
    [sortButton setBackgroundImage:sortButtonNormal forState:UIControlStateNormal];
    [sortButton setBackgroundImage:sortButtonSelected forState:UIControlStateSelected];
    
    [sortButton setShowsTouchWhenHighlighted:NO];
    
    [sortButton addTarget:self action:@selector(sortButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sortButton];
    
    // Settings
    UIImage *settingsButtonNormal = [UIImage imageNamed:@"SettingsButtonNormal_45.png"];
    UIImage *settingsButtonSelected = [UIImage imageNamed:@"SettingsButtonSelected_45.png"];
    
    CGRect settingsFrame = CGRectMake(0, 0, settingsButtonNormal.size.width, settingsButtonNormal.size.height);
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:settingsFrame];
    
    [settingsButton setBackgroundImage:settingsButtonNormal forState:UIControlStateNormal];
    [settingsButton setBackgroundImage:settingsButtonSelected forState:UIControlStateSelected];
    
    [settingsButton setShowsTouchWhenHighlighted:NO];
    
    [settingsButton addTarget:self action:@selector(settingsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    // Home
    UIImage *homeButtonNormal = [UIImage imageNamed:@"HomeButtonNormal_45.png"];
    UIImage *homeButtonSelected = [UIImage imageNamed:@"HomeButtonSelected_45.png"];
    
    CGRect homeFrame = CGRectMake(0, 0, homeButtonNormal.size.width, homeButtonNormal.size.height);
    UIButton *homeButton = [[UIButton alloc] initWithFrame:homeFrame];
    
    [homeButton setBackgroundImage:homeButtonNormal forState:UIControlStateNormal];
    [homeButton setBackgroundImage:homeButtonSelected forState:UIControlStateSelected];
    
    [homeButton setShowsTouchWhenHighlighted:NO];
    
    [homeButton addTarget:self action:@selector(homeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];

    
    // Add Buttons to Array of Bar Button Items
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:searchBarButtonItem, settingsBarButtonItem, sortBarButtonItem, homeBarButtonItem, nil];
}

-(void)homeButtonClicked
{
    EntryViewController *entryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Entry"];
    NSArray *viewControllers = nil;
    
    viewControllers = [NSArray arrayWithObjects:entryViewController, nil];
   
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

-(void)settingsButtonClicked
{
    // Push ViewController
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)sortButtonClicked
{
    int income = [incomeLevel integerValue];
    //NSLog(@"income %d", income);
    
    if (income >=0 && income <= 4) {
        sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by..."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Alpha", @"My Net Cost", @"Rank - USNews Universities", @"State", nil];
    } else {
        sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by..."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Alpha", @"Rank - USNews Universities", @"State", nil];
    }
    
    // Display the actionSheet
    [sortActionSheet showFromToolbar:(UIToolbar *) self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Only display the "My Net Cost" sort when user has selected an incomelevel
    int income = [incomeLevel integerValue];
    
    if (income >=0 && income <= 4) {
        switch (buttonIndex) {
            case 0:{
                sortSelected = @"name";
                break;
            }
            case 1:{
                sortSelected = @"netCost";
                break;
            }
            case 2:{
                sortSelected = @"rankUSNewsUniversities";
                //sortSelected = @"academic";
                break;
            }
            case 3:{
                sortSelected = @"state";
                break;
            }
            case 4:{
                break;
            }
        }
    } else {
            switch (buttonIndex) {
                case 0:{
                    sortSelected = @"name";
                    break;
                }
                case 1:{
                    sortSelected = @"rankUSNewsUniversities";
                    //sortSelected = @"academic";
                    break;
                }
                case 2:{
                    sortSelected = @"state";
                    break;
                }
                case 3:{
                    break;
                }
            }
    }
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    // Save select sort
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sortSelected forKey:@"selectedSort"];
    [defaults synchronize];
}

#pragma mark -- Search

//From original project -- searchBar hidden at entry, not hidden when searchButton clicked
-(IBAction)searchButtonClicked
{
    //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
    //NSLog( @"%f", self.tableView.contentOffset.y);
    
    // If search bar is already displayed, or search display controller is active
    // Discovered in debug that searchDisplayController appears to never be active here
    if (self.searchDisplayController.isActive || (self.tableView.contentOffset.y < 44)){
        // If search dispaly controller is active, set to not active
        if (self.searchDisplayController.isActive) {
            
            // Clear the search text
            self.searchDisplayController.searchBar.text = nil;
            
            // Set search controller to not active
            [self.searchDisplayController setActive:NO animated:YES];
            
            // Table view delegates use this to determine correct data source
            searchCancelled = @"YES";
            [self.tableView reloadData];
        }
        [self hideSearchBar];
    } else {
        // Display the search bar
        //[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
        // Table view delegates use this to determine correct data source
        searchCancelled = @"NO";
    }
}

- (void)hideSearchBar
{
    //[self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    // Used by tableview delegates to determine correct data source
    searchCancelled = @"YES";
    searching = @"NO";
        
    // This doesn't work, tableView gets reloaded correctly with reload in searchBarTextDidEndEditing
    //[self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // Fixes crash when user press cancel while data is still scrolling on screen
    searchBar.showsCancelButton = NO;
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    searchBar.showsCancelButton = YES;  // shows cancel button after TextDidEndEditing removes it
    
    //NSLog(@"Search String = %@", searchBar.text);
    searchCancelled = @"NO";
    
    // set search string -- trim off spaces
    NSString *searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // if no search text is entered
    if (![searchString length]){
        return;   //search bar was just whitespace
    } else {
        //searchBar.showsCancelButton = YES;
        
        // this array holds search results --- used by table delegates
        filteredTableData = [[NSMutableArray alloc] init];
        searching = @"YES";
        
        // Set search controller to not active --- NEW
        self.searchDisplayController.active = YES;
        //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
        
        // For every college is search Array, look for search text
        for (College *oneCollege in searchArray) {
            
            // Add college to filterData array if search string if found within college name
            if([oneCollege.name rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound){
                [filteredTableData addObject:oneCollege];
                // Debug code
                //NSLog(@"oneCollege.name = %@", oneCollege.name);
                //NSLog(@"CONTAINS %@", searchBar.text);
            } else {
                //break;
                // Debug code
                //NSLog(@"oneCollege.name = %@", oneCollege.name);
                //NSLog(@"DOES NOT contain %@", searchBar.text);
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
    
    //NSLog(@"numberOfSectionsInTableView started");
    
    // Determine correct data source
    // Is user doing a search
    if ([searching isEqualToString:@"YES"]) {
        return 1;
    }
    //if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return 1;
    else if ([sortSelected isEqualToString: @"name"])
    {
        //NSLog(@"numberOfSectionsInTableView = %lu", (unsigned long)[[self.nameSections allKeys] count]);
        return [[self.nameSections allKeys] count];
    }
    else if ([sortSelected isEqualToString: @"state"])return [[self.stateSections allKeys] count];
    else if ([sortSelected isEqualToString: @"netCost"])return [[self.netCostSections allKeys] count];
    //else if ([sortSelected isEqualToString: @"academic"])return 1;
    else if ([sortSelected isEqualToString: @"rankUSNewsUniversities"])return [[self.rankUSNewsUniversitiesSections allKeys] count];
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection started, no finsih message will come");
    
    // Determine correct data source
    //if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return nil;
    if ([searching isEqualToString:@"YES"]) return nil;
    else if ([sortSelected isEqualToString:@"name"]) return [[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    else if ([sortSelected isEqualToString:@"state"]) return [[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    else if ([sortSelected isEqualToString:@"netCost"]) return [[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    else if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
        NSString *rankTitle = [[[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        // Starting at position 2, get 8 characters
        NSRange range = {25, 3};
        return [rankTitle substringWithRange:range];
    }
    else return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection started, no finsih message will come");
    
    // Determine correct data source
    //if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
    
    if ([searching isEqualToString:@"YES"]) {
        return [self.filteredTableData count];
    
    } else if ([sortSelected isEqualToString:@"name"]){
        return [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
    } else if ([sortSelected isEqualToString:@"state"]){
        return [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
    } else if ([sortSelected isEqualToString:@"netCost"]){
        return [[netCostSections valueForKey:[[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
    } else if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
        return [[rankUSNewsUniversitiesSections valueForKey:[[[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
    //} else if ([sortSelected isEqualToString: @"academic"]){
      //  return [academicArray count];
        
    } else return 0;
}

//Search Methods look at this setting rather than row height set in storyBoard
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // Determine correct data source
    //if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return nil;
    if ([searching isEqualToString:@"YES"]) return nil;
    else if ([sortSelected isEqualToString: @"name"]) return [[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([sortSelected isEqualToString:@"state"]) return [[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([sortSelected isEqualToString:@"netCost"]) return [[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
        NSArray *sectionTitlesArray =  [NSArray arrayWithObjects: @"1",@"25",@"50",@"75",@"100",@"125",@"150",@"175",nil];
        return sectionTitlesArray;
        //return [[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Setup view and background color
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight)];
    
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SectionHeaderBlue.png"]];
    
    //headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundBrownSmoothTexture.png"]];
    
    // Setup look of header titles
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, self.tableView.bounds.size.width - 10, 18)];
    headerText.backgroundColor=[UIColor clearColor];
    headerText.shadowColor = [UIColor blackColor];
    headerText.shadowOffset = CGSizeMake(0,2);
    headerText.textColor = [UIColor whiteColor];
    headerText.font = [UIFont boldSystemFontOfSize:18.0];
    //headerText.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0];
    
    // Get text for header title
    if ([sortSelected isEqualToString:@"name"]){
        
        // Set header text from name dictionary
        headerText.text = [[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    if ([sortSelected isEqualToString:@"state"]){
        
        // Set header text from states dictionary
        headerText.text = [[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    if ([sortSelected isEqualToString:@"netCost"]){
        
        // Set header text from netCost dictionary
        NSString *noDataForIncomeLevel = [[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        if ([noDataForIncomeLevel isEqualToString:@"NA"]) headerText.text = @"No Data Available";
        else headerText.text = [[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
        
        NSString *rankTitle = [[[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        NSString *header = [rankTitle substringFromIndex:1];
        //NSLog(@"header %@", header);
        if ([header isEqualToString:@"1"]) headerText.text = @"Rank 1 - 24";
            else if ([header isEqualToString:@"25"]) headerText.text = @"Rank 25 - 49";
            else if ([header isEqualToString:@"50"]) headerText.text = @"Rank 50 - 74";
            else if ([header isEqualToString:@"75"]) headerText.text = @"Rank 75 - 99";
            else if ([header isEqualToString:@"100"]) headerText.text = @"Rank 100 - 124";
            else if ([header isEqualToString:@"125"]) headerText.text = @"Rank 125 - 149";
            else if ([header isEqualToString:@"150"]) headerText.text = @"Rank 150 - 174";
            else if ([header isEqualToString:@"175"]) headerText.text = @"Rank 175 - 200";
            else if ([header isEqualToString:@"Unranked"]) headerText.text = @"Unranked";
        
        //NSString *header = [rankTitle substringFromIndex:1];
        //headerText.text = header;
    }

    [headerView addSubview:headerText];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRow started, no finsih message will come");
    
    static NSString *CellIdentifier = @"Cell";
    
    MasterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in [self.tableView subviews]) {
        if([view respondsToSelector:@selector(setIndexColor:)]) {
            [view performSelector:@selector(setIndexColor:) withObject:[UIColor blackColor]];
        }
    }
    
    // Determine the datasource and create a Mastercell with the object
   // if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
    if ([searching isEqualToString:@"YES"]) {
        //NSLog(@"cfr filteredTableData count is: %d", [filteredTableData count]);
        College *college = [filteredTableData objectAtIndex:[indexPath row]];
        // The cell is customized in MasterCell
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"academic"]){
        //NSLog(@"cfr academicArray count is: %d", [academicArray count]);
        College *college = [academicArray objectAtIndex:[indexPath row]];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"name"]){
        //NSLog(@"cfr nameSections count is: %d", [nameSections count]);
        College *college = [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"state"]){
        //NSLog(@"cfr stateSections count is: %d", [stateSections count]);
        College *college = [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"netCost"]){
        //NSLog(@"cfr netCostSections count is: %d", [netCostSections count]);
        College *college = [[self.netCostSections valueForKey:[[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
        College *college = [[self.rankUSNewsUniversitiesSections valueForKey:[[[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [cell setCellDetailsForCollege:college];
    }

    return cell;
}

#pragma mark -- DataLoad

-(void)showActivityViewer
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    
    activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    activityView.backgroundColor = [UIColor blackColor];
    activityView.alpha = 0.5;
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
    
    activityWheel.color = [UIColor blackColor];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    [activityView addSubview:activityWheel];
    [window addSubview: activityView];
    
    [activityWheel setHidden:NO];
    
    [activityView bringSubviewToFront:window];
    [[[activityView subviews] objectAtIndex:0] startAnimating];
}

-(void)hideActivityViewer
{
    [[[activityView subviews] objectAtIndex:0] stopAnimating];
    [activityView removeFromSuperview];
    activityView = nil;
}

// Loads data on main thread --- used only for name sort in viewDidLoad
-(void)loadData
{
    // Create sections
    [self createSections:@"name"];
    [self createSections:@"state"];
    [self createSections:@"rankUSNewsUniversities"];
    
    int income = [incomeLevel integerValue];
    if (income >=0 && income <= 4) {
        [self createSections:@"netCost"];
    }
    
    // Create masterDataArray
    masterDataArray = [[NSMutableArray alloc] init];
    [self createMasterDataArray];
    
    // Add masterData to arrays and dictionaries
    [self createSortedArrays];
    [self createSortedDictionaries];
    
    //[self.tableView reloadData];
}

-(void)createSections:(NSString *)dataSort
{
    // Set db path and open db
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writableDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    [db open];
    
    // Alloc init sql statement string -- do it outside of if-else so varaible can be seen 
    NSString *mySql = [[NSString alloc] init];
    
    if ([dataSort isEqual: @"name"]) {
        
        // set the sql statement --- get distinct name to create name section indexes
        mySql = @"SELECT DISTINCT name FROM AMC ORDER BY name";
        
        // setup the dictionary
        self.nameSections = [[NSMutableDictionary alloc] init];
    }
    
    if ([dataSort isEqual: @"state"]) {
        
        // set the sql statement --- get distinct name to create name section indexes
        mySql = @"SELECT DISTINCT state FROM AMC ORDER BY state";
        
        // setup the dictionary
        self.stateSections = [[NSMutableDictionary alloc] init];
    }
    
    if ([dataSort isEqual: @"netCost"]) {
        
        if ([incomeLevel integerValue] == 0){
            mySql = @"SELECT DISTINCT si_netCost030 FROM AMC ORDER BY i_030";
        } else if ([incomeLevel integerValue] == 1){
            mySql = @"SELECT DISTINCT si_netCost3048 FROM AMC ORDER BY i_3048";
        } else if ([incomeLevel integerValue] == 2){
            mySql = @"SELECT DISTINCT si_netCost4875 FROM AMC ORDER BY i_4875";
        } else if ([incomeLevel integerValue] == 3){
            mySql = @"SELECT DISTINCT si_netCost75110 FROM AMC ORDER BY i_75110";
        } else if ([incomeLevel integerValue] == 4){
            mySql = @"SELECT DISTINCT si_netCost110 FROM AMC ORDER BY i_110";
        }
            
        // setup the dictionary
        self.netCostSections = [[NSMutableDictionary alloc] init];
    }
    
    if ([dataSort isEqual: @"rankUSNewsUniversities"]) {
        
        // set the sql statement --- get distinct name to create name section indexes
        mySql = @"SELECT DISTINCT si_usNewsUniversities FROM AMC ORDER BY si_usNewsUniversities";
        
        // setup the dictionary
        self.rankUSNewsUniversitiesSections = [[NSMutableDictionary alloc] init];
    }

    // Execute the sql statement
    FMResultSet *results = [db executeQuery:mySql];
    
    // Loop through the results
    while ([results next]){
        
        // Alpha sort
        if ([dataSort isEqual: @"name"]) {
            
            // Add an uppercase first letter of name to section dictionary
            [nameSections setValue:[[NSMutableArray alloc] init] forKey:[[[results stringForColumn:@"name"] substringToIndex:1] uppercaseString]];
            
        // State sort
        } else if ([dataSort isEqual: @"state"]) {
            
            // Add an uppercase first letter of state to section dictionary
            [stateSections setValue:[[NSMutableArray alloc] init] forKey:[[[results stringForColumn:@"state"] substringToIndex:1] uppercaseString]];
            //NSLog(@"stateSections: %@", stateSections);
       
        } else if ([dataSort isEqual: @"rankUSNewsUniversities"]) {
            
            //[rankUSNewsUniversitiesSections setValue:[[NSMutableArray alloc] init] forKey:[[[results stringForColumn:@"si_usNewsUniversities"] substringToIndex:1] uppercaseString]];
            
            [rankUSNewsUniversitiesSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_usNewsUniversities"]];
            
        } else if ([dataSort isEqual: @"netCost"]) {
            
            if ([incomeLevel integerValue] == 0){
                [netCostSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_netCost030"]];
            } else if ([incomeLevel integerValue] == 1){
                [netCostSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_netCost3048"]];
            } else if ([incomeLevel integerValue] == 2){
                [netCostSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_netCost4875"]];
            } else if ([incomeLevel integerValue] == 3){
                [netCostSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_netCost75110"]];
            } else if ([incomeLevel integerValue] == 4){
                [netCostSections setValue:[[NSMutableArray alloc] init] forKey:[results stringForColumn:@"si_netCost110"]];
            }
        }
    }
    
    // close sql results
    [results close];
    
    // close database
    [db close];
}

-(void)createMasterDataArray
{
    // Set the database path
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writableDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
     
    // Open the database
    [db open];
     
    // Create the SQL statements
    NSString *mySql = @"SELECT * FROM AMC ORDER BY name";
     
    // Execute SQL query
    FMResultSet *results = [db executeQuery:mySql];
     
    while([results next])
    {
        // Setup the cell
     
        // Basics
        College *college = [[College alloc] init];
        
        NSInteger intNumber = [results intForColumn:@"unitid"];
        NSNumber *pointerNumber = [NSNumber numberWithInt:[results intForColumn:@"unitid"]];
        college.number = [pointerNumber stringValue];
        
        //int intNumber = [results intForColumn:@"unitid"];
        //college.number = [NSString stringWithFormat:@"%d", intNumber];
        
        college.name = [results stringForColumn:@"name"];
        college.cityState = [results stringForColumn:@"cityState"];
        college.state = [results stringForColumn:@"state"];
        college.size = [results stringForColumn:@"size"];
        college.setting = [results stringForColumn:@"setting"];
        college.control = [results stringForColumn:@"control"];
     
        // Ratios
        college.retentionRate = [results stringForColumn:@"retentionRate"];
        college.studentFacultyRatio = [results stringForColumn:@"studentFacultyRatio"];
     
        // Rank
        //NSLog(@"rankUSNews is: %d", [results intForColumn:@"rankUSNewsUniversities"]);
        
        int rankUSNewsLiberalArts = [results intForColumn:@"rankUSNewsLiberalArts"];
        int rankUSNewsUniversities = [results intForColumn:@"rankUSNewsUniversities"];
        int rankForbesNational = [results intForColumn:@"rankForbesNational"];
        
        college.rankUSNewsUniversities = [results stringForColumn:@"si_rankUSNewsUniversities"];
        college.si_usNewsUniversities = [results stringForColumn:@"si_usNewsUniversities"];
        
        college.rankUSNews = rankUSNewsUniversities;
        college.rankForbes = rankForbesNational;
     
        if (rankUSNewsLiberalArts == 999) college.rankUSNewsLiberalArts = @"Unranked";
        else college.rankUSNewsLiberalArts = [NSString stringWithFormat:@"%d", rankUSNewsLiberalArts];
     
        if (rankUSNewsUniversities == 999){
            college.rankUSNewsUniversities = @"Unranked";
            college.rank = @" ";
        } else {
            college.rankUSNewsUniversities = [NSString stringWithFormat:@"%d", rankUSNewsUniversities];
            college.rank = [@"#" stringByAppendingString: [NSString stringWithFormat:@"%d", rankUSNewsUniversities]];
        }
        
        if (rankForbesNational == 999) college.rankForbesNational = @"Unranked";
        else college.rankForbesNational = [NSString stringWithFormat:@"%d", rankForbesNational];
     
        // Net Cost
        // User hasn't setup or reset income level
        if ([incomeLevel integerValue] == 99 || incomeLevel == nil) {
            college.computedNetCost = 999999;
            college.studentAvgNetPrice = @" ";
            // User has setup an income level
        } else if ([incomeLevel integerValue] >=0 && [incomeLevel integerValue] <= 4){
            int income = [incomeLevel integerValue];
            if (income >=0 && income <= 4) {
                if (income == 0){
                    if ([[results stringForColumn:@"anp030"] isEqualToString:@"999999"]){           // If 999999, college doesn't have data for that income level
                        college.studentAvgNetPrice = @"No Data";
                        college.computedNetCost = 999999;
                    } else {
                        college.studentAvgNetPrice = [results stringForColumn:@"anp030"];
                        college.computedNetCost = [[results stringForColumn:@"anp030"] integerValue];
                    }
                } else if (income == 1){
                    if ([[results stringForColumn:@"anp3048"] isEqualToString:@"999999"]){
                        college.studentAvgNetPrice = @"No Data";
                        college.computedNetCost = 999999;
                    } else {
                        college.studentAvgNetPrice = [results stringForColumn:@"anp3048"];
                        college.computedNetCost = [[results stringForColumn:@"anp3048"] integerValue];
                    }
                } else if (income == 2){
                    if ([[results stringForColumn:@"anp4875"] isEqualToString:@"999999"]){
                        college.studentAvgNetPrice = @"No Data";
                        college.computedNetCost = 999999;
                    } else {
                        college.studentAvgNetPrice = [results stringForColumn:@"anp4875"];
                        college.computedNetCost = [[results stringForColumn:@"anp4875"] integerValue];
                    }
                } else if (income == 3){
                    if ([[results stringForColumn:@"anp75110"] isEqualToString:@"999999"]){
                        college.studentAvgNetPrice = @"No Data";
                        college.computedNetCost = 999999;
                    } else {
                        college.studentAvgNetPrice = [results stringForColumn:@"anp75110"];
                        college.computedNetCost = [[results stringForColumn:@"anp75110"] integerValue];
                    }
                } else if (income == 4){
                    if ([[results stringForColumn:@"anp110"] isEqualToString:@"999999"]){
                        college.studentAvgNetPrice = @"No Data";
                        college.computedNetCost = 999999;
                    } else {
                        college.studentAvgNetPrice = [results stringForColumn:@"anp110"];
                        college.computedNetCost = [[results stringForColumn:@"anp110"] integerValue];
                    }
                }
            }
        }
     
        // Section Index data
        college.costVariable        = [results intForColumn:@"costVariable"];
        college.sectionIndexCost    = [results stringForColumn:@"sectionIndexCost"];
        college.si_netCost030       = [results stringForColumn:@"si_netCost030"];
        college.i_030               = [results intForColumn:@"i_030"];
        college.si_netCost3048      = [results stringForColumn:@"si_netCost3048"];
        college.i_3048              = [results intForColumn:@"i_3048"];
        college.si_netCost4875      = [results stringForColumn:@"si_netCost4875"];
        college.i_4875              = [results intForColumn:@"i_4875"];
        college.si_netCost75110     = [results stringForColumn:@"si_netCost75110"];
        college.i_75110             = [results intForColumn:@"i_75110"];
        college.si_netCost110       = [results stringForColumn:@"si_netCost110"];
        college.i_110               = [results intForColumn:@"i_110"];
        
        // Academic Stars / Cost
        college.academicCategory = [results stringForColumn:@"academicCategory"];
        college.costCategory = [results stringForColumn:@"costCategory"];
     
        // Create details for college to be displayed in DetailTableViewController
     
        // Statistics
        college.applicants = [results stringForColumn:@"applicants"];
        college.admitted = [results stringForColumn:@"admitted"];
        college.percentAdmitted = [results stringForColumn:@"percentAdmitted"];
     
        // Convert strings to strings formated as numbers
        college.applicants = [results stringForColumn:@"applicants"];
        college.admitted = [results stringForColumn:@"admitted"];
     
        // If commuter filed = Yes, set commuter field in cell
        if ([[results stringForColumn:@"commuter"] isEqualToString:@"Yes"]) college.commuter = @"Primarily a commuter college";
        else college.commuter = @"On campus housing available";
     
        // Works but cell was too crowded so took this off cell
        if ([[results stringForColumn:@"partTime"] isEqualToString:@"Yes"]) college.partTime = @"Primarily for Part-time students";
     
        // Cost 
        college.totalIn = [results stringForColumn:@"totalCostInState"];
        college.totalOut = [results stringForColumn:@"totalCostOutOfState"];
        college.tuitionOut = [results stringForColumn:@"tuitionCostOutOfState"];
        college.tuitionIn = [results stringForColumn:@"tuitionCostInState"];
     
        // Financial Aid
        college.gsA = [results stringForColumn:@"grantAA"];
        college.gsP = [results stringForColumn:@"grP"];
        college.slA = [results stringForColumn:@"slAA"];
        college.slP = [results stringForColumn:@"slP"];
     
        college.np030 = [results stringForColumn:@"anp030"];
        college.np3048 = [results stringForColumn:@"anp3048"];
        college.np4875 = [results stringForColumn:@"anp4875"];
        college.np75110 = [results stringForColumn:@"anp75110"];
        college.np110 = [results stringForColumn:@"anp110"];
     
        [self.masterDataArray addObject:college];
        
    } // while loop
     
    // close sql results
    [results close];
     
    // close database
    [db close];
    
    // NEW
    self.needsRefresh = @"NO";
}

-(void)createSortedArrays
{
    // searchArray
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:TRUE];
    [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    searchArray = [NSArray arrayWithArray:masterDataArray];
    
    // costArray
   if ([incomeLevel integerValue] == 0){
         NSSortDescriptor *costDescriptor = [[NSSortDescriptor alloc] initWithKey:@"i_030" ascending:TRUE];
        [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:costDescriptor]];
    } else if ([incomeLevel integerValue] == 1){
         NSSortDescriptor *costDescriptor = [[NSSortDescriptor alloc] initWithKey:@"i_3048" ascending:TRUE];
        [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:costDescriptor]];
    } else if ([incomeLevel integerValue] == 2){
         NSSortDescriptor *costDescriptor = [[NSSortDescriptor alloc] initWithKey:@"i_4875" ascending:TRUE];
        [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:costDescriptor]];
    } else if ([incomeLevel integerValue] == 3){
         NSSortDescriptor *costDescriptor = [[NSSortDescriptor alloc] initWithKey:@"i_75110" ascending:TRUE];
        [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:costDescriptor]];
    } else if ([incomeLevel integerValue] == 4){
         NSSortDescriptor *costDescriptor = [[NSSortDescriptor alloc] initWithKey:@"i_110" ascending:TRUE];
        [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:costDescriptor]];
    }

    costArray = [NSArray arrayWithArray:masterDataArray];
    
    // 
    NSSortDescriptor *usNewsUniversitiesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rankUSNews" ascending:TRUE];
    [masterDataArray sortUsingDescriptors:[NSArray arrayWithObject:usNewsUniversitiesDescriptor]];
    usNewsArray = [NSArray arrayWithArray:masterDataArray];
}

-(void)createSortedDictionaries
{
    // Cost
    for (College *college in costArray) {
       if ([incomeLevel integerValue] == 0){
            [[self.netCostSections objectForKey:college.si_netCost030] addObject:college];
        } else if ([incomeLevel integerValue] == 1){
            [[self.netCostSections objectForKey:college.si_netCost3048] addObject:college];
        } else if ([incomeLevel integerValue] == 2){
            [[self.netCostSections objectForKey:college.si_netCost4875] addObject:college];
        } else if ([incomeLevel integerValue] == 3){
            [[self.netCostSections objectForKey:college.si_netCost75110] addObject:college];
        } else if ([incomeLevel integerValue] == 4){
            [[self.netCostSections objectForKey:college.si_netCost110] addObject:college];
        }
    }
    
    // Alpha
    for (College *college in searchArray) {
        [[self.nameSections objectForKey:[[college.name substringToIndex:1] uppercaseString]] addObject:college];
    }
    
    // State
    for (College *college in searchArray) {
        [[self.stateSections objectForKey:[[college.state substringToIndex:1] uppercaseString]] addObject:college];
    }
    
    // Rank - USNews Universities
    for (College *college in usNewsArray) {
        [[self.rankUSNewsUniversitiesSections objectForKey:college.si_usNewsUniversities] addObject:college];
    }
}

// Data for DetailViewController
-(void)prepareCellDetails:(College *)college
{
    collegeNumber = college.number;
    collegeName = college.name;
    collegeControl = college.control;
    collegeCommuter = college.commuter;
    collegeSetting = college.setting;
    collegeSize = college.size;
    collegeRank = college.rank;
    collegeApplicants = college.applicants;
    collegeAdmitted = college.admitted;
    collegePercentAdmitted = college.percentAdmitted;
    collegeTuitionIn = college.tuitionIn;
    collegeTuitionOut = college.tuitionOut;
    collegeTotalIn = college.totalIn;
    collegeTotalOut = college.totalOut;
    
    collegeGsA = college.gsA;
    collegeGsP = college.gsP;
    collegeSlA = college.slA;
    collegeSlP = college.slP;
        
    collegeNp030 = college.np030;
    collegeNp3048 = college.np3048;
    collegeNp4875 = college.np4875;
    collegeNp75110 = college.np75110;
    collegeNp110 = college.np110;
    
    collegeRankForbesNational = college.rankForbesNational;
    collegeRankUSNewsLiberalArts = college.rankUSNewsLiberalArts;
    collegeRankUSNewsUniversities = college.rankUSNewsUniversities;
    collegeRetentionRate = college.retentionRate;
    collegeStudentFacultyRatio = college.studentFacultyRatio;
    
    // College's icon file is college number
    //NSString *collegeIconFile = [[NSString stringWithFormat:@"%d", college.number] stringByAppendingString:@".jpg"];
    //collegeIcon.image = [UIImage imageNamed:collegeIconFile];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If user presses on a college to see college details
    if ([[segue identifier] isEqualToString:@"Detail"]) {
        
        //NSLog(@"%@", NSStringFromClass([[segue destinationViewController] class]));
        
        // Create an instance of our DetailViewController
        DetailViewController *detailViewController = [[DetailViewController alloc]init];
        
        //Set the DVC to the destinationViewController property of the segue
        detailViewController = [segue destinationViewController];
    
        // Get the index path (for everything other than searchResultsController
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        // Determine the datasource
        if (self.searchDisplayController.isActive){
        //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
        //if ([searching isEqualToString:@"YES"]){
            // Get indexpath for searchDisplayController
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            College *college = [filteredTableData objectAtIndex:[indexPath row]];
            [self prepareCellDetails:college];
        } else if([sortSelected isEqualToString:@"name"]){
            College *college = [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            [self prepareCellDetails:college];
        } else if ([sortSelected isEqualToString:@"state"]){
            College *college = [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            [self prepareCellDetails:college];
        } else if ([sortSelected isEqualToString:@"netCost"]){
            College *college = [[self.netCostSections valueForKey:[[[self.netCostSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            [self prepareCellDetails:college];
        } else if ([sortSelected isEqualToString:@"rankUSNewsUniversities"]){
            College *college = [[self.rankUSNewsUniversitiesSections valueForKey:[[[self.rankUSNewsUniversitiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            [self prepareCellDetails:college];
        } else if ([sortSelected isEqualToString:@"academic"]){
            College *college = [self.academicArray objectAtIndex:[indexPath row]];
            [self prepareCellDetails:college];
        }
        
        detailViewController.collegeNumber = collegeNumber;
        detailViewController.collegeName = collegeName;
        detailViewController.collegeControl = collegeControl;
        detailViewController.collegeCommuter = collegeCommuter;
        detailViewController.collegeRank = collegeRank;
        detailViewController.collegeSetting = collegeSetting;
        detailViewController.collegeSize = collegeSize;
        detailViewController.collegeApplicants = collegeApplicants;
        detailViewController.collegeAdmitted = collegeAdmitted;
        detailViewController.collegePercentAdmitted = collegePercentAdmitted;
        detailViewController.collegeTuitionIn = collegeTuitionIn;
        detailViewController.collegeTuitionOut = collegeTuitionOut;
        detailViewController.collegeTotalIn = collegeTotalIn;
        detailViewController.collegeTotalOut = collegeTotalOut;
        
        detailViewController.collegeGsA = collegeGsA;
        detailViewController.collegeGsP = collegeGsP;
        detailViewController.collegeSlA = collegeSlA;
        detailViewController.collegeSlP = collegeSlP;
        
        detailViewController.collegeNp030 = collegeNp030;
        detailViewController.collegeNp3048 = collegeNp3048;
        detailViewController.collegeNp4875 = collegeNp4875;
        detailViewController.collegeNp75110 = collegeNp75110;
        detailViewController.collegeNp110 = collegeNp110;
        
        detailViewController.collegeRankForbesNational = collegeRankForbesNational;
        detailViewController.collegeRankUSNewsLiberalArts = collegeRankUSNewsLiberalArts;
        detailViewController.collegeRankUSNewsUniversities = collegeRankUSNewsUniversities;
        detailViewController.collegeStudentFacultyRatio = collegeStudentFacultyRatio;
        detailViewController.collegeRetentionRate = collegeRetentionRate;
        
        detailViewController.collegeIcon = collegeIcon;
    }
}


@end
