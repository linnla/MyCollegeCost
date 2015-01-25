//
//  MasterViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "College.h"
#import "MasterCell.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "EntryViewController.h"
#import "SettingsViewController.h"
#import "DetailViewController.h"

@interface MasterViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *collegeIcon;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) NSString *searchCancelled;
@property (nonatomic, weak) NSString *searching;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
//@property (nonatomic, weak) IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic, strong) NSString *needsRefresh;
@property (nonatomic, strong) NSNumber *incomeLevel;
@property (nonatomic, strong) NSString *selectedSort;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIActionSheet *sortActionSheet;

@property (nonatomic, weak) NSString *sortSelected;

// Data structures for different sorts
@property (nonatomic, retain) NSMutableDictionary *nameSections;
@property (nonatomic, retain) NSMutableDictionary *stateSections;
@property (nonatomic, retain) NSMutableDictionary *netCostSections;
@property (nonatomic, retain) NSMutableDictionary *rankUSNewsUniversitiesSections;

@property (nonatomic, strong) NSMutableArray *filteredTableData;
@property (nonatomic, retain) NSArray *academicArray;
@property (nonatomic, retain) NSArray *searchArray;
@property (nonatomic, retain) NSArray *costArray;
@property (nonatomic, retain) NSArray *forbesArray;
@property (nonatomic, retain) NSArray *usNewsArray;
@property (nonatomic, retain) NSMutableArray *masterDataArray;
@property (nonatomic, retain) NSArray *rankUSNewsUniversitiesArray;
//@property (nonatomic, strong) NSString *sectionIndexTitle;

// Segue Properties
@property (nonatomic, strong) NSString *collegeNumber;
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSString *collegeControl;
@property (nonatomic, strong) NSString *collegeCommuter;
@property (nonatomic, strong) NSString *collegeRank;
@property (nonatomic, strong) NSString *collegeSetting;
@property (nonatomic, strong) NSString *collegeSize;

@property (nonatomic, strong) NSString *collegePercentAdmitted;
@property (nonatomic, strong) NSString *collegeAdmitted;
@property (nonatomic, strong) NSString *collegeApplicants;
@property (nonatomic, strong) NSString *collegeTuitionIn;
@property (nonatomic, strong) NSString *collegeTuitionOut;
@property (nonatomic, strong) NSString *collegeTotalIn;
@property (nonatomic, strong) NSString *collegeTotalOut;

@property (nonatomic, strong) NSString *collegeCityState;

@property (nonatomic, strong) NSString *collegeGsP;
@property (nonatomic, strong) NSString *collegeGsA;
@property (nonatomic, strong) NSString *collegeSlP;
@property (nonatomic, strong) NSString *collegeSlA;
@property (nonatomic, strong) NSString *collegeNp030;
@property (nonatomic, strong) NSString *collegeA030;
@property (nonatomic, strong) NSString *collegeNp3048;
@property (nonatomic, strong) NSString *collegeA3048;
@property (nonatomic, strong) NSString *collegeNp4875;
@property (nonatomic, strong) NSString *collegeA4875;
@property (nonatomic, strong) NSString *collegeNp75110;
@property (nonatomic, strong) NSString *collegeA75110;
@property (nonatomic, strong) NSString *collegeNp110;
@property (nonatomic, strong) NSString *collegeA110;

@property (nonatomic, strong) NSString *collegeRankUSNewsUniversities;
@property (nonatomic, strong) NSString *collegeRankUSNewsLiberalArts;
@property (nonatomic, strong) NSString *collegeRankForbesNational;
@property (nonatomic, strong) NSString *collegeStudentFacultyRatio;
@property (nonatomic, strong) NSString *collegeRetentionRate;

@property (nonatomic, strong) NSString *collegePartTime;

-(void)loadData:(NSString *)dataSort;
-(void)hideActivityViewer;

-(void)loadData;


@end
