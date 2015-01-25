//
//  SettingsContainerViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/6/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterCell.h"
#import "SettingsTableViewController.h"

@interface SettingsContainerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void)calculateButtonClicked;

@end
