//
//  SettingsViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollegeViewController.h"
#import "MasterViewController.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) NSNumber *incomeLevelSelected;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property int lastSelected;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *incomeArray;

-(void)saveDefaultForIncomeLevel:(NSObject *)newDefaultValue;
-(void)runMethodInBackground:(NSObject *)method methodParameter:(NSObject *)parameter;

@end
