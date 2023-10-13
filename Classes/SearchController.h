//
//  SearchController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchController : UIViewController {
#if 1
	IBOutlet	UITableView*				myTable;
	NSArray*								searchControllers;
	NSArray*								menuOptions;
#else
	UISegmentedControl*						searchChoice;
	UIView*									activeSearchView;
	NSArray*								searchViews;
	NSArray*								menuOptions;
	IBOutlet	UIView*						basicSearchView;
	IBOutlet	UIView*						advancedSearchView;
	IBOutlet	UIView*						mapSearchView;
	
	IBOutlet	UITextField*				basicSearchField;
	IBOutlet	UISearchBar*				mySearchBar;
	IBOutlet	UITableView*				myTable;
	NSArray*								listContent;
	NSMutableArray*							filteredListContent;
	
	IBOutlet	UIWebView*					mapView;
#endif
}
@property (nonatomic, assign) CGFloat  screenWidth;

#if 0
@property (nonatomic, retain) NSArray*			listContent;
@property (nonatomic, retain) NSMutableArray*	filteredListContent;

-(IBAction) doBasicSearch:(id)sender;
-(IBAction)selectSearchMethod:(id)sender;
-(void)setBackgroundImageForOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

#endif
@end
