//
//  TrialViewController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GenericParser.h"
#import "ARCProtocols.h"

@class OptionsHandler;

enum {kAlertModeFavorites=0, kAlertModeEmailStudy, kAlertModeContactEmail, kAlertModeContactPhone};

@interface TrialViewController : UIViewController <BookmarkUpdating, GenericParserClient, MFMailComposeViewControllerDelegate> {
	IBOutlet			UIView*			mainView;
	IBOutlet			UIView*			optionsMenuView;
	IBOutlet			UIView*			busy;
	IBOutlet			UILabel*		brief_title;
	IBOutlet			UILabel*		official_title;
	IBOutlet			UILabel*		source;
	IBOutlet			UITextView*		textblock;
	
	IBOutlet			UITableView*	myTable;
	NSArray*							tableHeaders;
	NSArray*							tableAccessInfo;
	NSMutableArray*						tableCellContent;
	

	IBOutlet			UIButton*		favoriteButton;
	IBOutlet			UIButton*		emailStudyButton;
	IBOutlet			UIButton*		contactEmailButton;
	IBOutlet			UIButton*		contactCallButton;
	
	IBOutlet			UITableView*	optionsMenuTable;
	IBOutlet			OptionsHandler*	optionsHsndler;
	
	IBOutlet			UIButton*		jumpButton;
	IBOutlet			UIView*			jumpContainer;
	IBOutlet			UIPickerView*	jumpPicker;
	
	UIBarButtonItem*					optionsButton;
	BOOL								showingOptions;
	int									alertMode;
	
	NSArray*							locations;
	
	NSDictionary*		basicInfo;
	NSDictionary*		detailedInfo;
}
@property (nonatomic, strong) NSDictionary*		basicInfo;
@property (nonatomic, strong) NSDictionary*		detailedInfo;
@property (nonatomic, strong) NSArray*			locations;

- (NSString*) stringForPrimaryKey:(NSString*)primaryKey secondaryKey:(NSString*)secondaryKey allowDuplicates:(BOOL)allowDuplicates;
- (NSString*) stringForKeys:(NSArray*)keys separatedBy:(NSString*)separator;
- (NSString*) reformTextBlock:(NSString*)block;
- (void) preprocessCells;

- (IBAction) viewToggle:(id)sender;
- (IBAction) doBookmark:(id)sender;
- (IBAction) doEmailStudy:(id)sender;
- (IBAction) doEmailContact:(id)sender;
- (IBAction) doCallContact:(id)sender;
- (IBAction) doJump:(id)sender;
- (IBAction) finishJump:(id)sender;
- (IBAction) cancelJump:(id)sender;

- (void) finalizeBookmark;

- (void) showStubAlert;
- (void) updateBookmarkInfo:(NSString*)notes;

@end
