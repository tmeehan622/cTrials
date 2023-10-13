//
//  Profile.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "ProfileController.h"
#import "VoiceRecorder.h"

@implementation ProfileController
@synthesize info, cancelled;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        cancelled = NO;
    }
    return self;
}
// MARK: - Lifecycle


//override func viewWillAppear(animated: Bool) {
//    super.viewWillAppear(animated)
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
//}
//
//override func viewWillDisappear(animated: Bool) {
//    super.viewWillDisappear(animated)
//    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//}

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
    
//    CGFloat a = CGRectGetMaxY(self.view.bounds);
//    CGFloat b = CGRectGetMinY(convertedKeyboardEndFrame);
//    CGFloat newconstant = CGRectGetMaxY(self.view.bounds)-CGRectGetMinY(convertedKeyboardEndFrame);
//    NSLog(@"A: %f, B: %f, C: %f", a, b, newconstant);
    
    constraint_Keyboard.constant = CGRectGetMaxY(self.view.bounds)-CGRectGetMinY(convertedKeyboardEndFrame);
    
    [UIView animateWithDuration:duration.floatValue
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState | curve.intValue)
                     animations:^{
                         [self.view layoutIfNeeded];
    } completion:nil];
    
//    let userInfo = notification.userInfo!
//    
//    let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
//    let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//    let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
//    let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as NSNumber).unsignedIntValue << 16
//    let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!
//    
//    bottomLayoutConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
//    
//    UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
//        self.view.layoutIfNeeded()
//    }, completion: nil)
//}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keyboard Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
	self.navigationItem.title = @"Edit Profile";

	fields = @[profileName, name, address1, address2, city, state, country, postalcode, phone, email, condition];

    NSArray *labels = @[label_ProfileName,
                        label_Name,
                        label_Address1,
                        label_Address2,
                        label_City,
                        label_State,
                        label_Country,
                        label_PostalCode,
                        label_Phone,
                        label_Email,
                        label_Condition];
    
    // Set the text color
    for(UILabel *label in labels)
    {label.textColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.0];}
    for(UITextField *field in fields)
    {
        field.textColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.0];
//        field.returnKeyType = UIReturnKeyDone;
    }
    
    
//	CGSize	r = scroller.contentSize;
//	r.height = 800;
//	scroller.contentSize = r;
	if(info)
	{
		NSString*	tmpStr;
		
		tmpStr = info[@"profileName"];
		profileName.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"name"];
		name.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"address1"];
		address1.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"address2"];
		address2.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"city"];
		city.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"state"];
		state.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"country"];
		country.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"postalcode"];
		postalcode.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"phone"];
		phone.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"email"];
		email.text = tmpStr ? tmpStr : @"";
		
		tmpStr = info[@"condition"];
		condition.text = tmpStr ? tmpStr : @"";
		
	} // if info
	
	UIBarButtonItem*	cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",@"")
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(cancel:)];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	
	vTimer = [NSTimer scheduledTimerWithTimeInterval:0.125 target:self selector:@selector(validator:) userInfo:nil repeats:YES];
			   
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Profile Open"];
#endif
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Keyboard Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
	[vTimer invalidate];
	if(cancelled)
	{
		[super viewWillDisappear:animated];
		return;
	}
		
	info[@"profileName"]= profileName.text;
	info[@"name"]       = name.text;
	info[@"address1"]   = address1.text;
	info[@"address2"]   = address2.text;
	info[@"city"]       = city.text;
	info[@"state"]      = state.text;
	info[@"country"]    = country.text;
	info[@"postalcode"] = postalcode.text;
	info[@"phone"]      = phone.text;
	info[@"email"]      = email.text;
	info[@"condition"]  = condition.text;
}

- (void) validator:(NSTimer*)timer
{
	BOOL hidesBackButton = ([profileName.text length] == 0 || [name.text length] == 0);
	
	self.navigationItem.hidesBackButton = hidesBackButton;
	
} // validator

-(IBAction)cancel:(id)sender
{
	cancelled = YES;
	[self.navigationController popViewControllerAnimated:YES];
} // cancel

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



