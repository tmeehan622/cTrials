//
//  TermsOfUse.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/1/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "TermsOfUse.h"


@implementation TermsOfUse

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
	
	BOOL alreadyAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"agreedToTerms"];

	if(alreadyAccepted)
	{
		okButton.hidden = NO;
		acceptButton.hidden = YES;
		declineButton.hidden = YES;
	}
	else
	{
		okButton.hidden = YES;
		acceptButton.hidden = NO;
		declineButton.hidden = NO;
	}
	self.navigationItem.title = @"Terms of Use";
	[mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"termsOfUse" ofType:@"html"]]]];
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
	[Flurry logEvent:@"Terms of Use Open"];
#endif
}


- (IBAction)accept:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agreedToTerms"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)decline:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"agreedToTerms"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Decline"
													message:@"You cannot use cTrials without agreeing to the Terms of Use. Press the home button to exit"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	//
}

@end
