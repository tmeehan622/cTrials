//
//  ResultsViewController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//
#import "ResultsOptionsHandler.h"
#import "ResultsViewController.h"
#import "ResultCellView.h"
#import "TrialViewController.h"
#import "AdvancedSearchController.h"
#import "StubView.h"

static NSMutableDictionary* gViewedStudies = nil;

@implementation ResultsViewController
@synthesize resultsArray, searchTerms, searchFields, advancedSearchFields, searchURL;
@synthesize showOnlyStudies, shouldReloadAfterToggle,optionsMenuView,mainView;

+(NSString*)cacheFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
	
    BOOL exists = [fileManager fileExistsAtPath:documentsDirectory];
    if (!exists) {
        BOOL success = [fileManager createDirectoryAtPath:documentsDirectory attributes:nil];
        if (!success) {
            NSAssert(0, @"Failed to create Documents directory.");
        }
    }
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/resultsCache.plist"];
	return prefPath;
} // cacheFile

+(NSString*) viewedStudiesFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
	
    BOOL exists = [fileManager fileExistsAtPath:documentsDirectory];
    if (!exists) {
        BOOL success = [fileManager createDirectoryAtPath:documentsDirectory attributes:nil];
        if (!success) {
            NSAssert(0, @"Failed to create Documents directory.");
        }
    }
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/viewedStudies.plist"];
	return prefPath;
} // viewedStudiesFile

+(void) saveViewedStudies
{
	if(gViewedStudies == nil)
		return;
	
	[gViewedStudies writeToFile:[ResultsViewController viewedStudiesFile] atomically:YES];
} // saveViewedStudies

+(void) addViewedAbstract:(NSString*)pmid
{
	gViewedStudies[pmid] = @([NSDate timeIntervalSinceReferenceDate]);
	[ResultsViewController saveViewedStudies];
} // addViewAbstract

+(BOOL) hasBeenViewed:(NSString*)pmid
{
	NSDictionary*	abstracts = [ResultsViewController viewedStudies];
	NSDate* aDate = abstracts[pmid];
	
	return (aDate != nil);
} // hasBeenViewed

+(NSMutableDictionary*)viewedStudies
{
	if(gViewedStudies == nil)
	{
		gViewedStudies = [NSMutableDictionary dictionaryWithContentsOfFile:[ResultsViewController viewedStudiesFile]];
		if(gViewedStudies)
		{
			// we're going to remove items viewed more than 1 week ago
			NSArray*	keys = [gViewedStudies allKeys];
			double		timeThreshold = [NSDate timeIntervalSinceReferenceDate] - 604800.0;
			for(NSString* key in keys)
			{
				if([gViewedStudies[key] doubleValue] - timeThreshold < 0)
					[gViewedStudies removeObjectForKey:key];
			}
			[ResultsViewController saveViewedStudies];
		}
		else
			gViewedStudies = [[NSMutableDictionary alloc] init];
	}
	
	return gViewedStudies;
} // viewedStudies

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
        resultsArray = [NSMutableArray array];
		firstRecord = lastRecord = totalNumberOfRecords = searchStart = 0;
		decimalFormatter = [[NSNumberFormatter alloc] init];
		[decimalFormatter setUsesGroupingSeparator:YES];
		[decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		hasCache = NO;
		showOnlyStudies = kShowAllStudies;
		shouldReloadAfterToggle = NO;
		[self updateItemsPerPage];
    }
    return self;
}

-(void) updateItemsPerPage
{
	int	index = [[NSUserDefaults standardUserDefaults] integerForKey:@"itemsPerPage"];
	switch (index) {
		case 0:
			searchPerPage = 10;
			break;
		case 1:
			searchPerPage = 25;
			break;
		case 2:
			searchPerPage = 50;
			break;
		case 3:
			searchPerPage = 75;
			break;
		case 4:
			searchPerPage = 100;
			break;
		default:
			searchPerPage = 25;
			break;
	}
} // updateItemsPerPage						   

- (void) cacheResults
{
	NSDictionary* tmpDict = @{@"results": resultsArray};
	tmpDict = @{@"results": resultsArray, 
			   @"firstRecord": @(firstRecord),
			   @"lastRecord": @(lastRecord),
			   @"totalNumberOfRecords": @(totalNumberOfRecords)};
	hasCache = [tmpDict writeToFile:[ResultsViewController cacheFile] atomically:YES];
} // cacheResults

