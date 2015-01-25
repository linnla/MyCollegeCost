//
//  MasterCell.h
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "College.h"

@interface MasterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cityState;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *rankUSNewsUniversities;
@property (weak, nonatomic) IBOutlet UILabel *rankUSNewsLiberalArts;
@property (weak, nonatomic) IBOutlet UILabel *rankForbesNational;
@property (weak, nonatomic) IBOutlet UIImageView *collegeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *usNewsIcon;
@property (weak, nonatomic) IBOutlet UILabel *studentAvgNetPrice;
@property (strong, nonatomic) IBOutlet UIImageView *academicImage;
@property (strong, nonatomic) IBOutlet UIImageView *costImage;

@property (weak, nonatomic) IBOutlet UILabel *homeState;

-(void)setCellDetailsForCollege:(College *) college;
-(void)setCellDetailsForState;

@end
