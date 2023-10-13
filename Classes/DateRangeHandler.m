//
//  DateRangeHandler.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/27/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "DateRangeHandler.h"
#import "AdvancedSearchController.h"
#import "DateLabel.h"

#define DATE_HIGHLIGHT [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
@implementation DateRangeHandler
@synthesize dates, datePicker,whichtype,ToLabel, FromLabel;

- (void) awakeFromNib
{
	CGRect	r = datePickerContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	datePickerContainer.frame = r;
	datePickerContainer.hidden = NO;
//	datePickerContainer.backgroundColor = [UIColor darkTextColor];
	startDateText.userInteractionEnabled = YES;
	endDateText.userInteractionEnabled = YES;
	activeTag = 1;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/yyyy"];

	[datePicker addTarget:self action:@selector(pickerStopped:) forControlEvents:UIControlEventValueChanged];
} // awakeFromNib

 //  dealloc

- (IBAction) cancelDatePicker:(id)sender
{
	[self hideDatePicker:YES];
} // cancelDatePicker

- (IBAction) okDatePicker:(id)sender
{
	NSMutableArray*	dateSet = [NSMutableArray arrayWithObjects:startDateText.text, endDateText.text, nil];
	dates[@"values"] = dateSet;
	
	[self hideDatePicker:YES];
	[myController.myTable reloadData];
} // okDatePicker

- (IBAction) clearDatePicker:(id)sender
{
	if(activeTag)
		endDateText.text = @"";
	else
		startDateText.text = @"";
} // clearDatePicker

- (void) showDatePicker:(BOOL)animated
{
    
	NSLog(@"showDatePicker-IN");	
	activeTag = 0;
	NSLog(@"whichtype: %d",self.whichtype);
    
	switch(self.whichtype)
	{
		case 5:
            self.ToLabel.hidden = NO;
			self.FromLabel.hidden = YES;
			break;
		case 6:
            self.ToLabel.hidden = YES;
			self.FromLabel.hidden = NO;
			break;
		}
	startDateText.text  = dates[@"values"][0];
	endDateText.text    = dates[@"values"][1];
//	startBackground.backgroundColor = DATE_HIGHLIGHT;
//	endBackground.backgroundColor = [UIColor clearColor];
//	datePickerContainer.backgroundColor = [UIColor darkTextColor];

	if([startDateText.text length] == 0 && [endDateText.text length] == 0)
		startDateText.text = [formatter stringFromDate:[NSDate date]];
	
	CGRect	r = datePickerContainer.frame;
	r.origin.y = 0;
	if(animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		datePickerContainer.frame = r;
		[UIView commitAnimations];
	}
	else
	{
		datePickerContainer.frame = r;
	}
	
	[self selectActiveDateWithTag:activeTag];
	myController.searchButton.enabled = NO;
	NSLog(@"showDatePicker-OUT");	
} // showDatePicker

- (void) hideDatePicker:(BOOL)animated
{
	NSLog(@"hideDatePicker-IN");	

	CGRect	r = datePickerContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	if(animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		datePickerContainer.frame = r;
		[UIView commitAnimations];
	}
	else
	{
		datePickerContainer.frame = r;
	}
	myController.searchButton.enabled = YES;
	NSLog(@"hideDatePicker-OUT");	
} // hideDatePicker

- (void)selectActiveDateWithTag:(int)theTag
{
	NSString*	dateText;
	NSLog(@"selectActiveDateWithTag-IN tag: %d",theTag);	
	activeTag = theTag;
	if(activeTag)
	{
		startBackground.backgroundColor = [UIColor clearColor];
		endBackground.backgroundColor = DATE_HIGHLIGHT;
		dateText = endDateText.text;
	}
	else
	{
		startBackground.backgroundColor = DATE_HIGHLIGHT;
		endBackground.backgroundColor = [UIColor clearColor];
		dateText = startDateText.text;
		
	}
	NSDate*	theDate = [NSDate date];
	if(dateText && [dateText length])
		theDate = [formatter dateFromString:dateText];
	
	[datePicker setDate:theDate animated:YES];
	NSLog(@"selectActiveDateWithTag-OUT tag: %d",theTag);	
	
} // selectActiveDateWithTag

- (IBAction) pickerStopped:(id)sender
{
	if(activeTag)
		endDateText.text = [formatter stringFromDate:datePicker.date];
	else
		startDateText.text = [formatter stringFromDate:datePicker.date];
		
} // pickerStopped
@end