- (void) restoreFromCache
{
	NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithContentsOfFile:[ResultsViewController cacheFile]];
	self.resultsArray = nil;
	resultsArray = [tmpDict[@"results"] copy];

	//	NSString*	hint = [NSString stringWithFormat:@"Found %@ records\nShowing %@ - %@",
	//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:totalNumberOfRecords]], 
	//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:firstRecord]], 
	//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:lastRecord]]];
		NSString*	hint = [NSString stringWithFormat:@"Results %@ - %@ of %@",
							[decimalFormatter stringFromNumber:@(firstRecord)], 
							[decimalFormatter stringFromNumber:@(lastRecord)], 
							[decimalFormatter stringFromNumber:@(totalNumberOfRecords)]];
	
	
	resultsHint.text = hint;
	
} // restoreFromCache

- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect orgFrame = CGRectMake(0,0,320,357);
	self.view.frame = orgFrame;
	self.navigationItem.title = @"Results";
	
	optionsMenuTable.backgroundColor = [UIColor clearColor];

	if(hasCache)
	{
		[self restoreFromCache];
		[myTable reloadData];
		busy.hidden = YES;
	}
	
#if 0
	filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Refine Search" style:UIBarButtonItemStylePlain target:self action:@selector(narrowSearch:)];
	self.navigationItem.rightBarButtonItem = filterButton;
	[filterButton release];
#else
	optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(viewToggle:)];
	self.navigationItem.rightBarButtonItem = optionsButton;
#endif
	
	[self adjustArrows];
}

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

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[myTable reloadData];
} // viewDidAppear


-(void) getParserResults:(NSDictionary*)tResults
{
	self.resultsArray = nil;
	resultsArray = [tResults[@"clinical_study"] mutableCopy];
	if([resultsArray isKindOfClass:[NSDictionary class]])
		self.resultsArray = @[resultsArray];
	
	NS_DURING
	totalNumberOfRecords = [tResults[@"attributes"][@"count"] intValue];
	firstRecord = [[resultsArray[0] objectAtPath:@"order"] intValue];
	lastRecord = [[[resultsArray lastObject] objectAtPath:@"order"] intValue];
	NS_HANDLER
	NS_ENDHANDLER
//	NSString*	query = [tResults objectAtPath:@"query"];
//	NSString*	hint = [NSString stringWithFormat:@"Found %@ records\nShowing %@ - %@",
//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:totalNumberOfRecords]], 
//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:firstRecord]], 
//						[decimalFormatter stringFromNumber:[NSNumber numberWithInt:lastRecord]]];
	NSString*	hint = [NSString stringWithFormat:@"Results %@ - %@ of %@",
						[decimalFormatter stringFromNumber:@(firstRecord)], 
						[decimalFormatter stringFromNumber:@(lastRecord)], 
						[decimalFormatter stringFromNumber:@(totalNumberOfRecords)]];
	resultsHint.text = hint;
	[myTable reloadData];
	busy.hidden = YES;
	
#ifdef __DEBUG_OUTPUT__
	NSLog(@"%@", tResults);
#endif
	myTable.alpha = 1;
	[self adjustArrows];
	emailButton.enabled = YES;
	filterButton.enabled = YES;
} // getParserResults

-(void) adjustArrows
{
	[pageArrows setEnabled:(firstRecord > 1) forSegmentAtIndex:0];
	[pageArrows setEnabled:(totalNumberOfRecords > lastRecord) forSegmentAtIndex:1];
	
} // adjustArrows

- (IBAction) doPage:(id)sender
{
	[self updateItemsPerPage];
	
	if([sender selectedSegmentIndex] == 0)
	{
		searchStart -= searchPerPage;
		if(searchStart < 0)
			searchStart = 0;
	}
	else
	{
		searchStart += searchPerPage;
		if(searchStart > totalNumberOfRecords)
			searchStart = totalNumberOfRecords;
	}
	[self searchAddingToHistory:NO];
	
} // doPage

- (NSString*) forceFilterIfNeeded:(NSString*)terms 
{
	NSArray*	inParts = [terms componentsSeparatedByString:@"&"];
	NSArray*	outParts = [NSArray array];
	
	for(NSString* part in inParts)
	{
		if([part hasPrefix:@"recr="])
		{
		} // if
		else
			outParts = [outParts arrayByAddingObject:part];			
	} // for
	
	switch (showOnlyStudies) {
		case kShowAllStudies:
			break;
			
		case kShowOpenStudies:
			outParts = [outParts arrayByAddingObject:@"recr=Open"];
			break;
			
		case kShowClosedStudies:
			outParts = [outParts arrayByAddingObject:@"recr=Closed"];
			break;
	} // switch

	if([outParts count])
		return [outParts componentsJoinedByString:@"&"];
	else
		return terms;
	
} // forceFilterIfNeeded

