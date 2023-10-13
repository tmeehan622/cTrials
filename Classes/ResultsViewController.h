//
//  ResultsViewController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GenericParser.h"

enum {kShowAllStudies = 0, kShowOpenStudies, kShowClosedStudies};

@class ResultsOptionsHandler;

@interface ResultsViewController : UIViewController <MFMailComposeViewControllerDelegate, GenericParserClient> {
	IBOutlet	UIView*				mainView;
	IBOutlet	UIView*				optionsMenuView;

	IBOutlet	UITableView*		myTable;
	IBOutlet	UITableView*		optionsMenuTable;
	IBOutlet	UILabel*			resultsHint;
	IBOutlet	UIView*				busy;
	
	IBOutlet	UISegmentedControl*	pageArrows;
	IBOutlet	UIButton*			emailButton;
	
	IBOutlet	ResultsOptionsHandler*	optionsHandler;
	UIBarButtonItem*					optionsButton;
	
	NSString*						searchURL;
	NSString*						searchTerms;
	NSDictionary*					searchFields;
	NSMutableArray*					resultsArray;
	int								firstRecord;
	int								lastRecord;
	int								totalNumberOfRecords;
	
	int								searchStart;
	int								searchPerPage;

	NSNumberFormatter*				decimalFormatter;

	NSMutableArray*					advancedSearchFields;
	BOOL							hasCache;
	
	UIBarButtonItem*				filterButton;
	int								showOnlyStudies;
	
	BOOL							showingOptions;
	BOOL							shouldReloadAfterToggle;

}


@property (nonatomic, strong) IBOutlet	UIView*				mainView;
@property (nonatomic, strong) UIView			*optionsMenuView;
@property (nonatomic, strong) NSMutableArray*	resultsArray;
@property (nonatomic, strong) NSString*			searchTerms;
@property (nonatomic, strong) NSString*			searchURL;
@property (nonatomic, strong) NSDictionary*		searchFields;
@property (nonatomic, strong) NSMutableArray*	advancedSearchFields;
@property (nonatomic, assign) int						showOnlyStudies;
@property (nonatomic, assign) BOOL						shouldReloadAfterToggle;

+(NSString*)cacheFile;
+(NSString*) viewedStudiesFile;
+(void) saveViewedStudies;
+(void) addViewedAbstract:(NSString*)pmid;
+(NSMutableDictionary*)viewedStudies;
+(BOOL) hasBeenViewed:(NSString*)pmid;

- (void) searchAddingToHistory:(BOOL)adding;
- (void) updateItemsPerPage;

- (IBAction) narrowSearch:(id)sender;
- (IBAction) doPage:(id)sender;
- (IBAction) doEmail:(id)sender;
- (IBAction) viewToggle:(id)sender;
- (IBAction)dismissOptions;

- (void) adjustArrows;

- (void) cacheResults;
- (void) restoreFromCache;
- (NSString*) forceFilterIfNeeded:(NSString*)terms;

@end
