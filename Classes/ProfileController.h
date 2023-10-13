//
//  Profile.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIGHESTFIELD 60
#define LOWESTFIELD 116

@interface ProfileController : UIViewController {
    IBOutlet    UILabel*    label_ProfileName;
    IBOutlet    UILabel*    label_Name;
    IBOutlet    UILabel*    label_Address1;
    IBOutlet    UILabel*    label_Address2;
    IBOutlet    UILabel*    label_City;
    IBOutlet    UILabel*    label_State;
    IBOutlet    UILabel*    label_Country;
    IBOutlet    UILabel*    label_PostalCode;
    IBOutlet    UILabel*    label_Phone;
    IBOutlet    UILabel*    label_Email;
    IBOutlet    UILabel*    label_Condition;
    
	IBOutlet	UITextField*		profileName;
	IBOutlet	UITextField*		name;
	IBOutlet	UITextField*		address1;
	IBOutlet	UITextField*		address2;
	IBOutlet	UITextField*		city;
	IBOutlet	UITextField*		state;
	IBOutlet	UITextField*		country;
	IBOutlet	UITextField*		postalcode;
	IBOutlet	UITextField*		phone;
	IBOutlet	UITextField*		email;

	IBOutlet	UITextView*			condition;
	IBOutlet	UIScrollView*		scroller;
	
	IBOutlet	UIToolbar*			buttonToolBar;
	
	UIView*							activeBox;
	NSArray*						fields;

	NSTimer*						vTimer;
	NSMutableDictionary*			info;
	BOOL		cancelled;
    
    UISegmentedControl *segControl; // Used for the keyboard toolbar
    
    IBOutlet NSLayoutConstraint *constraint_Keyboard;
}
@property (nonatomic, strong) NSMutableDictionary*	info;
@property (nonatomic, assign) BOOL	cancelled;

-(IBAction)cancel:(id)sender;

-(IBAction) nextButton:(id)sender;
-(IBAction) doneButton:(id)sender;
-(void) scrollToTextField:(UIView*)field;

-(IBAction) addVoiceMemo:(id)sender;

@end
