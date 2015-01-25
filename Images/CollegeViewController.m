//
//  CollegeViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//
/*  SearchBar implementation notes
In storyboard, in order for searchBar to hide correctly and for bannerView to appear, this is the object layer order (create the objects in this order) ViewController --> View --> navigation item segmenteControl on navigation bar as titleView --> navigation item searchButton on right --> TableView --> searchBar in tableView header.  Create the objects in this order and the searchBar will appear/disappear on app entry.  viewDidAppear has the only scrollToRow command outside of the search methods.  self.tableview reload is in viewWillAppear.
 
 BannerView also displays across all screen with this configuration.
*/


#import "CollegeViewController.h"

@interface CollegeViewController ()

@end

@implementation CollegeViewController

@synthesize tableView, searchCancelled, segmentedControl, activityIndicator, activityView, sortSelected, needsRefresh, incomeLevel, spinner;
@synthesize filteredTableData, nameSections, stateSections, academicArray, searchArray, selectedSort, sortActionSheet, costArray, forbesArray, usNewsArray, costSections, sectionIndexTitle;

// Segue Properties
@synthesize collegeName, collegeControl, collegeCommuter;

@synthesize collegeCityState, collegeRank, collegeSetting, collegeSize, collegePercentAdmitted, collegeAdmitted, collegeApplicants, collegeTuitionIn, collegeTuitionOut, collegeTotalIn, collegeTotalOut, collegePartTime, collegeGsA, collegeGsP, collegeSlA, collegeSlP, collegeA030, collegeA110, collegeA3048, collegeA4875, collegeA75110, collegeNp030, collegeNp110, collegeNp3048, collegeNp4875, collegeNp75110, collegeRankForbesNational, collegeRankUSNewsLiberalArts, collegeRankUSNewsUniversities, collegeStudentFacultyRatio, collegeRetentionRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// This executes at app startup and when user presses "calculate" or "reset" button
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    searchCancelled = @"YES";
    
    incomeLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"incomeLevel"];
    selectedSort = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSort"];
    
    if ([selectedSort isEqualToString:@"academic"]) {
        sortSelected = @"academic";
        
        [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        [academicArray removeAllObjects];
        [costArray removeAllObjects];
        [searchArray removeAllObjects];
        [filteredTableData removeAllObjects];
        [nameSections removeAllObjects];
        [stateSections removeAllObjects];
    
        [self loadData:@"academic"];
        [self loadData:@"name"];
        [self loadDataInBackground:@"state"];
        
        [self hideActivityViewer];
    } else if ([selectedSort isEqualToString:@"cost"]) {
            sortSelected = @"cost";
            
            [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
            
            [academicArray removeAllObjects];
            [costArray removeAllObjects];
            [searchArray removeAllObjects];
            [filteredTableData removeAllObjects];
            [nameSections removeAllObjects];
            [stateSections removeAllObjects];
        
            [self loadData:@"name"];
            [self loadData:@"academic"];
        
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"computedNetCost" ascending:TRUE];
        
            [costArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
            [self loadDataInBackground:@"state"];
        
            [self hideActivityViewer];

    } else if ([selectedSort isEqualToString:@"name"]) {
        sortSelected = @"name";
        
        [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        [academicArray removeAllObjects];
        [costArray removeAllObjects];
        [searchArray removeAllObjects];
        [filteredTableData removeAllObjects];
        [nameSections removeAllObjects];
        [stateSections removeAllObjects];
        
        [self loadData:@"name"];
        [self loadData:@"academic"];
        [self loadDataInBackground:@"state"];

        [self hideActivityViewer];
    } else if ([selectedSort isEqualToString:@"state"]) {
        sortSelected = @"state";
        [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        [academicArray removeAllObjects];
        [costArray removeAllObjects];
        [searchArray removeAllObjects];
        [filteredTableData removeAllObjects];
        [nameSections removeAllObjects];
        [stateSections removeAllObjects];
        
        [self loadData:@"state"];
        [self loadData:@"academic"];
        [self loadDataInBackground:@"name"];
        
        [self hideActivityViewer];
    }
    [self createBarButtons];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    UIActionSheet *sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by..."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Alpha", @"Cost", @"Rank", @"State", nil];
    // Display the actionSheet
    [sortActionSheet showFromToolbar:(UIToolbar *) self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:{
            //NSLog(@"State button clicked");
            sortSelected = @"name";
            
            int objectsInNameDictionary = [nameSections count];
            if (objectsInNameDictionary == 0){
                [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
                
                [self performSelector:@selector(loadData:) withObject:@"name" afterDelay:1];
                [self performSelector:@selector(hideActivityViewer) withObject:nil afterDelay:1];
            } else {
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            break;
        }
        case 1:{
            NSLog(@"Cost button clicked");
            
            sortSelected = @"cost";
            
            int objectsInArray = [costArray count];
            if (objectsInArray == 0){
                [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
                
                [self performSelector:@selector(loadData:) withObject:@"name" afterDelay:1];
                [self performSelector:@selector(hideActivityViewer) withObject:nil afterDelay:1];
            } else {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"computedNetCost" ascending:TRUE];
                
                [costArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            break;
        }
        case 2:{
            //NSLog(@"Rank button clicked");
            
            sortSelected = @"academic";
            
            int objectsInArray = [academicArray count];
            if (objectsInArray == 0){
                [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
                
                [self performSelector:@selector(loadData:) withObject:@"academic" afterDelay:1];
                [self performSelector:@selector(hideActivityViewer) withObject:nil afterDelay:1];
            } else {
                //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rankUSNews" ascending:FALSE];
                                
                //[academicArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            break;
        }
        case 3:{
            //NSLog(@"State button clicked");
            sortSelected = @"state";
            
            int objectsInStateDictionary = [stateSections count];
            if (objectsInStateDictionary == 0){
                [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
                
                [self performSelector:@selector(loadData:) withObject:@"state" afterDelay:1];
                [self performSelector:@selector(hideActivityViewer) withObject:nil afterDelay:1];
            } else {
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            break;
        }
        case 4:{
            //NSLog(@"Cancel Button Clicked");
            break;
        }
    }
}

#pragma mark -- Search

//From original project -- searchBar hidden at entry, not hidden when searchButton clicked
-(IBAction)searchButtonClicked
{
    //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
    //NSLog( @"%f", self.tableView.contentOffset.y);
    
    //int objectsInDictionary = [nameSections count];
    //if (objectsInDictionary == 0){
      //  [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        //[self performSelector:@selector(loadData:) withObject:@"name" afterDelay:1];
       // [self performSelector:@selector(hideActivityViewer) withObject:nil afterDelay:1];
    //}

    // If search bar is already displayed, or search display controller is active
    // Discovered in debug that searchDisplayController appears to never be active
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
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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
        
        // Set search controller to not active --- NEW
        //self.searchDisplayController.active = YES;
        NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
        
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
    NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
    
    //NSLog(@"numberOfSectionsInTableView started");
    
    // Determine correct data source
    // Is user doing a search
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return 1;
    else if ([sortSelected isEqualToString: @"name"])
    {
        //NSLog(@"numberOfSectionsInTableView = %lu", (unsigned long)[[self.nameSections allKeys] count]);
        return [[self.nameSections allKeys] count];
    }
    else if ([sortSelected isEqualToString: @"state"])return [[self.stateSections allKeys] count];
    else if ([sortSelected isEqualToString: @"academic"])return 1;
    else if ([sortSelected isEqualToString: @"cost"])return 1;
    
    else return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection started, no finsih message will come");
    
    // Determine correct data source
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return nil;
    else if ([sortSelected isEqualToString:@"name"]) return [[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    else if ([sortSelected isEqualToString:@"state"]) return [[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
    else return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection started, no finsih message will come");
    
    // Determine correct data source
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
        //NSLog(@"ris filterTableDataSections count is: %d", [filteredTableData count]);
        
        return [self.filteredTableData count];
        
        
    } else if ([sortSelected isEqualToString:@"name"]){
        //NSLog(@"ris nameSections count is: %d", [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count]);
              
        return [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
        
    } else if ([sortSelected isEqualToString:@"state"]){
        //NSLog(@"ris stateSections count is: %d", [[self.stateSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count]);
        
        return [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        
        
    } else if ([sortSelected isEqualToString: @"academic"]){
        //NSLog(@"ris academicArray count is: %d", [academicArray count]);
        return [academicArray count];
        
    } else if ([sortSelected isEqualToString: @"cost"]){
        return [costArray count];
    }
    else return 0;
}

//Search Methods look at this setting rather than row height set in storyBoard
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //NSLog(@"sectionIndexTitles started, no finsih message will come");
    
    // Determine correct data source
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return nil;
    else if ([sortSelected isEqualToString: @"name"]) return [[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([sortSelected isEqualToString:@"state"]) return [[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    else return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Setup view and background color
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight)];
    
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundBrownSmoothTexture.png"]];
    
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
    
    // Determine the datasource and create a Mastercell with the object
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
        //NSLog(@"cfr filteredTableData count is: %d", [filteredTableData count]);
        College *college = [filteredTableData objectAtIndex:[indexPath row]];
        // The cell is customized in MasterCell
        
        [cell setCellDetailsForCollege:college];
    }
    else if ([sortSelected isEqualToString:@"academic"]){
        //NSLog(@"cfr academicArray count is: %d", [academicArray count]);
        College *college = [academicArray objectAtIndex:[indexPath row]];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"cost"]){
        //NSLog(@"cfr costArray count is: %d", [costArray count]);
        College *college = [costArray objectAtIndex:[indexPath row]];
        
        [cell setCellDetailsForCollege:college];
    } else if ([sortSelected isEqualToString:@"name"]){
        //NSLog(@"cfr nameSections count is: %d", [nameSections count]);
        College *college = [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [cell setCellDetailsForCollege:college];
    }
    else if ([sortSelected isEqualToString:@"state"]){
        //NSLog(@"cfr stateSections count is: %d", [stateSections count]);
        College *college = [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
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
-(void)loadData:(NSString *)dataSort
{
    if ([dataSort isEqual: @"name"]) [self createDictionaryIfNotExists:@"name"];
    
    if ([dataSort isEqual: @"state"])[self createDictionaryIfNotExists:@"state"];
    
    if ([dataSort isEqual: @"cost"]) [self createMutableArrayIfNotExists:@"cost"];
    
    if ([dataSort isEqual: @"academic"]) [self createMutableArrayIfNotExists:@"academic"];
}

// Run loadDataFor in background --- used in viewDidAppear for academic and state
-(void)loadDataInBackground:(NSString *)dataSort {
    
    //Operation Queue init (autorelease)
    NSOperationQueue *queue = [NSOperationQueue new];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadData:) object:dataSort];
    
    //Add the operation to the queue
    [queue addOperation:operation];
}

// Check to see if array exists before creating --- Not required, legacy code I didn't want to change
-(void)createMutableArrayIfNotExists:(NSString *)dataSort
{
    int objectsInArray = [academicArray count];
    if (objectsInArray == 0){
        
        // Setup array
        if ([dataSort isEqualToString:@"academic"]) academicArray = [[NSMutableArray alloc] init];
        else if ([dataSort isEqualToString:@"cost"]) costArray = [[NSMutableArray alloc] init];
        
        // load colleges into array
        [self populateColleges:dataSort];
    }
}

// Check to see if dictionary exists before creating --- Not required, legacy code I didn't want to change
-(void)createDictionaryIfNotExists:(NSString *)dataSort
{
    if ([dataSort isEqual: @"name"]) {
        int objectsInDictionary = [nameSections count];
        if (objectsInDictionary == 0){
            
            // create sections for dictionary
            [self createSectionsForDictionary:dataSort];
        }
    }
    
    if ([dataSort isEqual: @"state"]) {
        int objectsInDictionary = [stateSections count];
        if (objectsInDictionary == 0){
            
            // create sections for dictionary
            [self createSectionsForDictionary:dataSort];
        }
    }
}

-(void)createSectionsForDictionary:(NSString *)dataSort
{
    // Set db path and open db
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writableDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    [db open];
    
    // Alloc init sql statement string
    NSString *mySql = [[NSString alloc] init];
    
    if ([dataSort isEqual: @"name"]) {
        
        // set the sql statement --- get distinct name to create name section indexes
        mySql = @"SELECT DISTINCT name FROM AMC ORDER BY name";
        
        // setup the dictionary
        self.nameSections = [[NSMutableDictionary alloc] init];
        
        // search and cost array's gets created when name dictionary is created, searchArray is alpha sorted
        searchArray = [[NSMutableArray alloc] init];
        costArray = [[NSMutableArray alloc] init];
    }
    
    if ([dataSort isEqual: @"state"]) {
        
        // set the sql statement --- get distinct name to create name section indexes
        mySql = @"SELECT DISTINCT state FROM AMC ORDER BY state";
        
        // setup the dictionary
        self.stateSections = [[NSMutableDictionary alloc] init];
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
        }
    }
    
    // close sql results
    [results close];
    
    // close database
    [db close];
    
    // After section dictionaries are created, add colleges to correct section
    [self populateColleges:dataSort];
}

-(void)populateColleges:(NSString *)dataSort
{
    NSLog(@"populateColleges started for: %@",dataSort);
    
    // Set the database path
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writableDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    // Open the database
    [db open];
    
    // Create the SQL statements
    NSString *mySql = [[NSString alloc] init];
    
    // Sort the results of sql statement by college name
    if ([dataSort isEqual: @"name"]) {
        mySql = @"SELECT * FROM AMC ORDER BY name";
        
        // POSSIBLE CHANGE --- ORDER BY STATE THEN NAME OF COLLEGE
    } else if ([dataSort isEqual: @"state"]) {
        mySql = @"SELECT * FROM AMC ORDER BY state, name";
        
        // Rank sort only shows ranked colleges, unranked colleges have rank = 999
    } else if ([dataSort isEqual: @"academic"]) {
        //mySql = @"SELECT * FROM AMC WHERE rank != 999 ORDER BY rank ASC, name";
        mySql = @"SELECT * FROM AMC WHERE rankedCollege = 1 ORDER BY rankUSNewsUniversities asc, name";
        
        // For testing purposes --- smaller dataset
        //mySql = @"SELECT * FROM AMC WHERE rank <= 3 ORDER BY rank ASC, name";
    } else if ([dataSort isEqual: @"cost"]) {
        //mySql = @"SELECT * FROM AMC ORDER BY name";
        mySql = @"SELECT * FROM AMC";
    }
    
    // Execute SQL query
    FMResultSet *results = [db executeQuery:mySql];
    
    while([results next])
    {
        // Setup the cell
        
        // Basics
        College *college = [[College alloc] init];
        //college.number = [results intForColumn:@"unitid"];
        
        //NSInteger intNumber = [results intForColumn:@"unitid"];
        NSNumber *pointerNumber = [NSNumber numberWithInt:[results intForColumn:@"unitid"]];
        college.number = [pointerNumber stringValue];
        
        college.name = [results stringForColumn:@"name"];
        college.cityState = [results stringForColumn:@"cityState"];
        college.size = [results stringForColumn:@"size"];
        college.setting = [results stringForColumn:@"setting"];
        college.control = [results stringForColumn:@"control"];
        
        // Ratios
        college.retentionRate = [results stringForColumn:@"retentionRate"];
        college.studentFacultyRatio = [results stringForColumn:@"studentFacultyRatio"];
        
        // Rank
        college.rankUSNews = [results intForColumn:@"rankUSNewsUniversities"];
        college.rankForbes = [results intForColumn:@"rankForbesNational"];
        
        int rankUSNewsLiberalArts = [results intForColumn:@"rankUSNewsLiberalArts"];
        int rankUSNewsUniversities = [results intForColumn:@"rankUSNewsUniversities"];
        int rankForbesNational = [results intForColumn:@"rankForbesNational"];
        
        if (rankUSNewsLiberalArts == 999) college.rankUSNewsLiberalArts = @"Unranked";
        else college.rankUSNewsLiberalArts = [NSString stringWithFormat:@"%d", rankUSNewsLiberalArts];
        
        if (rankUSNewsUniversities == 999){
            college.rankUSNewsUniversities = @"Unranked";
            college.rank = @" ";
        } else {
            college.rankUSNewsUniversities = [NSString stringWithFormat:@"%d", rankUSNewsUniversities];
            college.rank = [@"#" stringByAppendingString: [NSString stringWithFormat:@"%d", rankUSNewsUniversities]];
            //college.rank = [@"US News Rank " stringByAppendingString: [NSString stringWithFormat:@"%d", rankUSNewsUniversities]];
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
                    if ([[results stringForColumn:@"anp030"] isEqualToString:@"999999"]){
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
         
         // Cost section
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
        
        // Add Data To Dictionary or Array
        if ([dataSort isEqualToString:@"name"]){
            
            // Add array of college data to section index dictionary --- dictionary of arrays
            [[self.nameSections objectForKey:[[[results stringForColumn:@"name"] substringToIndex:1] uppercaseString]] addObject:college];
            
            // Add array of college data to searchArray --- searchArray get setup sametime as name dictionary becuase both are alpha sorted
            [self.costArray addObject:college];
            [self.searchArray addObject:college];
        }
        
        if ([dataSort isEqualToString:@"state"]){
            
            // Add array of college data to section index dictionary --- dictionary of arrays
            [[self.stateSections objectForKey:[[[results stringForColumn:@"state"] substringToIndex:1] uppercaseString]] addObject:college];
        }
        
        // Add array of college data to academic Array --- academic array used for Rank sort
        if ([dataSort isEqualToString:@"academic"]) [self.academicArray addObject:college];

        
    } // while loop
    
    // Debug Code
    //NSLog(@"mySql = %@", mySql);
    NSLog(@"populateColleges finished for: %@",dataSort);
    
    // close sql results
    [results close];
    
    // close database
    [db close];
    
    // NEW
    self.needsRefresh = @"NO";
}

// Used to convert 1000 to $1,000
- (NSString *)formatStringToCurrency:(NSString *)myString
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [currencyStyle setLocale:usLocale];
    
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setUsesGroupingSeparator:YES];
    [currencyStyle setGroupingSeparator:@","];
    [currencyStyle setGroupingSize:3];
    [currencyStyle setMaximumFractionDigits:0];
    
    // Convert string to number
    NSNumber *amount = [NSNumber numberWithInteger:[myString integerValue]];
    
    // Format the number and return as a string
    return [currencyStyle stringFromNumber:amount];
}

// Used to convert 1000 to 1,000
- (NSString *)formatStringToNumber:(NSString *)myString
{
    // alloc formatter
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [numberStyle setLocale:usLocale];
    
    [numberStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberStyle setUsesGroupingSeparator:YES];
    [numberStyle setGroupingSeparator:@","];
    [numberStyle setGroupingSize:3];
    [numberStyle setMaximumFractionDigits:0];
    
    // Convert string to number
    NSNumber *amount = [NSNumber numberWithInteger:[myString integerValue]];
    
    // Format the number and return as a string
    return [numberStyle stringFromNumber:amount];
}

// Used to convert 10 to 10%
- (NSString *)formatStringToPercent:(NSString *)myString
{
    // alloc formatter
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [numberStyle setLocale:usLocale];
    
    [numberStyle setNumberStyle:NSNumberFormatterPercentStyle];
    
    float percent = ([myString floatValue] / 100);
    NSNumber *amount = [NSNumber numberWithFloat:percent];
    
    //NSLog(@"Percentage as float: %f",[myString floatValue]);
    //NSLog(@"Percentage converted: %@",amount);
    
    return [numberStyle stringFromNumber:amount];
}

// Data for DetailViewController
-(void)prepareCellDetails:(College *)college
{
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
        
        } else if ([sortSelected isEqualToString:@"academic"]){
            College *college = [academicArray objectAtIndex:[indexPath row]];
            [self prepareCellDetails:college];
            
        } else if ([sortSelected isEqualToString:@"cost"]){
            College *college = [costArray objectAtIndex:[indexPath row]];
            [self prepareCellDetails:college];
        }

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
    }
}


@end
