//
//  MasterCell.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "MasterCell.h"

@implementation MasterCell

@synthesize name, cityState, rank, cost, academicImage, costImage, homeState, studentAvgNetPrice;
@synthesize rankForbesNational, rankUSNewsUniversities, rankUSNewsLiberalArts, collegeIcon, usNewsIcon;

-(void)setCellDetailsForCollege:(College *)college
{
    name.text = college.name;
   
    // College's icon file is college number
    //NSString *collegeIconFile = [[NSString stringWithFormat:@"%d", college.number] stringByAppendingString:@".png"];
    //collegeIcon.image = [UIImage imageNamed:collegeIconFile];
    
    // If college isn't ranked by USNews in Universities ranking, don't show US News icon
    if ([college.rankUSNewsUniversities isEqualToString:@"Unranked"]) usNewsIcon.image = [UIImage imageNamed:@"0c.png"];
    else usNewsIcon.image = [UIImage imageNamed:@"USNews.png"];
    
    
    //NSLog(@"College icon file name: %@", collegeIconFile);

    //NSLog(@"College is: %@", college.name);
    //NSLog(@"College rank is: %@", college.rank);
    //NSLog(@"College rankUSNewsUniversities is: %@", college.rankUSNewsUniversities);
    //NSLog(@"College number is: %d", college.number);
    
    cityState.text = college.cityState;
    rank.text = college.rank;
    cost.text = college.cost;
    
    rankUSNewsLiberalArts.text = college.rankUSNewsLiberalArts;
    rankUSNewsUniversities.text = college.rankUSNewsUniversities;
    rankForbesNational.text = college.rankForbesNational;
    
    // If netPrice = 0 for users selected income level, display "No Data"
    // otherwise, if user hasn't setup an income level, display nothing
    // otherwise, display netprice
    if ([college.studentAvgNetPrice isEqualToString:@"No Data"]){
        studentAvgNetPrice.text = @"No Data";
    } else if ([college.studentAvgNetPrice isEqualToString:@" "]){
        studentAvgNetPrice.text = @" ";
    } else {
        studentAvgNetPrice.text = [self formatStringToCurrency:college.studentAvgNetPrice];
    }
    
    if ([college.academicCategory isEqualToString:@"5"]) academicImage.image = [UIImage imageNamed:@"5a.png"];
        else if ([college.academicCategory isEqualToString:@"4"]) academicImage.image = [UIImage imageNamed:@"4a.png"];
        else if ([college.academicCategory isEqualToString:@"3"]) academicImage.image = [UIImage imageNamed:@"3a.png"];
        else if ([college.academicCategory isEqualToString:@"2"]) academicImage.image = [UIImage imageNamed:@"2a.png"];
        else if ([college.academicCategory isEqualToString:@"1"]) academicImage.image = [UIImage imageNamed:@"1a.png"];
        else if ([college.academicCategory isEqualToString:@"0"]) academicImage.image = [UIImage imageNamed:@"0a.png"];
    
    if ([college.costCategory isEqualToString:@"5"]) costImage.image = [UIImage imageNamed:@"5c.png"];
        else if ([college.costCategory isEqualToString:@"4"]) costImage.image = [UIImage imageNamed:@"4c.png"];
        else if ([college.costCategory isEqualToString:@"3"]) costImage.image = [UIImage imageNamed:@"3c.png"];
        else if ([college.costCategory isEqualToString:@"2"]) costImage.image = [UIImage imageNamed:@"2c.png"];
        else if ([college.costCategory isEqualToString:@"1"]) costImage.image = [UIImage imageNamed:@"1c.png"];
        else if ([college.costCategory isEqualToString:@"0"]) costImage.image = [UIImage imageNamed:@"0c.png"];
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



-(void)setCellDetailsForState
{
    //NSLog(@"MasterCell: setCellDetailsForState");
    //homeState.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"homeState"];
    
    NSString *state = [[NSUserDefaults standardUserDefaults] stringForKey:@"homeState"];
    homeState.text = state;
    
    //NSLog(@"homeState.text = %@", homeState.text);
    //NSLog(@"state = %@", state);

}

@end