-(void) searchAddingToHistory:(BOOL)adding 
{
	busy.hidden = NO;
	[self updateItemsPerPage];
	[pageArrows setEnabled:NO forSegmentAtIndex:0];
	[pageArrows setEnabled:NO forSegmentAtIndex:1];
	emailButton.enabled = NO;
	filterButton.enabled = NO;
	
	myTable.alpha = 0.25;
	
	NSString*	searchURLString;
	if(searchURL)
	{
		searchURLString = searchURL;
	}
	else if(searchTerms)
	{
		NSString*	tmpTermsStr = [self forceFilterIfNeeded:searchTerms];
		searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/search?%@&displayxml=true&count=%d&start=%d", tmpTermsStr, searchPerPage, searchStart];
		NSDictionary*	searchDictionary = @{@"text": searchTerms,
											@"searchURL": searchURLString};
		if(adding)
		{
			[[NSNotificationCenter defaultCenter] postNotification:
			 [NSNotification notificationWithName:@"ADD_HISTORY"
										   object:self
										 userInfo:searchDictionary]];
		}
	}
	else if(searchFields)
	{
		NSArray*	tmpTerms = [NSArray array];
		for(NSString*key in [searchFields allKeys])
			tmpTerms = [tmpTerms arrayByAddingObject:[NSString stringWithFormat:@"%@=%@", key, searchFields[key]]];
		NSString*	tmpTermsStr = [self forceFilterIfNeeded:[tmpTerms componentsJoinedByString:@"&"]];
		searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/ct2/results?%@&displayxml=true&count=%d&start=%d", 
						   tmpTermsStr, searchPerPage, searchStart];
		
	} // searchFields

	NSMutableArray*	parts = [[searchURLString componentsSeparatedByString:@"&"] mutableCopy];
	NSString*		lastPart = [parts lastObject];
	if(lastPart)
	{
		if([lastPart hasPrefix:@"start="])
		{
			[parts removeLastObject];
			[parts addObject:[NSString stringWithFormat:@"start=%d", searchStart]];
		}
		searchURLString = [parts componentsJoinedByString:@"&"];
	}
	
#ifdef __DEBUG_OUTPUT__
	NSLog(searchURLString);
#endif
	GenericParser*	gp = [[GenericParser alloc] init];
	[gp downloadAndParse:searchURLString usingDelegate:self];

} // search

-(void) parserTimeout
{
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:@"The server is not responding"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
} // parserTimeout


-(void) parserError:(NSException*)localExcaption
{
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[localExcaption reason]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	

	busy.hidden = YES;
} // parserError

- (IBAction) narrowSearch:(id)sender
{
#if 1
	AdvancedSearchController *aViewController = [[AdvancedSearchController alloc] initWithNibName:@"AdvancedSearchController" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Refine";
	if(searchURL)
		[aViewController mapSearchURLtoRefinedSearch:searchURL];
	else if(searchTerms)
		[aViewController mapSearchURLtoRefinedSearch:searchTerms];
	[self.navigationController pushViewController:aViewController animated:YES];
	
#else	
	if(advancedSearchFields)
	{
	}
	else
	{
	}
	
	UIViewController *aViewController = [[StubView alloc] initWithNibName:@"StubView" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Refine Results";
	[self.navigationController pushViewController:aViewController animated:YES];
	[aViewController release];
#endif
} // narrowSearch

-(IBAction) doEmail:(id)sender
{
    // Don't crash out if the device has no mail addresses set up
    if([MFMailComposeViewController canSendMail] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot compose mail." message:@"This device has not configured any email addresses." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
//	picker.navigationBar.tintColor = ORKOV_TINT_COLOR;
	
	[picker setSubject:@"CTrials Search Results"];
	
	// Fill out the email body
	NSString *emailBody = @"";
	
	for(NSDictionary*d in resultsArray)
	{
		NSString*	title = d[@"title"];
		NSString*	summary = d[@"condition_summary"];
		NSString*	status = [d objectAtPath:@"status/value"];
		NSString*	last_changed = [NSString stringWithFormat:@"Last Changed:%@", d[@"last_changed"]];
		
		if([[d objectAtPath:@"status/attributes/open"] hasPrefix:@"Y"])
			status = [NSString stringWithFormat:@"Open %@", status];
		else
			status = [NSString stringWithFormat:@"Closed %@", status];
			
		emailBody = [emailBody stringByAppendingFormat:@"<h2>%@</h2><p>%@<br/>%@<br/>%@<br/></p>\n<br/>", title, summary, status, last_changed];
	}
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
} // sendAsEmail

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
} // mailComposeController

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [resultsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SearchResultsCell";
    ResultCellView *cell = (ResultCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"ResultCellView" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    /*
    NSString *CellIdentifier = @"SearchResultsCell";
	ResultCellView *cell;
	cell = (ResultCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[ResultCellView alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    */
	NSDictionary*	info = resultsArray[indexPath.row];
	
	cell.info = info;
	cell.label_HeaderNumber.text = [NSString stringWithFormat:@"%ld", indexPath.row+firstRecord];
	return cell;
} // cellForRowAtIndexPath

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row % 2)
	{
        [cell setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:1 alpha:1]];
	}
	else [cell setBackgroundColor:[UIColor clearColor]];
} // willDisplayCell
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ResultsViewController addViewedAbstract:resultsArray[indexPath.row][@"nct_id"]];
	TrialViewController* controller = [[TrialViewController alloc] initWithNibName:@"TrialViewController" bundle:nil];
	controller.basicInfo = resultsArray[indexPath.row];
	
	[self cacheResults];
	[self.navigationController pushViewController:controller animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
} // didSelectRowAtIndexPath

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 96;
} // heightForRowAtIndexPath

