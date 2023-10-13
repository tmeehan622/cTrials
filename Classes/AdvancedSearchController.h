//
//  AdvancedSearchController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 9/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BasicSearchController.h"
@class DateRangeHandler;

@protocol HeadingSelectionChanger <NSObject>
-(void)changeSelection:(NSArray*)newSelection forHeading:(NSString*)heading;
@end

@interface AdvancedSearchController : BasicSearchController <HeadingSelectionChanger, UITextFieldDelegate> {
	NSArray*							tableHeaders;
	NSMutableArray*						tableCellContent;
	UITextField*						activeTextField;
	BOOL								shouldSearch;
	UIBarButtonItem*					searchButton;
	IBOutlet	UIPickerView*			masterPicker;
	IBOutlet	UIView*					masterPickerContainer;
    IBOutlet    UIView*                 datePickerContainer;
	IBOutlet	DateRangeHandler*		dateRangeHandler;

	BOOL								busyEditing;
	NSArray*							pickerItems;
	NSMutableDictionary*				pickerDict;
}
@property (nonatomic, weak)			NSString*			allFields;
@property (nonatomic, weak)			NSString*			state1;
@property (nonatomic, readonly)			UIBarButtonItem*	searchButton;

- (IBAction) cancelEnditing:(id)sender;
- (IBAction) doSearch:(id)sender;
- (void) textCellChanged:(NSNotification*)notifcation;

- (IBAction) cancelPicker:(id)sender;
- (IBAction) setPicker:(id)sender;
- (void) showPicker:(BOOL)animated;
- (void) hidePicker:(BOOL)animated;

- (void) changeSelection:(NSArray*)newSelection forHeading:(NSString*)heading;

- (NSNumber*) findParameter:(NSMutableDictionary*)dict forValue:(NSString*)value;
- (NSMutableDictionary*) locateParameterWithName:(NSString*)name;
- (void) mapSearchURLtoRefinedSearch:(NSString*)oldURL;

@end
