//
//  BasicSearchController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicSearchController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate>{
	IBOutlet	UITextField*				basicSearchField;
	IBOutlet	UISearchBar*				mySearchBar;
	IBOutlet	UITableView*				__weak myTable;
	IBOutlet	UIButton*					historyButton;
	NSArray*								listContent;
	NSMutableArray*							filteredListContent;
	NSString*								currentSearchString;

	NSMutableArray*							searchHistory;
	int										historySearchIndex;

}
@property (nonatomic, strong) NSArray*			listContent;
@property (nonatomic, strong) NSMutableArray*	filteredListContent;
@property (nonatomic, strong) NSString*			currentSearchString;
@property (nonatomic, assign) int				historySearchIndex;
@property (weak, nonatomic, readonly) UITableView*	myTable;

-(IBAction) doSearch:(id)sender;
-(IBAction) doHistory:(id)sender;
- (void) doHistorySearch:(int)row;


- (void) loadHistory;
- (void) saveHistory;
- (void) clearHistory;

- (void) addToHistoryListner:(NSNotification*)notification;
- (void) addToHistory:(NSDictionary*)searchDictionary;
- (void) _addToHistory:(NSDictionary*)searchDictionary;

@end
