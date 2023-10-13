//
//  SearchController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "SearchController.h"
#import "AdvancedSearchController.h"
#import "MapSearchController.h"
#import "GenericParser.h"
#import "ResultsViewController.h"
#import "GradientCell.h"
#import "Registration.h"
#import "StylishIconCell.h"
//#import "GlobeView.h"
#import "WorldCountries.h"

enum {kRecent14=0, kRecent60, kBasicSearch, kAdvancedSearch, kSearchOnMap};

@implementation SearchController
#if 0
@synthesize listContent, filteredListContent;
#endif
@synthesize screenWidth;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		menuOptions = @[@"Added in the Last 14 Days", @"Added in the Last 60 Days", @"Basic Search", @"Advanced Search", @"Search by Country"];
#if 0
        self.listContent = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"conditions" ofType:@"csv"]] componentsSeparatedByString:@"\n"];
#endif
    }
    return self;
}

-(BOOL) isLandscape
{
	
	if(([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft))
		return YES;
	else 
		return NO;
}

-(void)setBackgroundImageForOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	
	UIView *rootView = self.view;
	UIView *LView = [rootView viewWithTag:101];
	UIView *PView = [rootView viewWithTag:100];
	UIView *VSView = [rootView viewWithTag:200];
	
	BOOL landscape;
	
	if(toInterfaceOrientation == nil)
		landscape = [self isLandscape];
	else 
		landscape = ((toInterfaceOrientation == UIDeviceOrientationLandscapeRight) || (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft));
	
	
	if (landscape)
	{
		VSView.hidden = YES;
		PView.hidden = YES;
		LView.hidden = NO;
	}
	else 
	{
		VSView.hidden = NO;
		PView.hidden = NO;
		LView.hidden = YES;
	}
	
	[rootView setNeedsLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
	
	[self setBackgroundImageForOrientation:(UIInterfaceOrientation)nil];	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenWidth = [UIScreen mainScreen].nativeBounds.size.width;

	myTable.backgroundColor = [UIColor clearColor];
	//self.title = @"ClinicalTrials.gov on iPhone";
    self.title = @"Search";
    [self.navigationItem setTitle:@"ClinicalTrials.gov on iPhone"];
    
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
    
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
	
	
#if 0
	myTable.hidden = YES;
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	[searchButton release];

	NSString*	mapPath = [[NSBundle mainBundle] pathForResource:@"usamap" ofType:@"html"];
	[mapView loadRequest :[NSURLRequest requestWithURL:[NSURL fileURLWithPath:mapPath]]];
	
	searchViews = [[NSArray arrayWithObjects:basicSearchView, advancedSearchView, mapSearchView, nil] retain];
	searchChoice = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Basic", @"Search", @"Map", nil]];
	searchChoice.segmentedControlStyle = UISegmentedControlStyleBar;
	searchChoice.selectedSegmentIndex = 0;
	[searchChoice addTarget:self action:@selector(selectSearchMethod:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = searchChoice;
	[self selectSearchMethod:self];
	[searchChoice release];
	
	searchControllers = [NSArray array];
	
	UIViewController *aViewController = [[BasicSearchController alloc] initWithNibName:@"BasicSearchController" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Basic";
	searchControllers = [searchControllers arrayByAddingObject:aViewController];
	//	[self.view addSubview:[aViewController view]];
	[aViewController release];
	
	aViewController = [[AdvancedSearchController alloc] initWithNibName:@"AdvancedSearchController" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Advanced";
	searchControllers = [searchControllers arrayByAddingObject:aViewController];
	[aViewController release];

	MapSearchController *mViewController = [[MapSearchController alloc] initWithNibName:@"MapSearchController" bundle:[NSBundle mainBundle]];
	mViewController.title = @"Search by Country";
	searchControllers = [searchControllers arrayByAddingObject:mViewController];
	[self.view addSubview:[mViewController view]];
	[mViewController release];
	
#endif
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
[self setBackgroundImageForOrientation:toInterfaceOrientation];	
	
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#if 1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
} // numberOfSectionsInTableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
} // heightForRowAtIndexPath


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuOptions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"AdvancedCell";
    StylishIconCell *cell = (StylishIconCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"StylishIconCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell = [[StylishIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.screenWidth < 750.0){
        UILabel *ttl = (UILabel*)[cell.contentView viewWithTag:100];
        ttl.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }
    [cell setTitle:menuOptions[indexPath.row]];
    switch (indexPath.row) {
        case kRecent14:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Last14"]];
            break;
        case kRecent60:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Last60"]];
            break;
        case kBasicSearch:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Basic"]];
            break;
        case kAdvancedSearch:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Advanced"]];
            break;
        case kSearchOnMap:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Country"]];
            break;
            
        default:
            break;
    }
    
    /*
    static NSString *CellIdentifier = @"MenuCell";
    
    GradientCell *cell = (GradientCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GradientCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }

	cell.textLabel.text = menuOptions[indexPath.row];
	switch (indexPath.row) {
		case kRecent14:
			cell.imageView.image = [UIImage imageNamed:@"New14.png"];
			break;
		case kRecent60:
			cell.imageView.image = [UIImage imageNamed:@"New60.png"];
			break;
		case kBasicSearch:
			cell.imageView.image = [UIImage imageNamed:@"basicSearch.png"];
			break;
		case kAdvancedSearch:
			cell.imageView.image = [UIImage imageNamed:@"advancedSearch.png"];
			break;
		case kSearchOnMap:
			cell.imageView.image = [UIImage imageNamed:@"smallglobe.png"];
			break;
			
		default:
			break;
	}
	*/
    
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
} // cellForRowAtIndexPath


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
			
		case kRecent14:
		{
			NSDictionary*	term = @{@"rcv_d": @"14"};
			ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
			controller.searchFields = term;
			[self.navigationController pushViewController:controller animated:YES];
			[controller searchAddingToHistory:YES];
		}
			break;
			
		case kRecent60:
		{
			NSDictionary*	term = @{@"rcv_d": @"60"};
			ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
			controller.searchFields = term;
			[self.navigationController pushViewController:controller animated:YES];
			[controller searchAddingToHistory:YES];
		}
			break;
			
		case kBasicSearch:
		{
			UIViewController *aViewController = [[BasicSearchController alloc] initWithNibName:@"BasicSearchController" bundle:[NSBundle mainBundle]];
			aViewController.title = @"Basic";
			[self.navigationController pushViewController:aViewController animated:YES];
		}			
			break;
		case kAdvancedSearch:
		{
			UIViewController *aViewController = [[AdvancedSearchController alloc] initWithNibName:@"AdvancedSearchController" bundle:[NSBundle mainBundle]];
			aViewController.title = @"Advanced";
			[self.navigationController pushViewController:aViewController animated:YES];
		}
			break;
		case kSearchOnMap:
		{
#if 0
			MapSearchController *aViewController = [[MapSearchController alloc] initWithNibName:@"MapSearchController" bundle:[NSBundle mainBundle]];
			aViewController.title = @"Search by Country";
			[self.navigationController pushViewController:aViewController animated:YES];
			[aViewController release];
#else
            WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            
            // This globe does nothing - remove it
//			GlobeView*	aViewController = [[GlobeView alloc] initWithNibName:@"GlobeView" bundle:[NSBundle mainBundle]];
//			aViewController.title = @"Search By Country";
//			[self.navigationController pushViewController:aViewController animated:YES];
#endif
		}			
			break;
			
		default:
			break;
	}
    
    // This is a bit hacky, but it's better than going into each controller's implementation and setting edges.
    for(UIViewController *c in self.navigationController.childViewControllers)
    {
        [c setEdgesForExtendedLayout:UIRectEdgeNone];
    }
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
} // didSelectRowAtIndexPath
#else

-(IBAction)selectSearchMethod:(id)sender
{
	if(activeSearchView)
		[activeSearchView removeFromSuperview];
	
	activeSearchView = [searchViews objectAtIndex:searchChoice.selectedSegmentIndex];
	[self.view addSubview:activeSearchView];
} // selectSearchMethod

-(IBAction) doBasicSearch:(id)sender
{
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"doBasicSearch"];
#endif
	NSString*	term = mySearchBar.text;
	term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString*	searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/search?term=%@&displayxml=true&count=200", term];
	
	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	
	GenericParser*	gp = [[GenericParser alloc] init];
	[gp downloadAndParse:searchURLString usingDelegate:controller];
	[controller release];
	
} // doBasicSearch

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
} // numberOfSectionsInTableView

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(tableView == self.searchDisplayController.searchResultsTableView)
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
    
    GradientCell *cell = (GradientCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GradientCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
	if (tableView == self.searchDisplayController.searchResultsTableView)
		cell.textLabel.text = [filteredListContent objectAtIndex:indexPath.row];
	else
		cell.textLabel.text = [listContent objectAtIndex:indexPath.row];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
} // cellForRowAtIndexPath


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString*	term;
	[self.searchDisplayController setActive:NO animated:YES];
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
		term = [filteredListContent objectAtIndex:indexPath.row];
	else
		term = [listContent objectAtIndex:indexPath.row];
	
	term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString*	searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/search?term=%@&displayxml=true&count=99999999", term];
	
	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	
	GenericParser*	gp = [[GenericParser alloc] init];
	[gp downloadAndParse:searchURLString usingDelegate:controller];
	[controller release];
	
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
			NSComparisonResult result = [term compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
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
	[self doBasicSearch:searchBar];
} // searchBarSearchButtonClicked

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{	
	NSURL*		dest = [request URL];
	
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		NSString*	scheme = [dest scheme];
		NSString*	resourceSpecifier = [[[dest resourceSpecifier] substringFromIndex:2] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
		
		if([scheme isEqualToString:@"maptouch"])
		{
			//			NSString*	searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/ct2/results?term=&recr=&rslt=&type=&cond=&intr=&outc=&lead=&spons=&id=&state1=NA%3AUS%3A%@&cntry1=&state2=&cntry2=&state3=&cntry3=&locn=&gndr=&rcv_s=&rcv_e=&lup_s=&lup_e=&displayxml=true&count=99999999", resourceSpecifier];
			NSString*	searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/ct2/results?state1=NA:US:%@&displayxml=true&count=100", resourceSpecifier];
#ifdef __DEBUG_OUTPUT__
			NSLog(@"%@", [searchURLString stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]);
#endif
			ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
			[self.navigationController pushViewController:controller animated:YES];
			
			GenericParser*	gp = [[GenericParser alloc] init];
			[gp downloadAndParse:searchURLString usingDelegate:controller];
			[controller release];
		}
		
	}
	
	return YES;
}

