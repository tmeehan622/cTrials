//
//  Support.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/26/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "Support.h"


@implementation Support

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = YES;
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Support";
}

-(IBAction) emailSupport:(id)sender
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
//	picker.navigationBar.tintColor = ORKOV_TINT_COLOR;
	picker.mailComposeDelegate = self;
	[picker setToRecipients:@[@"info@visualsoftinc.com"]];
	[picker setSubject:@"Support Request"];
	
	[self presentModalViewController:picker animated:YES];
}

-(IBAction) emailSales:(id)sender
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
//	picker.navigationBar.tintColor = ORKOV_TINT_COLOR;
	picker.mailComposeDelegate = self;
	[picker setToRecipients:@[@"info@visualsoftinc.com"]];
	[picker setSubject:@"Sales Support"];
	
	[self presentModalViewController:picker animated:YES];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Support Open"];
#endif
}


@end
