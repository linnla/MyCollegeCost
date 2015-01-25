//
//  DetailViewController.h
//  MasterDetail
//
//  Created by Laure Linn on 3/13/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

// Segue Properties
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
@property (nonatomic, strong) NSString *collegePartTime;

@property (nonatomic, strong) NSString *collegeRankUSNewsUniversities;
@property (nonatomic, strong) NSString *collegeRankUSNewsLiberalArts;
@property (nonatomic, strong) NSString *collegeRankForbesNational;
@property (nonatomic, strong) NSString *collegeStudentFacultyRatio;
@property (nonatomic, strong) NSString *collegeRetentionRate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *control;
@property (weak, nonatomic) IBOutlet UILabel *commuter;

@property (weak, nonatomic) IBOutlet UILabel *cityState;
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
@property (weak, nonatomic) IBOutlet UILabel *partTime;

@property (weak, nonatomic) IBOutlet UILabel *rankUSNewsUniversities;
@property (weak, nonatomic) IBOutlet UILabel *rankUSNewsLiberalArts;
@property (weak, nonatomic) IBOutlet UILabel *rankForbesNational;
@property (weak, nonatomic) IBOutlet UILabel *studentFacultyRatio;
@property (weak, nonatomic) IBOutlet UILabel *retentionRate;

@property (weak, nonatomic) IBOutlet UIImageView *collegeIcon;

@end
