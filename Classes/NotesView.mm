//
//  NotesView.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/31/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "NotesView.h"
#import "VoiceRecorder.h"


@implementation NotesView
@synthesize note, delegate, noteTitleLabel, noteID;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Notes";
	editing = NO;
	changed = NO;
	

	noteTitle.text = noteTitleLabel;
	notes.text = note;
	
	editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit",@"")
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(toggleEditing:)];
	
	self.navigationItem.rightBarButtonItem = editButton;
    
    
    // Keyboard Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
	
} // viewDidLoad

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if(delegate)
		[delegate updateBookmarkInfo:notes.text];
    
    // Keyboard Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
		
} // viewWillDisappear

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Notes View Open"];
#endif
}


-(IBAction)toggleEditing:(id)sender
{
	if(editing)
	{
		[notes resignFirstResponder];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
		[notes becomeFirstResponder];
} // startEditing

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	changed = YES;
	return YES;
} // textViewDidChange

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	editButton.title = @"Save";
	editing = YES;
} // textFieldDidBeginEditing

- (void)textViewDidEndEditing:(UITextView *)textView

{
	editButton.title = @"Edit";
	editing = NO;

	if(changed)
	{
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Notes"
														message:@"Your note has been saved."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
} // textFieldDidEndEditing

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}



-(IBAction) addVoiceMemo:(id)sender
{
	VoiceRecorder*		vr = [[VoiceRecorder alloc] initWithNibName:@"VoiceRecorder" bundle:nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	vr.pathToFile = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory, noteID];
	[self.navigationController pushViewController:vr animated:YES];
	
} // addVoiceMemo


-(void)keyboardWillShowNotification:(NSNotification *)notification
{
    [self updateKeyboardConstraints:notification];
}
-(void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self updateKeyboardConstraints:notification];
}

-(void)updateKeyboardConstraints:(NSNotification *)notification
{
    NSNumber *duration  = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve     = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedKeyboardEndFrame = [self.view convertRect:keyboardEndFrame fromView:self.view.window];

    constraint_Keyboard.constant = CGRectGetMaxY(self.view.bounds)-CGRectGetMinY(convertedKeyboardEndFrame)+20;
    
    [UIView animateWithDuration:duration.floatValue
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState | curve.intValue)
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

@end
