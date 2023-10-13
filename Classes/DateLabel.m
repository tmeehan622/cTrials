//
//  DateLabel.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/27/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "DateLabel.h"


@implementation DateLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"DateLabel: touchesEnded");
	if(delegate)
		[delegate selectActiveDateWithTag:[self	tag]];
}
@end