#define flipTime 1.0
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self setBackgroundImageForOrientation:toInterfaceOrientation];	
	
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
	CGRect PFrame;
	CGRect LFrame;
	
	UIView *rootView;
	UIView *LView;
	UIView *PView;
	
	
	if(showingOptions)
	{
		PFrame = CGRectMake(0,0,320,436);
		LFrame = CGRectMake(0,0,480,212);
		rootView = self.mainView;
		
	}
	else 
	{
		PFrame = CGRectMake(0,0,320,436);
		LFrame = CGRectMake(0,0,480,276);
		rootView = self.optionsMenuView;
		
	}
	LView = [rootView viewWithTag:101];
	PView = [rootView viewWithTag:100];

	BOOL landscape;
	
	if(toInterfaceOrientation == nil)
		landscape = [self isLandscape];
	else 
		landscape = ((toInterfaceOrientation == UIDeviceOrientationLandscapeRight) || (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft));
	
	if(showingOptions)
	{
		if (landscape)
		{
			//		VSView.hidden = YES;
			PView.hidden = YES;
			LView.hidden = NO;
		//	self.optionsMenuView.frame = LFrame;
			rootView.frame = LFrame;
		}
		else 
		{
			//	VSView.hidden = NO;
			PView.hidden = NO;
			LView.hidden = YES;
		//	self.optionsMenuView.frame = PFrame;
			rootView.frame = PFrame;
		}
	}
	else 
	{
		if (landscape)
		{
			rootView.frame = LFrame;
		}
		else 
		{
			rootView.frame = PFrame;
		}
	}

//	[self.view setNeedsLayout];
	[rootView setNeedsLayout];
}

- (void)dismissOptions
{
	[self dismissModalViewControllerAnimated:YES];
//	if(YES)
	if(shouldReloadAfterToggle)
	{
		shouldReloadAfterToggle = NO;
		searchStart=0;
		[self searchAddingToHistory:YES];
	}
	
}

- (IBAction) viewToggle:(id)sender
{
	ResultsOptionsHandler *controller = [[ResultsOptionsHandler alloc] initWithNibName:@"ResultsOptionsHandler" bundle:nil];
	controller.delegate = self;
    [controller setEdgesForExtendedLayout:UIRectEdgeNone];
    
//    UINavigationController *nav = [[UINavigationController alloc]
//                                   initWithRootViewController:controller];
    
//    controller.extendedLayoutIncludesOpaqueBars=NO;
//    controller.automaticallyAdjustsScrollViewInsets=NO;
    
    // TODO: This controller has a 20pt margin in the xib...it should respect the status bar instead of hardcoding a margin
	controller.modalTransitionStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
}

//- (IBAction) viewToggle:(id)sender
//{
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:flipTime];
////	[setBackgroundImageForOrientation:(UIInterfaceOrientation) nil];
//	[self setBackgroundImageForOrientation:(UIInterfaceOrientation) nil];	
//
//	if(showingOptions)
//	{
//		showingOptions = NO;
//		optionsButton.title = @"Filter";
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//		[optionsMenuView removeFromSuperview];
//		[self.view addSubview:mainView];
//	}
//	else 
//	{
//		showingOptions = YES;
//		optionsButton.title = @"Done";
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//		[mainView removeFromSuperview];
//		[self.view addSubview:optionsMenuView];
//	}
//	[UIView commitAnimations];
//	
//	if(shouldReloadAfterToggle)
//	{
//		shouldReloadAfterToggle = NO;
//		searchStart=0;
//		[self searchAddingToHistory:YES];
//	}
//} // viewToggle


@end
