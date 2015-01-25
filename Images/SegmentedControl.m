//
//  SegmentedControl.m
//  MasterDetail
//
//  Created by Laure Linn on 3/5/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "SegmentedControl.h"

@implementation SegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setSelectedSegmentIndex:(NSInteger)toValue {
    if (self.selectedSegmentIndex == toValue) {
        [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
    } else {
        [super setSelectedSegmentIndex:toValue];
    }
}

@end