#endif

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

	NSDictionary    *regInfo = [Registration registrationInfo];		// forces an expiration date
	NSDate          *expireDate = regInfo[@"expireDate"];
	NSDate          *gracePeriod = [[NSDate alloc] initWithTimeInterval:604800.0 sinceDate:expireDate];
	NSDate          *warningPeriod = [[NSDate alloc] initWithTimeInterval:-604800.0 sinceDate:expireDate];
	NSString        *key = regInfo[@"licenseKey"];
	NSDate          *now = [NSDate date];
	
	BOOL	expired = ([now timeIntervalSinceReferenceDate] > [expireDate timeIntervalSinceReferenceDate]);
	int		inGracePeriod = (([gracePeriod timeIntervalSinceReferenceDate] - [now timeIntervalSinceReferenceDate])/86400.0) + 1;
	int		inWarningPeriod = 8 - (([now timeIntervalSinceReferenceDate] - [warningPeriod timeIntervalSinceReferenceDate])/86400.0);
	
	
#if 0
	if(inGracePeriod < 0)
		inGracePeriod = 0;
	
	if(inGracePeriod > 7)
		inGracePeriod = 0;
	
	if(inWarningPeriod < 0)
		inWarningPeriod = 0;
	
	if(inWarningPeriod > 7)
		inWarningPeriod = 0;
	
	if(inWarningPeriod || inGracePeriod)
	{
		NSString*	term = @"trial";
		if(key && [key length])
			term = @"license";
		
		NSString*	timePeriod = ((inWarningPeriod | inGracePeriod) == 1) ? @"is 1 day" : [NSString stringWithFormat:@"are %d days", inWarningPeriod | inGracePeriod];
		
		NSString*	message;
		if(inGracePeriod)
			message = [NSString stringWithFormat:@"Your %@ has expired. There %@ before your grace period expires.", term, timePeriod];
		else
			message = [NSString stringWithFormat:@"There %@ before your %@ expires.", timePeriod, term];
		
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Warning"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		
		
		return;
	}
	

	if(expired)
	{
		NSString*	message;
		if(key && [key length])
			message = @"Your license has expired. Please renew your subscription.";
		else
			message = @"Your trial period has expired. Please purchase or enter a registration key.";
		
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Expired"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		
		
		Registration*	nextView = [[Registration alloc] initWithNibName:@"Registration" bundle:nil];
		[self.navigationController pushViewController:nextView animated:YES];
	}
#endif
} // 	
@end
