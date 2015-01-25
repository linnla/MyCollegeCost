//
//  CollegeDetailTableViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/8/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "AppDelegate.h"

@interface CollegeDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cityState;
@property (weak, nonatomic) IBOutlet UILabel *control;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *setting;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *percentAdmitted;
@property (weak, nonatomic) IBOutlet UILabel *admitted;
@property (weak, nonatomic) IBOutlet UILabel *applicants;
@property (weak, nonatomic) IBOutlet UILabel *tuitionIn;
@property (weak, nonatomic) IBOutlet UILabel *tuitionOut;
@property (weak, nonatomic) IBOutlet UILabel *totalIn;
@property (weak, nonatomic) IBOutlet UILabel *totalOut;
@property (weak, nonatomic) IBOutlet UILabel *gsP;
@property (weak, nonatomic) IBOutlet UILabel *gsA;
@property (weak, nonatomic) IBOutlet UILabel *slP;
@property (weak, nonatomic) IBOutlet UILabel *slA;
@property (weak, nonatomic) IBOutlet UILabel *np030;
@property (weak, nonatomic) IBOutlet UILabel *a030;
@property (weak, nonatomic) IBOutlet UILabel *np3048;
@property (weak, nonatomic) IBOutlet UILabel *a3048;
@property (weak, nonatomic) IBOutlet UILabel *np4875;
@property (weak, nonatomic) IBOutlet UILabel *a4875;
@property (weak, nonatomic) IBOutlet UILabel *np75110;
@property (weak, nonatomic) IBOutlet UILabel *a75110;
@property (weak, nonatomic) IBOutlet UILabel *np110;
@property (weak, nonatomic) IBOutlet UILabel *a110;
@property (weak, nonatomic) IBOutlet UILabel *commuter;
@property (weak, nonatomic) IBOutlet UILabel *partTime;

@end
