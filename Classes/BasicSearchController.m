//
//  BasicSearchController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "BasicSearchController.h"
#import "ResultsViewController.h"
#import "History.h"


@implementation BasicSearchController
@synthesize listContent, filteredListContent, currentSearchString, historySearchIndex, myTable;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		NSArray* tmpList = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"conditions" ofType:@"csv"]] componentsSeparatedByString:@"\n"];
		tmpList = [tmpList arrayByAddingObjectsFromArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"diet" ofType:@"csv"]] componentsSeparatedByString:@"\n"]];
		tmpList = [tmpList arrayByAddingObjectsFromArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"locations" ofType:@"csv"]] componentsSeparatedByString:@"\n"]];
		tmpList = [tmpList arrayByAddingObjectsFromArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interventions" ofType:@"csv"]] componentsSeparatedByString:@"\n"]];
		tmpList = [tmpList arrayByAddingObjectsFromArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rare" ofType:@"csv"]] componentsSeparatedByString:@"\n"]];
		tmpList = [tmpList arrayByAddingObjectsFromArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sponsors" ofType:@"csv"]] componentsSeparatedByString:@"\n"]];

        self.listContent = [tmpList sortedArrayUsingSelector:@selector(compare:)];
		currentSearchString = nil;
		[self loadHistory];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToHistoryListner:) name:@"ADD_HISTORY" object:nil];

	}
    return self;
}


-(void) viewDidAppear:(BOOL)animated
{
#ifndef __DEBUG_OUTPUT__
		[Flurry logEvent:@"Basic Search Open"];
#endif
	
	[super viewDidAppear:animated];
	if(currentSearchString)
		mySearchBar.text = currentSearchString;

	if(historySearchIndex >= 0)
		[self doHistorySearch:historySearchIndex];
	
	historySearchIndex = -1;
	
	if(historyButton)
		historyButton.hidden = ![searchHistory count];
	
} // viewDidAppear

- (void)viewDidLoad
{
    [super viewDidLoad];
	myTable.hidden = YES;
	historySearchIndex = -1;

	UIBarButtonItem*	searchButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Search",@"")
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(doSearch:)];
	
	self.navigationItem.rightBarButtonItem = searchButton;
//	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];

} // viewDidLoad

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



-(IBAction) doSearch:(id)sender
{
	NSString*	term = self.currentSearchString;
	term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];

	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	controller.searchTerms = [@"term=" stringByAppendingString:term];
	[self.navigationController pushViewController:controller animated:YES];
	[controller searchAddingToHistory:YES];
	
} // doSearch

-(void)doHistorySearch:(int)row
{
	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	NSDictionary*	savedSearch = searchHistory[row];
	NSString*	searchURL = savedSearch[@"searchURL"];
	controller.searchURL = searchURL;
	[self.navigationController pushViewController:controller animated:YES];
	[controller searchAddingToHistory:NO];
} // doHistorySearch


#pragma mark history
-(IBAction) doHistory:(id)sender
{
	History	*controller = [[History alloc] initWithNibName:@"History" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	controller.delegate = self;
	controller.history = searchHistory;
} // doHistory

- (void) addToHistory:(NSDictionary*)searchDictionary
{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ADD_HISTORY"
																						 object:self
																					   userInfo:searchDictionary]];
} // addToHistory

- (void) addToHistoryListner:(NSNotification*)notification
{
	[self _addToHistory:[notification userInfo]];
} // addToHistoryListner

- (void) _addToHistory:(NSDictionary*)searchDictionary
{
	if([searchHistory count] > 10)
		[searchHistory removeLastObject];
	
	[searchHistory insertObject:searchDictionary atIndex:0];		// put it on top
	[self saveHistory];
} // addToHistory

- (void) loadHistory
{
	searchHistory = [NSMutableArray array];
	NSArray*	savedHistory = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
	if(savedHistory)
		[searchHistory addObjectsFromArray:savedHistory];
} // loadHistory

- (void) saveHistory
{
	[[NSUserDefaults standardUserDefaults] setObject:searchHistory forKey:@"history"];
	[[NSUserDefaults standardUserDefaults] synchronize];
} // saveHistory

- (void) clearHistory
{
	[searchHistory removeAllObjects];
	[self saveHistory];
} // clearHistory


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
} // numberOfSectionsInTableView


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TermCell";
    
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
	if (tableView == self.searchDisplayController.searchResultsTableView)
		cell.textLabel.text = filteredListContent[indexPath.row];
	else
		cell.textLabel.text = listContent[indexPath.row];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
} // cellForRowAtIndexPath


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString*	term;
	[self.searchDisplayController setActive:NO animated:YES];

	if (tableView == self.searchDisplayController.searchResultsTableView)
		term = filteredListContent[indexPath.row];
	else
		term = listContent[indexPath.row];

	self.currentSearchString = term;

	term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];

	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	controller.searchTerms = [@"term=" stringByAppendingString:term];
	[controller searchAddingToHistory:YES];
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
} // didSelectRowAtIndexPath


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSString* term in listContent)
	{
		if ([scope isEqualToString:@"All"] /* || [product.type isEqualToString:scope] */)
		{
            NSInteger len = MIN(term.length, searchText.length);
			NSComparisonResult result = [term compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, len)];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:term];
            }
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:@"All"];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
} // searchBarShouldEndEditing

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText length])
		self.currentSearchString = searchText;
	
	myTable.hidden = ![searchText length];
} // searchBarTextDidBeginEditing

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	myTable.hidden = YES;
} // searchBarTextDidEndEditing

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	[self.searchDisplayController setActive:NO animated:YES];
	[self doSearch:searchBar];
} // searchBarSearchButtonClicked

@end