-(void)scrollToTextField:(UIView*)field
{
	activeBox = field;
	CGRect		containerRect = CGRectMake(0, scroller.contentOffset.y, self.view.frame.size.width, 164);
	CGRect		boxRect = activeBox.frame;
	
	[activeBox becomeFirstResponder];
	
	if(buttonToolBar.hidden)
	{
        [UIView beginAnimations:@"toolbar" context:nil];
//		[UIView beginAnimations:nil context:@"toolbar"];
		[UIView setAnimationDuration:0.3];
		buttonToolBar.alpha = 0;
		buttonToolBar.hidden = NO;
		buttonToolBar.alpha = 1;
		[UIView commitAnimations];
	}
    
    /*
	if(field == [fields lastObject])
	{
		boxRect = activeBox.superview.frame;
		boxRect.origin.x = 0;
		scroller.contentOffset = boxRect.origin;
	}
	else if(!CGRectContainsRect(containerRect, boxRect))
	{
		boxRect.origin.x = 0;
		scroller.contentOffset = boxRect.origin;
	}
    */
    
    //CGFloat fieldPosY = field.frame.origin.y;
    
    [scroller setContentOffset:CGPointMake(0, fmin(field.frame.origin.y, scroller.contentSize.height-self.view.bounds.size.height)) animated:YES];
    
} // scrollToTextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[self nextButton:self];
	return YES;
} // textFieldShouldReturn

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//	[self scrollToTextField:textField];
//} // textFieldDidBeginEditing

- (void)textFieldDidEndEditing:(UITextField *)textField
{
} // textFieldDidEndEditing

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//	[self scrollToTextField:textView];
//} // textViewDidBeginEditing

-(IBAction) nextButton:(id)sender
{
	int index = [fields indexOfObject:activeBox] + 1;
	if(index > [fields count] -1)
		index = 0;
	
	id	nextField = fields[index];
	id	scrollToField = nextField;

	[self scrollToTextField:scrollToField];
	
} // nextButton

-(IBAction) doneButton:(id)sender
{
	[activeBox resignFirstResponder];
	buttonToolBar.hidden = YES;
	
} // doneButton

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGRect r = buttonToolBar.frame;
	
	if(UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
		r.origin.y = 160;
	else
		r.origin.y = 62;
	
	buttonToolBar.frame = r;
} // willRotateToInterfaceOrientation

-(IBAction) addVoiceMemo:(id)sender
{
	VoiceRecorder*		vr = [[VoiceRecorder alloc] initWithNibName:@"VoiceRecorder" bundle:nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString*	vmUUID = info[@"vmUUID"];
	vr.pathToFile = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory, vmUUID];
	[self.navigationController pushViewController:vr animated:YES];
	
} // addVoiceMemo

#pragma mark- Keyboard Accessory

-(UIToolbar *)keyboardToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    segControl = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
    segControl.momentary = YES;
    
    [segControl addTarget:self action:@selector(changeRow:) forControlEvents:(UIControlEventValueChanged)];
    [segControl setEnabled:NO forSegmentAtIndex:0];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDone:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *itemsArray = @[nextButton, spacer, doneButton];
    
    [toolbar setItems:itemsArray];
    
    return toolbar;
}

-(void)keyboardDone:(id)sender
{
    [activeBox resignFirstResponder];
}

-(void)changeRow:(id)sender
{
    NSInteger fieldIndex = [fields indexOfObject:activeBox];
    fieldIndex = [sender selectedSegmentIndex] == 0 ? fieldIndex-1 : fieldIndex+1;
//    NSInteger prevnext = [sender selectedSegmentIndex];
//    if(prevnext) // next
//    {
//        
//    }
//    else // prev
//    {
//        
//    }
    
//    int index = [fields indexOfObject:activeBox] + 1;
//    if(index > [fields count] -1)
//        index = 0;
    
    id	nextField = fields[fieldIndex];
    id	scrollToField = nextField;
    
    [self scrollToTextField:scrollToField];
    [self refreshSegControl];
    
//    if (idx) {
//        self.topText.text = @"Top one";
//        [self.bottomText becomeFirstResponder];
//    }
//    else {
//        self.bottomText.text =@"Bottom one";
//        [self.topText becomeFirstResponder];
//    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!textField.inputAccessoryView)
    {
        textField.inputAccessoryView = [self keyboardToolBar];
    }
    [self scrollToTextField:textField];
    [self refreshSegControl];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!textView.inputAccessoryView)
    {
        textView.inputAccessoryView = [self keyboardToolBar];
    }
    [self scrollToTextField:textView];
    [self refreshSegControl];
}

-(void)refreshSegControl
{
    NSInteger fieldIndex = [fields indexOfObject:activeBox];
    if(fieldIndex == 0)
    {
        [segControl setEnabled:NO forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
    }
    else if(fieldIndex == fields.count-1)
    {
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:NO forSegmentAtIndex:1];
    }
    else
    {
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
    }
}

@end
