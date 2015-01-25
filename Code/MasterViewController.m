//
//  MasterViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize tableView, segmentedControl;
@synthesize activityView, activityIndicator;
@synthesize searchArray, academicArray, filteredTableData, stateSections, nameSections;
@synthesize searchCancelled, sortSelected;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataOnMainFor:@"academic"];
    [self loadDataOnMainFor:@"name"];
    [self loadDataOnMainFor:@"state"];
    //[self createSearchButton];
    sortSelected = @"academic";
    
    // Keep this --- tableview delegates depend on it
    searchCancelled = @"YES";
}

-(void)viewWillAppear:(BOOL)animated
{
    // This hides searchBar upon entry into screen
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSearchButton
{
    UIImage* image = [UIImage imageNamed:@"searchButton.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:NO];
    
    [button addTarget:self action:@selector(searchIconButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

-(IBAction)sortActionSheetClicked
{
    UIActionSheet *sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Account to Delete"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:@"Delete All Accounts"
                               otherButtonTitles:@"Checking", @"Savings", @"Money Market", nil];
    // Show the sheet
    [sortActionSheet showInView:self.view];
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl
{
    //NSLog(@"indexDidChangeForSegmentedControl started");
    
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:{
            UIActionSheet *sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by..."
                                                                        delegate:self
                                                                 cancelButtonTitle:@"Cancel"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:@"Alpha", @"Rank", @"State", nil];
            // Display the actionSheet
            [sortActionSheet showFromToolbar:(UIToolbar *) self.view];
            break;
        }
        case 1:{
            //SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
            //[self.navigationController pushViewController:settingsViewController animated:YES];
            break;
        }
        case 2:{
            SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
            [self.navigationController pushViewController:settingsViewController animated:YES];
            break;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:{
            //NSLog(@"Alpha button clicked");
            sortSelected = @"name";
    
            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            
            // Reload the table
            [self.tableView reloadData];
            
            // Set screen to first row in table view
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
        case 1:
            //NSLog(@"Rank button clicked");
            sortSelected = @"academic";
            
            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            
            // Reload the table
            [self.tableView reloadData];
            
            // Set screen to first row in table view
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 2:
            //NSLog(@"State button clicked");
            sortSelected = @"state";
            
            // Change sort and save to user defaults --- selectedSort used in table delegate method to determine correct data structure
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sortSelected forKey:@"selectedSort"];
            [defaults synchronize];
            
            // Reload the table
            [self.tableView reloadData];
            
            // Set screen to first row in table view
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        case 3:
            NSLog(@"Cancel Button Clicked");
            break;
    }
}


#pragma mark - Search

// Search was extremely difficult to debug --- every setting here is required for search bar, search cancel, and search delete to operate correctly
// Even adding a tableview reload impacts search functionality

-(IBAction)searchButtonClicked
{
    //NSLog(self.searchDisplayController.active ? @"Yes" : @"No");
    
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


-(void)showActivityViewer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = appDelegate.window;
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
    
    [[[activityView subviews] objectAtIndex:0] startAnimating];
}

-(void)hideActivityViewer
{
    [[[activityView subviews] objectAtIndex:0] stopAnimating];
    [activityView removeFromSuperview];
    activityView = nil;
}

// Loads data on main thread --- used only for name sort in viewDidLoad
-(void)loadDataOnMainFor:(NSString *)dataSort
{
    if ([dataSort isEqual: @"name"]){
        [nameSections removeAllObjects];
        [searchArray removeAllObjects];
        [self createDictionaryIfNotExists:@"name"];
    }
    
    if ([dataSort isEqual: @"state"]){
        [stateSections removeAllObjects];
        [self createDictionaryIfNotExists:@"state"];
    }
    
    if ([dataSort isEqual: @"academic"]){
        [academicArray removeAllObjects];
        [self createMutableArrayIfNotExists:@"academic"];
    }
}

// Run loadDataFor in background --- used in viewDidAppear for academic and state
- (void)loadDataInBackground:(NSString *)dataSort {
    
    //Operation Queue init (autorelease)
    NSOperationQueue *queue = [NSOperationQueue new];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataFor:) object:dataSort];
    
    //Add the operation to the queue
    [queue addOperation:operation];
}

// Check to see if array exists before creating --- Not required, legacy code I didn't want to change
-(void)createMutableArrayIfNotExists:(NSString *)dataSort
{
    int objectsInArray = [academicArray count];
    if (objectsInArray == 0){
        
        // Setup array
        academicArray = [[NSMutableArray alloc] init];
        
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
        
        // search array gets created when name dictionary is created, searchArray is alpha sorted
        searchArray = [[NSMutableArray alloc] init];
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
        mySql = @"SELECT * FROM AMC WHERE rank != 999 ORDER BY rank ASC, name";
    }
    
    // Execute SQL query
    FMResultSet *results = [db executeQuery:mySql];
    
    while([results next])
    {
        // Setup the cell
        College *college = [[College alloc] init];
        college.name = [results stringForColumn:@"name"];
        college.rank = [results stringForColumn:@"rank"];
        college.cityState = [results stringForColumn:@"cityState"];
        
        // Unranked colleges have rank = 999, if unranked, leave rank field on cell blank
        if ([[results stringForColumn:@"rank"] isEqual: @"999"]){
            college.rank = @" ";
        } else {
        // Append Rank and a space in front of college rank
            college.rank = [@"Rank  " stringByAppendingString:[results stringForColumn:@"rank"]];
        }
        
        college.academicCategory = [results stringForColumn:@"academicCategory"];
        college.costCategory = [results stringForColumn:@"costCategory"];
        
        // Create details for college to be displayed in DetailTableViewController
        
        /*
        // First detail section
        model.state = [results stringForColumn:@"state"];
        model.cityState = [results stringForColumn:@"cityState"];
        model.url = [results stringForColumn:@"url"];
        
        // Basics section
        model.size = [results stringForColumn:@"size"];
        model.setting = [results stringForColumn:@"setting"];
        model.control = [results stringForColumn:@"control"];
        
        // Cost section
        model.totalCostOutOfState = [results stringForColumn:@"totalCostOutOfState"];
        model.totalCostInState = [results stringForColumn:@"totalCostInState"];
        model.tuitionCostOutOfState = [results stringForColumn:@"tuitionCostOutOfState"];
        model.tuitionCostInState = [results stringForColumn:@"tuitionCostInState"];
        
        // Admissions section
        model.applicants = [results stringForColumn:@"applicants"];
        model.admits = [results stringForColumn:@"admitted"];
        model.percentAdmit = [results stringForColumn:@"percentAdmitted"];
        
        // Test Scores sections
        
        // SAT
        model.satM25 = [results stringForColumn:@"satM25"];
        model.satM75 = [results stringForColumn:@"satM75"];
        model.satR25 = [results stringForColumn:@"satR25"];
        model.satR75 = [results stringForColumn:@"satR75"];
        model.satW25 = [results stringForColumn:@"satW25"];
        model.satW75 = [results stringForColumn:@"satW75"];
        
        //ACT
        model.actM25 = [results stringForColumn:@"actM25"];
        model.actM75 = [results stringForColumn:@"actM75"];
        model.actE25 = [results stringForColumn:@"actE25"];
        model.actE75 = [results stringForColumn:@"actE75"];
        model.actW25 = [results stringForColumn:@"actW25"];
        model.actW75 = [results stringForColumn:@"actW75"];
        model.actC25 = [results stringForColumn:@"actC25"];
        model.actC75 = [results stringForColumn:@"actC75"];
         */
        
        if ([dataSort isEqualToString:@"name"]){
            
            // Add array of college data to section index dictionary --- dictionary of arrays
            [[self.nameSections objectForKey:[[[results stringForColumn:@"name"] substringToIndex:1] uppercaseString]] addObject:college];
            
            // Add array of college data to searchArray --- serachArray get setup sametime as name dictionary becuase both are alpha sorted
            [self.searchArray addObject:college];
        }
        
        if ([dataSort isEqualToString:@"state"]){
            
            // Add array of college data to section index dictionary --- dictionary of arrays
            [[self.stateSections objectForKey:[[[results stringForColumn:@"state"] substringToIndex:1] uppercaseString]] addObject:college];
        }
        
        // Add array of college data to academic Array --- academic array used for Rank sort
        if ([dataSort isEqualToString:@"academic"]) [self.academicArray addObject:college];
        
    } // while loop
    
    // close sql results
    [results close];
    
    // close database
    [db close];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])) return [self.filteredTableData count];
    else if ([sortSelected isEqualToString:@"name"]) return [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    else if ([sortSelected isEqualToString:@"state"]) return [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    else if ([sortSelected isEqualToString: @"academic"]) return [academicArray count];
    
    else return 0;
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

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Setup view and background color
    //UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SectionHeaderBlueDark.png"]];
    
    // Setup look of header titles
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    headerText.backgroundColor=[UIColor clearColor];
    headerText.shadowColor = [UIColor blackColor];
    headerText.shadowOffset = CGSizeMake(0,2);
    headerText.textColor = [UIColor whiteColor];
    headerText.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    
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
*/

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRow started");
    
    static NSString *CellIdentifier = @"MasterCell";
    
    // Need to use this to stay backward compatible with iOS < 6.0
    // This didn't allow the search display controller to display data
    MasterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Works only in iOS version 6.0 and above for self.tableview and search display controller
    //MasterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Determine the datasource and create a Mastercell with the object
    if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
        College *college = [filteredTableData objectAtIndex:[indexPath row]];
        
        // The cell is customized in MasterCell
        [cell setCellDetailsForCollege:college];
        
        // Determine correct data source and create a Mastercell
    } else if([sortSelected isEqualToString:@"name"]){
        NSDictionary *nameDictionary = [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [cell setCellDetailsForCollege:nameDictionary];
        
    } else if ([sortSelected isEqualToString:@"state"]){
        NSDictionary *stateDictionary = [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [cell setCellDetailsForCollege:stateDictionary];
        
    } else if ([sortSelected isEqualToString:@"academic"]){
        College *college = [academicArray objectAtIndex:[indexPath row]];
        [cell setCellDetailsForCollege:college];
    }
    //NSLog(@"cellForRow finished");
    //[self.tableView reloadData];
    
    return cell;
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MasterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Determine the datasource and create a Mastercell with the object
    //if ((self.searchDisplayController.isActive) && ([searchCancelled isEqualToString: @"NO"])){
    if ([searchCancelled isEqualToString:@"NO"]) {
        College *college = [filteredTableData objectAtIndex:[indexPath row]];
        // The cell is customized in MasterCell
        [cell setCellDetailsForCollege:college];
    }
    else if ([sortSelected isEqualToString:@"academic"]){
        College *college = [academicArray objectAtIndex:[indexPath row]];
        [cell setCellDetailsForCollege:college];
    }
    else if ([sortSelected isEqualToString:@"name"]){
        NSDictionary *nameDictionary = [[self.nameSections valueForKey:[[[self.nameSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [cell setCellDetailsForCollege:nameDictionary];
    }
    else if ([sortSelected isEqualToString:@"state"]){
        NSDictionary *stateDictionary = [[self.stateSections valueForKey:[[[self.stateSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [cell setCellDetailsForCollege:stateDictionary];
    }
    return cell;
}

//Search Methods look at this setting rather than row height set in storyBoard
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
