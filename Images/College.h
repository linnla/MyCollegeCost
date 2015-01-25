//
//  College.h
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface College : NSObject

@property (nonatomic, copy) NSString  *number;
@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *control;
@property (nonatomic, copy) NSString  *commuter;
@property (nonatomic, copy) NSString  *setting;
@property (nonatomic, copy) NSString  *size;
@property (nonatomic, copy) NSString  *rank;
@property (nonatomic, copy) NSString  *percentAdmitted;
@property (nonatomic, copy) NSString  *admitted;
@property (nonatomic, copy) NSString  *applicants;
@property (nonatomic, copy) NSString  *tuitionIn;
@property (nonatomic, copy) NSString  *tuitionOut;
@property (nonatomic, copy) NSString  *totalIn;
@property (nonatomic, copy) NSString  *totalOut;

@property (nonatomic, copy) NSString  *cityState;
@property (nonatomic, copy) NSString  *state;

@property (nonatomic, copy) NSString  *cost;
@property (nonatomic, copy) NSString  *academicCategory;
@property (nonatomic, copy) NSString  *costCategory;
@property (nonatomic, copy) NSString  *studentAvgNetPrice;
@property (nonatomic, copy) NSString  *sectionIndexCost;
@property (nonatomic, copy) NSString  *si_netCost030;
@property (nonatomic, copy) NSString  *si_netCost3048;
@property (nonatomic, copy) NSString  *si_netCost4875;
@property (nonatomic, copy) NSString  *si_netCost75110;
@property (nonatomic, copy) NSString  *si_netCost110;
@property int i_030;
@property int i_3048;
@property int i_4875;
@property int i_75110;
@property int i_110;
@property int computedNetCost;
@property int costVariable;

@property (nonatomic, copy) NSString  *partTime;

@property (nonatomic, copy) NSString  *gsP;
@property (nonatomic, copy) NSString  *gsA;
@property (nonatomic, copy) NSString  *slP;
@property (nonatomic, copy) NSString  *slA;
@property (nonatomic, copy) NSString  *np030;
@property (nonatomic, copy) NSString  *a030;
@property (nonatomic, copy) NSString  *np3048;
@property (nonatomic, copy) NSString  *a3048;
@property (nonatomic, copy) NSString  *np4875;
@property (nonatomic, copy) NSString  *a4875;
@property (nonatomic, copy) NSString  *np75110;
@property (nonatomic, copy) NSString  *a75110;
@property (nonatomic, copy) NSString  *np110;
@property (nonatomic, copy) NSString  *a110;

@property (nonatomic, copy) NSString *retentionRate;
@property (nonatomic, copy) NSString *studentFacultyRatio;
@property (nonatomic, copy) NSString *rankUSNewsLiberalArts;
@property (nonatomic, copy) NSString *rankUSNewsUniversities;
@property (nonatomic, copy) NSString *rankForbesNational;

@property (nonatomic, copy) NSString *si_usNewsUniversities;
//@property int si_usNewsUniversities;

@property int rankUSNews;
@property int rankForbes;

@end
