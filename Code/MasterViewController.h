//
//  MasterViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "College.h"
#import "MasterCell.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SettingsViewController.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDataSource, UIActionSheetDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (weak, nonatomic) UIActionSheet *sortActionSheet;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityView;


@property (weak, nonatomic) NSString *searchCancelled;
@property (weak, nonatomic) NSString *sortSelected;

// Data structures for different sorts
@property (nonatomic, strong) NSMutableArray* filteredTableData;
@property (nonatomic, retain) NSMutableDictionary* nameSections;
@property (nonatomic, retain) NSMutableDictionary* stateSections;
@property (nonatomic, retain) NSMutableArray *academicArray;
@property (nonatomic, retain) NSMutableArray* searchArray;

-(void)loadDataOnMainFor:(NSString *)dataSort;
-(IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl;
-(void)hideSearchBar;
-(void)createSearchButton;
-(IBAction)searchButtonClicked;

@end
