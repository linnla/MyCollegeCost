//
//  StatesViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatesViewController : UIViewController

@property (nonatomic, strong) NSArray *statesArray;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSString *selectedState;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end