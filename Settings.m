//
//  Settings.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/24/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//
//UITextView
#import "Settings.h"
#import "SegmentedPref.h"
#import "AboutBox.h"
#import "Disclaimer.h"
//#import "Registration.h"
#import "Support.h"
#import "TermsOfUse.h"
#import "Understanding.h"

//enum { kTellAFriend=0, kAbout, kPageLength, kDisclaimer, kSupport, kRegister, kUnderstanding, kTerms };
enum { kTellAFriend=0, kAbout, kPageLength, kDisclaimer, kSupport, kUnderstanding, kTerms };

@implementation Settings

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
	self.navigationItem.title = @"Settings";
//	tableHeadings = [[NSArray alloc] initWithObjects:@"Tell a Friend", @"About cTrials", @"Records Per Page", @"Disclaimer", @"Support", @"Registration", @"Understanding Clinical Trials", @"Terms of Use", nil];
	tableHeadings = [[NSArray alloc] initWithObjects:@"Tell a Friend", @"About cTrials", @"Records Per Page", @"Disclaimer", @"Support", @"Understanding Clinical Trials", @"Terms of Use", nil];
//	[self view].backgroundColor = ORKOV_BG_COLOR;
//	myTable.backgroundColor = ORKOV_BG_COLOR;
	myTable.backgroundColor = [UIColor clearColor];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Settings Open"];
#endif
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



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableHeadings count];	// stub
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      //  cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
 		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   }
    
	cell.textLabel.text = tableHeadings[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController* nextController = nil;
	
	switch (indexPath.row) {
			
		case kTellAFriend:
		{
            // Don't crash out if the device has no mail addresses set up
            if([MFMailComposeViewController canSendMail] == NO)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot compose mail." message:@"This device has not configured any email addresses." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//			picker.navigationBar.tintColor = ORKOV_TINT_COLOR;
			picker.mailComposeDelegate = self;
			[picker setSubject:@"Checkout the cTrials App for iPhone"];
			NSString*	emailBody = @"<html><head></head><body><p>Go To iTunes and download cTrials - it's free..</p><p>cTrials is the Clinical Trials search authority on iPhone.</p></body></html>";
			[picker setBccRecipients:@[@"info@visualsoftinc.com"]];
			[picker setMessageBody:emailBody isHTML:YES];
			
			[self presentModalViewController:picker animated:YES];
		}
			break;
					
		case kAbout:
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ABOUT_TOUCH" object:self]];
		//	nextView = [[AboutBox alloc] initWithNibName:@"AboutBox" bundle:nil];
			break;
			
		case kPageLength:
		{
			SegmentedPref*	aViewController = [[SegmentedPref alloc] initWithNibName:@"SegmentedPref" bundle:nil];
			aViewController.prefName = @"itemsPerPage";
			aViewController.segments = @[@"10", @"25", @"50", @"75", @"100"];
			aViewController.prefTitle = @"Number of records per page:";
			nextController = (UIViewController*) aViewController;
		}
			break;
			
		case kDisclaimer:
			nextController = [[Disclaimer alloc] initWithNibName:@"Disclaimer" bundle:nil];
			break;

		case kSupport:
			nextController = [[Support alloc] initWithNibName:@"Support" bundle:nil];
			break;
			
//
//		case kRegister:
//			nextView = [[Registration alloc] initWithNibName:@"Registration" bundle:nil];
//			break;
			
		case kTerms:
			nextController = [[TermsOfUse alloc] initWithNibName:@"TermsOfUse" bundle:nil];
			[self presentModalViewController:nextController animated:NO];
			nextController = nil;
			break;
			
		case kUnderstanding:
			nextController = [[Understanding alloc] initWithNibName:@"Understanding" bundle:nil];
			break;
			
		default:
			break;
	}
	
	if(nextController)
	{
		[self.navigationController pushViewController:nextController animated:YES];
        
        // This is a bit hacky, but it's better than going into each controller's implementation and setting edges.
        [nextController setEdgesForExtendedLayout:UIRectEdgeNone];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
} // didSelectRowAtIndexPath

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
