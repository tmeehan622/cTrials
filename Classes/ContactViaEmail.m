//
//  ContactViaEmail.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/16/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "ContactViaEmail.h"
#import "GenericParser.h"


@implementation ContactViaEmail
@synthesize profileInfo, detailedInfo;

+(NSString*)emailRecordFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
	
    BOOL exists = [fileManager fileExistsAtPath:documentsDirectory];
    if (!exists) {
        BOOL success = [fileManager createDirectoryAtPath:documentsDirectory attributes:nil];
        if (!success) {
            NSAssert(0, @"Failed to create Documents directory.");
        }
    }
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/emailRecord.plist"];
	return prefPath;
} // emailRecordFile

+(void)addRecord:(NSDictionary*)record
{
	NSMutableDictionary* sentRecords = [NSMutableDictionary dictionaryWithContentsOfFile:[ContactViaEmail emailRecordFile]];
	NSMutableArray*	list = [[sentRecords objectAtPath:@"list"] mutableCopy];
	if(list == nil)
		list = [NSMutableArray array];
	[list addObject:record];
	sentRecords[@"list"] = list;
	[sentRecords writeToFile:[ContactViaEmail emailRecordFile] atomically:YES];
	
} // addRecord

+(NSArray*)sentRecords
{
	NSDictionary* sentRecords = [NSDictionary dictionaryWithContentsOfFile:[ContactViaEmail emailRecordFile]];
	NSArray*	list = [sentRecords objectAtPath:@"list"];
	if(list == nil)
		list = @[];
	
	return list;
} // sentRecords

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
    
    // Don't crash out if the device has no mail addresses set up
    if([MFMailComposeViewController canSendMail] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot compose mail." message:@"This device has not configured any email addresses." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
	
	NSMutableString*	emailBody = [NSMutableString stringWithFormat:@"Dear %@:\n\n I am contacting you with regard to the clinical trial study %@\n\n\n", 
									 [detailedInfo objectAtPath:@"overall_contact/last_name"], [detailedInfo objectAtPath:@"brief_title"]];

	if(profileInfo)
	{
		[emailBody appendFormat:@"%@\n\n", [profileInfo objectAtPath:@"condition"]];
		[emailBody appendFormat:@"Contact Information:\n\t%@\n\t%@", [profileInfo objectAtPath:@"name"], [profileInfo objectAtPath:@"address1"]];
		if([profileInfo objectAtPath:@"address2"])
			[emailBody appendFormat:@"%@\n", [profileInfo objectAtPath:@"address2"]];

		[emailBody appendFormat:@"%@, %@ %@\n%@\n\n\n", [profileInfo objectAtPath:@"city"], [profileInfo objectAtPath:@"state"], [profileInfo objectAtPath:@"postalcode"], [profileInfo objectAtPath:@"country"]];
		[emailBody appendFormat:@"%@\n%@\n\n", [profileInfo objectAtPath:@"phone"], [profileInfo objectAtPath:@"email"]];
	}
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	NSString*	title = [NSString stringWithFormat:@"Re: %@", [detailedInfo objectAtPath:@"brief_title"]];
	[picker setSubject:title];
	[picker setMessageBody:emailBody isHTML:NO];
	[picker setToRecipients:@[[detailedInfo objectAtPath:@"overall_contact/email"]]];
	[self presentModalViewController:picker animated:YES];
	
} // viewDidLoad

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Send Mail Open"];
#endif
}



// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
#if __DEBUG_OUTPUT__
	NSLog(@"Email status:%d",result);
#endif
	if(result == MFMailComposeResultSent)
		[ContactViaEmail addRecord:@{@"detailedInfo": detailedInfo, @"date": [NSDate date]}];
		
	[self dismissModalViewControllerAnimated:YES];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popLater:) userInfo:nil repeats:NO];
} // mailComposeController

- (void) popLater:(NSTimer*)timer
{
	[self.navigationController popViewControllerAnimated:YES];
} // popLater


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
