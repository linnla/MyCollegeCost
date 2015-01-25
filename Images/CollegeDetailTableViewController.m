//
//  CollegeDetailTableViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/8/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "CollegeDetailTableViewController.h"

@interface CollegeDetailTableViewController ()

@end

@implementation CollegeDetailTableViewController

@synthesize name, cityState, rank, commuter, partTime;
@synthesize control, setting, size, percentAdmitted, admitted, applicants, tuitionIn, tuitionOut, totalIn, totalOut;
@synthesize gsA, gsP, slA, slP, np030, np110, np3048, np4875, np75110, a030, a110, a3048, a4875, a75110;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = NO;
    
    [self getCollegeDetails];
    
    // Set background for tableview
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BackgroundBlueParchment.png"]];
    self.tableView.backgroundColor = background;
}


-(void)getCollegeDetails
{
    // Set the database path
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writableDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    // Open the database
    [db open];
    
    // Create the SQL statements
    NSString *mySql = [[NSString alloc] init];
    
    mySql = [[@"SELECT * FROM AMC WHERE name = '" stringByAppendingString:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCollege"]] stringByAppendingString:@"'"];
    
    //NSLog(@"mySql = %@", mySql);
    
    // Execute SQL query
    FMResultSet *results = [db executeQuery:mySql];

    while([results next])
    {
        self.name.text = [results stringForColumn:@"name"];
        self.control.text = [results stringForColumn:@"control"];
        self.size.text = [results stringForColumn:@"size"];
        self.setting.text = [results stringForColumn:@"setting"];
        self.rank.text = [results stringForColumn:@"rank"];
        
        // If commuter filed = Yes, set commuter field in cell
        if ([[results stringForColumn:@"commuter"] isEqualToString:@"Yes"]) self.commuter.text = @"Primarily a commuter college";
        else self.commuter.text = @"On campus housing available ";
        
        // Works but cell was too crowded so took this off cell
        if ([[results stringForColumn:@"partTime"] isEqualToString:@"Yes"]) self.partTime.text = @"Primarily for Part-time students";
        else self.partTime.text = @" ";
        
        // Convert strings to strings formated as numbers
        applicants.text = [self formatStringToNumber:[results stringForColumn:@"applicants"]];
        admitted.text = [self formatStringToNumber:[results stringForColumn:@"admitted"]];
        
        // Calculate percent admitted
        float apply = [[NSDecimalNumber decimalNumberWithString:[self formatStringToNumber:[results stringForColumn:@"applicants"]]]floatValue];
        float admit = [[NSDecimalNumber decimalNumberWithString:[self formatStringToNumber:[results stringForColumn:@"admitted"]]]floatValue];
        float percent = (admit / apply);
        NSNumber *myPercent = [NSNumber numberWithFloat:percent];
        
        // Setup the number formatter
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [numberFormatter setLocale:usLocale];

        // Format percent admitted to NSString
        percentAdmitted.text = [numberFormatter stringFromNumber:myPercent];
        //NSLog(@"en_US: %@", [numberFormatter stringFromNumber:myPercent]);
        
        // Convert strings to strings formatted as currency
        totalOut.text = [self formatStringToCurrency:[results stringForColumn:@"totalCostOutOfState"]];
        totalIn.text = [self formatStringToCurrency:[results stringForColumn:@"totalCostInState"]];
        tuitionOut.text = [self formatStringToCurrency:[results stringForColumn:@"tuitionCostOutOfState"]];
        tuitionIn.text = [self formatStringToCurrency:[results stringForColumn:@"tuitionCostInState"]];
        
        // Financial Aid
        gsA.text = [self formatStringToCurrency:[results stringForColumn:@"grantAA"]];
        gsP.text = [self formatStringToPercent:[results stringForColumn:@"grP"]];
        slA.text = [self formatStringToCurrency:[results stringForColumn:@"slAA"]];
        slP.text = [self formatStringToPercent:[results stringForColumn:@"slP"]];
        
        a030.text = [self formatStringToCurrency:[results stringForColumn:@"gs030AA"]];
        a3048.text = [self formatStringToCurrency:[results stringForColumn:@"gs3048AA"]];
        a4875.text = [self formatStringToCurrency:[results stringForColumn:@"gs4875AA"]];
        a75110.text = [self formatStringToCurrency:[results stringForColumn:@"gs75110AA"]];
        a110.text = [self formatStringToCurrency:[results stringForColumn:@"gs110AA"]];
        
        np030.text = [self formatStringToCurrency:[results stringForColumn:@"anp030"]];
        np3048.text = [self formatStringToCurrency:[results stringForColumn:@"anp3048"]];
        np4875.text = [self formatStringToCurrency:[results stringForColumn:@"anp4875"]];
        np75110.text = [self formatStringToCurrency:[results stringForColumn:@"anp75110"]];
        np110.text = [self formatStringToCurrency:[results stringForColumn:@"anp110"]];
    }

    //NSLog(@"getCollegeDetails end");
    // close sql results
    [results close];

    // close database
    [db close];

}

// Used to convert 1000 to $1,000
- (NSString *)formatStringToCurrency:(NSString *)myString
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
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
    [numberStyle setNumberStyle:NSNumberFormatterPercentStyle];
    [numberStyle setLocale:[NSLocale currentLocale]];
    
    float percent = ([myString floatValue] / 100);
    NSNumber *amount = [NSNumber numberWithFloat:percent];
    
    //NSLog(@"Percentage as float: %f",[myString floatValue]);
    //NSLog(@"Percentage converted: %@",amount);
    
    return [numberStyle stringFromNumber:amount];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;*/
}

@end
