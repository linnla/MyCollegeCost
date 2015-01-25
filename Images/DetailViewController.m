//
//  DetailViewController.m
//  MasterDetail
//
//  Created by Laure Linn on 3/13/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize scrollView;

// IBOutlets
@synthesize name, cityState, rank, commuter, partTime, collegeNumber;
@synthesize control, setting, size, percentAdmitted, admitted, applicants, tuitionIn, tuitionOut, totalIn, totalOut;
@synthesize gsA, gsP, slA, slP, np030, np110, np3048, np4875, np75110, a030, a110, a3048, a4875, a75110;

// Segue Properties
@synthesize collegeName, collegeControl, collegeCommuter, collegeIcon;

@synthesize collegeCityState, collegeRank, collegeSetting, collegeSize, collegePercentAdmitted, collegeAdmitted, collegeApplicants, collegeTuitionIn, collegeTuitionOut, collegeTotalIn, collegeTotalOut, collegePartTime, collegeGsA, collegeGsP, collegeSlA, collegeSlP, collegeA030, collegeA110, collegeA3048, collegeA4875, collegeA75110, collegeNp030, collegeNp110, collegeNp3048, collegeNp4875, collegeNp75110;

@synthesize rankForbesNational, rankUSNewsLiberalArts, rankUSNewsUniversities, collegeRankUSNewsUniversities, collegeRankUSNewsLiberalArts, collegeRankForbesNational, retentionRate, collegeRetentionRate, studentFacultyRatio, collegeStudentFacultyRatio;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320,1000)];
    
	[self loadData];
}

-(void)loadData
{
    // College's icon file is college number
    NSString *collegeIconFile = [collegeNumber stringByAppendingString:@".jpg"];
    collegeIcon.image = [UIImage imageNamed:collegeIconFile];
    
    name.text = collegeName;
    control.text = collegeControl;
    commuter.text = collegeCommuter;
    rank.text = collegeRank;
    setting.text = collegeSetting;
    size.text = collegeSize;
    rankUSNewsUniversities.text = collegeRankUSNewsUniversities;
    rankUSNewsLiberalArts.text = collegeRankUSNewsLiberalArts;
    rankForbesNational.text = collegeRankForbesNational;
    
    studentFacultyRatio.text = [collegeStudentFacultyRatio stringByAppendingString:@":1"];
    retentionRate.text = [self formatStringToPercent:collegeRetentionRate];
    
    applicants.text = [self formatStringToNumber:collegeApplicants];
    admitted.text = [self formatStringToNumber:collegeAdmitted];
    
    // Calculate percent admitted
    double apply = [collegeApplicants doubleValue];
    double admit = [collegeAdmitted doubleValue];
    
    if (apply > 0 && admit > 0) {
        //NSLog(@"apply as double value is: %f", apply);
        //NSLog(@"admit as double value is: %f", admit);
        double percentAdmittedDouble = ((admit / apply) * 100);
        //NSLog(@"percent as double: %f", percentAdmittedDouble);
        
        // Convert percent to NSString
        NSString *percentAdmittedString = [NSString stringWithFormat:@"%.2f", percentAdmittedDouble];
        
        // Format NSString to percent
        percentAdmitted.text = [percentAdmittedString stringByAppendingString:@"%"];
        //NSLog(@"percentAdmitted.text is %@", [percentAdmittedString stringByAppendingString:@"%"]);
    } else {
        percentAdmitted.text = @"";
    }
    
    // Financial Aid
    tuitionIn.text = [self formatStringToCurrency:collegeTuitionIn];
    tuitionOut.text = [self formatStringToCurrency:collegeTuitionOut];
    totalIn.text = [self formatStringToCurrency:collegeTotalIn];
    totalOut.text = [self formatStringToCurrency:collegeTotalOut];

    gsA.text = [self formatStringToCurrency:collegeGsA];
    gsP.text = [self formatStringToPercent:collegeGsP];
    slA.text = [self formatStringToCurrency:collegeSlA];
    slP.text = [self formatStringToPercent:collegeSlP];
    
    NSString *_np030 = collegeNp030;
    NSString *_np3048 = collegeNp3048;
    NSString *_np4875 = collegeNp4875;
    NSString *_np75110 = collegeNp75110;
    NSString *_np110 = collegeNp110;
    
    if ([_np110 isEqualToString:@"999999"]) np110.text = @"No Data";
    else np110.text = [self formatStringToCurrency:collegeNp110];
    
    if ([_np75110 isEqualToString:@"999999"]) np75110.text = @"No Data";
    else np75110.text = [self formatStringToCurrency:collegeNp75110];
    
    if ([_np4875 isEqualToString:@"999999"]) np4875.text = @"No Data";
    else np4875.text = [self formatStringToCurrency:collegeNp4875];
    
    if ([_np3048 isEqualToString:@"999999"]) np3048.text = @"No Data";
    else np3048.text = [self formatStringToCurrency:collegeNp3048];
    
    if ([_np030 isEqualToString:@"999999"]) np030.text = @"No Data";
    else np030.text = [self formatStringToCurrency:collegeNp030];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
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

@end
