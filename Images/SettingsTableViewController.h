//
//  SettingsTableViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollegeViewController.h"

@interface SettingsTableViewController : UITableViewController

@property (nonatomic, strong) NSNumber *incomeLevelSelected;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

-(void)saveDefaultForIncomeLevel:(NSObject *)newDefaultValue;
-(void)runMethodInBackground:(NSObject *)method methodParameter:(NSObject *)parameter;

@end
