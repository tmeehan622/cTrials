//
//  MapSearchController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/3/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "MapSearchController.h"
#import "ResultsViewController.h"
#import "WorldCountries.h"


@implementation MapSearchController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString*	mapPath = [[NSBundle mainBundle] pathForResource:@"usaworldmap" ofType:@"html"];
	[mapView loadRequest :[NSURLRequest requestWithURL:[NSURL fileURLWithPath:mapPath]]];
}

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

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Country Search Open"];
#endif
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{	
	NSURL*		dest = [request URL];
	
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		NSString*	scheme = [dest scheme];
		NSString*	resourceSpecifier = [[[dest resourceSpecifier] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
		
		if([scheme isEqualToString:@"maptouch"])
		{
			if([resourceSpecifier isEqualToString:@"WORLD"])
			{
#if 1
				WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
				[self.navigationController pushViewController:controller animated:YES];
#endif
			}
			else
			{
				NSDictionary*	term = @{@"state1": [NSString stringWithFormat:@"NA:US:%@", resourceSpecifier]};
				ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
				controller.searchFields = term;
				[self.navigationController pushViewController:controller animated:YES];
				[controller searchAddingToHistory:YES];
			}
		}
		
	}
	
	return YES;
}

@end
