//
//  GlobeView.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 12/2/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "GlobeView.h"
#import "TouchTrigger.h"
#import "WorldCountries.h"


@implementation GlobeView

- (void)viewDidLoad {
    [super viewDidLoad];
	
	northAmerica.touchTag = @"northAmerica";
	world.touchTag = @"world";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapTouch:) name:@"MAP_TOUCH" object:northAmerica];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapTouch:) name:@"MAP_TOUCH" object:world];
}


- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void) mapTouch:(NSNotification*)notification
{
	TouchTrigger*	tt = (TouchTrigger*) [notification object];
	WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
#if 0
	if([tt.touchTag isEqualToString:@"northAmerica"])
		controller.region = kNorthAmerica;
#endif	
	[self.navigationController pushViewController:controller animated:YES];
} // mapTouch

@end
