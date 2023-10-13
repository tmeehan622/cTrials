//
//  SegmentedPref.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/24/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "SegmentedPref.h"

@implementation SegmentedPref
@synthesize segmentedControl, prompt, segments, prefName, prefTitle;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = YES;
	}
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Settings";
	
	[segmentedControl removeAllSegments];
	int i = 0;
	for(NSString*s in segments)
		[segmentedControl insertSegmentWithTitle:s atIndex:i++ animated:NO];
	
	int index = [[NSUserDefaults standardUserDefaults] integerForKey:prefName];
	if(index > [segments count])
		index = [segments count];
	if(index < 0)
		index = 0;
	
	segmentedControl.selectedSegmentIndex = index;
    segmentedControl.tintColor = [UIColor colorWithRed:0.67 green:0.00 blue:0.00 alpha:1.0];
	
	prompt.text = prefTitle;
} // viewDidLoad

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	int	index = segmentedControl.selectedSegmentIndex;

	NSUserDefaults*	ud = [NSUserDefaults standardUserDefaults];
	[ud setInteger:index forKey:prefName];
	[ud synchronize];
} // viewWillDisappear


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
