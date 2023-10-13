//
//  TouchTrigger.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 12/2/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "TouchTrigger.h"


@implementation TouchTrigger
@synthesize touchTag;



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"MAP_TOUCH" object:self]];
} // touchesEnded

@end
