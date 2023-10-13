//
//  DateRangeHandler.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/27/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DateLabel;
@class AdvancedSearchController;

@interface DateRangeHandler : NSObject {
	IBOutlet	UIDatePicker*				datePicker;
	IBOutlet	UIView*						datePickerContainer;
	IBOutlet	DateLabel*					startDateText;
	IBOutlet	DateLabel*					endDateText;
	IBOutlet	UILabel*					ToLabel;
	IBOutlet	UILabel*					FromLabel;
	IBOutlet	UIView*						startBackground;
	IBOutlet	UIView*						endBackground;
	
	IBOutlet	AdvancedSearchController*	myController;
	NSMutableDictionary*					dates;
	
	int										activeTag;
	int										whichtype;
	
	NSDateFormatter*						formatter;
}
@property(assign) int				whichtype;
@property(nonatomic, strong) UIDatePicker*				datePicker;
@property(nonatomic, strong) NSMutableDictionary*		dates;
@property(nonatomic, strong) IBOutlet	UILabel*		ToLabel;
@property(nonatomic, strong) IBOutlet	UILabel*		FromLabel;

- (IBAction) cancelDatePicker:(id)sender;
- (IBAction) clearDatePicker:(id)sender;
- (IBAction) okDatePicker:(id)sender;
- (void) showDatePicker:(BOOL)animated;
- (void) hideDatePicker:(BOOL)animated;

- (void)selectActiveDateWithTag:(int)theTag;

- (IBAction) pickerStopped:(id)sender;
@end
