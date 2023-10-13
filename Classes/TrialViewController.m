//
//  TrialViewController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "TrialViewController.h"
#import "TrialViewCell.h"
#import "FavoritesController.h"
#import "QuickChoiceList.h"
#import "ProfileManager.h"
#import "StubView.h"
#import "ContactViaEmail.h"
#import "NotesView.h"
#import "LocationsView.h"
#import "InAppWebBrowser.h"

@implementation TrialViewController
@synthesize basicInfo, detailedInfo, locations;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		tableCellContent = [[NSMutableArray alloc] init];
        tableHeaders = @[@"Tracking Information", @"Descriptive Information", @"Recruitment Information", @"Administrative Information", @"Publications"];
		tableAccessInfo = @[@[@{@"label": @"First Received Date", @"key": @"firstreceived_date"},
						 @{@"label": @"Last Updated Date", @"key": @"lastchanged_date"},
						 
						 @{@"label": @"Start Date", @"key": @"start_date"},
						 @{@"label": @"Enrollment", @"key": @"enrollment/value"},
						 @{@"label": @"Primary Outcome Measures", @"key": @"primary_outcome/measure"},
//						 [NSDictionary dictionaryWithObjectsAndKeys:@"Original Primary Outcome ", @"label", @"primary_outcome/measure", @"key", nil],
//						 [NSDictionary dictionaryWithObjectsAndKeys:@"Change History", @"label", @"", @"key", nil],
						 @{@"label": @"Secondary Outcome Measures", @"primaryKey": @"secondary_outcome", @"multiKey": @[@"measure", @"safety_issue", @"time_frame"]}],
						@[@{@"label": @"Brief Title", @"key": @"brief_title"},
						 @{@"label": @"Official Title", @"key": @"official_title"},
						 @{@"label": @"Brief Summary", @"key": @"brief_summary/textblock"},
						 @{@"label": @"Detailed Description", @"key": @"detailed_description/textblock"},
						 @{@"label": @"Study Phase", @"key": @"phase"},
						 @{@"label": @"Study Type", @"key": @"study_type"},
						 @{@"label": @"Study Design", @"key": @"study_design"},
						 @{@"label": @"Condition", @"key": @"condition"},
						 @{@"label": @"Intervention", @"key": @"intervention"},
						 @{@"label": @"Study Arms / Comparison Groups", @"key": @"arm_group/description"}],
						
						@[@{@"label": @"Recruitment Status", @"key": @"overall_status"},
						 @{@"label": @"Estimated Enrollment", @"key": @"enrollment"},
						 @{@"label": @"Estimated Completion Date", @"key": @"completion_date/value"},
						 @{@"label": @"Estimated Primary Completion Date", @"key": @"primary_completion_date/value"},
						 @{@"label": @"Eligibility Criteria", @"key": @"eligibility/criteria/textblock"},
						 @{@"label": @"Gender", @"key": @"eligibility/gender"},
						 @{@"label": @"Ages", @"key": @[@"eligibility/minimum_age", @"eligibility/maximum_age"], @"separator": @"-"},
						 @{@"label": @"Accepts Healthy Volunteers", @"key": @"eligibility/healthy_volunteers"},
						 @{@"label": @"Contacts", @"primaryKey": @"overall_contact", @"multiKey": @[@"last_name", @"email", @"phone"]},
						 @{@"label": @"Locations", @"primaryKey": @"location", @"secondaryKey": @"facility/address/country"}],
						
						@[@{@"label": @"NCT ID", @"key": @"id_info/nct_id"},
						 @{@"label": @"Responsible Party", @"key": @"responsible_party/name_title"},
						 @{@"label": @"Study ID Numbers", @"key": @"id_info/org_study_id"},
						 @{@"label": @"Sponsors and Collaborators", @"key": @"sponsors"},
						 @{@"label": @"Investigators", @"key": @"overall_official/last_name"},
						 @{@"label": @"Information Provided By", @"key": @"source"},
						 @{@"label": @"Verification Date", @"key": @"verification_date"}],

						   @[@{@"label": @"Publications", @"key": @"resultX"}]];
		
		
    }
    return self;
} // initWithNibName

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This is a bit hacky, but it's better than going into each controller's implementation and setting edges.
    for(UIViewController *c in self.navigationController.childViewControllers)
    {
        [c setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

	CGRect r = jumpContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	jumpContainer.frame = r;
//	jumpContainer.hidden = NO;
	jumpButton.enabled = NO;
	//optionsMenuTable.backgroundColor = [UIColor clearColor];
	
	showingOptions = NO;
	self.navigationItem.title = @"Study";

	NSString*	studyID = [basicInfo objectAtPath:@"nct_id"];
	NSString*	searchURLString = [NSString stringWithFormat:@"http://www.clinicaltrials.gov/ct2/show/%@?rank=1&displayxml=true", studyID];
	
	GenericParser*	gp = [[GenericParser alloc] init];
	[gp downloadAndParse:searchURLString usingDelegate:self];
	
	optionsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Options",@"")
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:@selector(viewToggle:)];
	
	self.navigationItem.rightBarButtonItem = optionsButton;
	self.navigationItem.titleView = jumpButton;

	optionsButton.enabled = NO;
    
    // Views that are not part of the main view in IB must be added to the hierarchy manually
//    [self.view insertSubview:jumpContainer atIndex:100];
    [self.view addSubview:jumpContainer];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Trial View Open"];
#endif
}

-(BOOL)isLandscape
{
	return ([UIDevice currentDevice].orientation != UIInterfaceOrientationPortrait);
}
 
- (IBAction) doJump:(id)sender
{
	jumpButton.enabled = NO;
	optionsButton.enabled = NO;
	[UIView beginAnimations:nil context:@"jumpstart"];
	[UIView setAnimationDuration:0.3];
	CGRect r = jumpContainer.frame;
    r.size.height = self.view.bounds.size.height;
	r.origin.y = 0;
	jumpContainer.frame = r;
	[UIView commitAnimations];
} // doJump

- (IBAction) finishJump:(id)sender
{
	jumpButton.enabled = YES;
	optionsButton.enabled = YES;
	[UIView beginAnimations:nil context:@"jumpfinish"];
	[UIView setAnimationDuration:0.3];
	CGRect r = jumpContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	jumpContainer.frame = r;
	[UIView commitAnimations];
	
	int				index = [jumpPicker selectedRowInComponent:0];
	NSIndexPath*	tableIndex = [NSIndexPath indexPathForRow:0 inSection:index];
	NS_DURING
	[myTable scrollToRowAtIndexPath:tableIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
	NS_HANDLER
	CGSize tSize = myTable.contentSize;
	CGPoint tPoint = {0, tSize.height - self.view.frame.size.height};
	myTable.contentOffset = tPoint;
	NS_ENDHANDLER
} // finishJump

- (IBAction) cancelJump:(id)sender
{
	jumpButton.enabled = YES;
	optionsButton.enabled = YES;
	[UIView beginAnimations:nil context:@"cancelJump"];
	[UIView setAnimationDuration:0.3];
	CGRect r = jumpContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	jumpContainer.frame = r;
	[UIView commitAnimations];
	
} // cancelJump

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
} // numberOfComponentsInPickerView

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [tableHeaders count];
} // numberOfRowsInComponent

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return tableHeaders[row];
} // titleForRow


// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//	BOOL G = interfaceOrientation == UIInterfaceOrientationPortrait;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



-(void) getParserResults:(NSDictionary*)tResults
{
	self.detailedInfo = tResults;
#ifdef __DEBUG_OUTPUT__
//	NSLog(@"%@", tResults);
#endif

	busy.hidden = YES;
	[self preprocessCells];
	[myTable reloadData];
	
	UIDevice*	me = [UIDevice currentDevice];
	NSString*	ima = [me.model uppercaseString];
		
	if(([ima hasSuffix:@"SIMULATOR"] || [ima hasPrefix:@"IPOD"]))
		contactCallButton.hidden = YES;
	
	optionsButton.enabled = YES;
	jumpButton.enabled = YES;
	
} // getParserResults


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

- (NSString*) reformTextBlock:(NSString*)block
{
	NSString*	cleanText = block;
	NS_DURING
	NSArray*	dirtyTextArray = [block componentsSeparatedByString:@"\n"];
	NSArray*	cleanTextArray = @[];
	if([dirtyTextArray count] < 2)
		return block;
	
	NSString*	testLine = dirtyTextArray[1];
	int	padSize = [testLine length] -
		[[testLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];

	for(NSString*s in dirtyTextArray)
	{
		NSString*	trimmedString = s;
		if([s length] > padSize)
			trimmedString = [s substringFromIndex:padSize];
		else if([s length] == 0)
			trimmedString = @"\n";
		cleanTextArray = [cleanTextArray arrayByAddingObject:trimmedString];
	}
	cleanText = [[cleanTextArray componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NS_HANDLER
	cleanText = @"";
	NS_ENDHANDLER
	
	return cleanText;
} // reformTextBlock

- (NSString*) stringForKeys:(NSArray*)keys separatedBy:(NSString*)separator
{
	if([keys isKindOfClass:[NSString class]])
	{
		NSString*	key = (NSString*) keys;
		return [detailedInfo objectAtPath:key];
	}
	
	NSArray*	parts = @[];
	for(NSString*key in keys)
	{
		NS_DURING
		parts = [parts arrayByAddingObject:[detailedInfo objectAtPath:key]];
		NS_HANDLER
		NS_ENDHANDLER
	}
	
	return [parts componentsJoinedByString:separator];
} // stringForKeys

- (NSString*)stringForPrimaryKey:(NSString*)primaryKey secondaryKey:(NSString*)secondaryKey allowDuplicates:(BOOL)allowDuplicates
{
	NSString*	outputString = @"";
	
	NSArray* target = detailedInfo[primaryKey];
	if(target == nil)
		return outputString;
	
	if(!([target isKindOfClass:[NSArray class]] || [target isKindOfClass:[NSMutableArray class]]))
	   target = @[target];
	
	NSArray*	listItems = @[];
	for(NSDictionary*d in target)
	{
		NSString*	part = [d objectAtPath:secondaryKey];
		if(part && [part length])
		{
			if(allowDuplicates)
				listItems = [listItems arrayByAddingObject:part];
			else if(![listItems containsObject:part])
					listItems = [listItems arrayByAddingObject:part];			
		}
	} // for loop

	outputString = [listItems componentsJoinedByString:@", "];
	return outputString;
} // stringForPrimaryKey

- (void) preprocessCells
{
	int section;
	int row;
	
	self.locations = detailedInfo[@"location"];
	if(locations && ![locations isKindOfClass:[NSArray class]])
		self.locations = @[locations];
	
	[tableCellContent removeAllObjects];
	for(section = 0; section < [tableAccessInfo count]; section++)
	{
		NSMutableArray*	tmpArray = [NSMutableArray array];
		for(row = 0; row < [tableAccessInfo[section] count]; row++)
		{
			NSString*		label = [tableAccessInfo[section][row] objectAtPath:@"label"];
			id				tableKey = [tableAccessInfo[section][row] objectAtPath:@"key"];
			NSArray*		multiKey = [tableAccessInfo[section][row] objectAtPath:@"multiKey"];
			NSString*		primaryKey = [tableAccessInfo[section][row] objectAtPath:@"primaryKey"];
			NSString*		secondaryKey = [tableAccessInfo[section][row] objectAtPath:@"secondaryKey"];
			NSString*		tableValue = @"";
			NSString*		cleanText = @"";
			
			NSDictionary*	additionalInfo = nil;	// cells might have other info too
			
			if(tableKey)
			{
				NS_DURING
				if([tableKey isKindOfClass:[NSArray class]])
				{
					cleanText = [self stringForKeys:tableKey separatedBy:[tableAccessInfo[section][row] objectAtPath:@"separator"]];
				}
				else
				{
					if([tableKey isEqualToString:@"intervention"])
					{
						NSArray*	interventions = [detailedInfo objectAtPath:tableKey];
						if(interventions && ![interventions isKindOfClass:[NSArray class]])
							interventions = @[interventions];
						NSArray*	interventionArray = @[];
						for(NSDictionary*d in interventions)
						{
							interventionArray = [interventionArray arrayByAddingObject:
												 [NSString stringWithFormat:@"• %@: %@\n%@", d[@"intervention_type"], 
												  d[@"intervention_name"], d[@"description"]]];
						}
						cleanText = [interventionArray componentsJoinedByString:@"\n\n"];
					}
					else if([tableKey isEqualToString:@"sponsors"])
					{
						NSArray*	sponsorArray = @[];
						NSString*	lead_sponsor = [detailedInfo objectAtPath:@"sponsors/lead_sponsor/agency"];
						if(lead_sponsor)
							sponsorArray = [sponsorArray arrayByAddingObject:lead_sponsor];
						
						NSArray*	collaborators = [detailedInfo objectAtPath:@"sponsors/collaborator"];
						if(collaborators && ![collaborators isKindOfClass:[NSArray class]])
							collaborators = @[collaborators];
						for(NSDictionary*d in collaborators)
						{
							NSString*s =[d objectAtPath:@"agency"];
							if(s)
								sponsorArray = [sponsorArray arrayByAddingObject:s];
						}
								
						cleanText = [sponsorArray componentsJoinedByString:@"\n"];
					} // sponsors
#if 0
					else if([tableKey isEqualToString:@"results_reference"])
					{
						NSArray*	referenceArray = [NSArray array];
						NSArray*	references = [detailedInfo objectAtPath:@"results_reference"];
						if(references && ![references isKindOfClass:[NSArray class]])
							references = [NSArray arrayWithObject:references];
						
						for(NSDictionary*d in references)
						{
							NSString*s =[d objectAtPath:@"citation"];
							if(s)
								referenceArray = [referenceArray arrayByAddingObject:s];
						}
						cleanText = [referenceArray componentsJoinedByString:@"\n\n"];
					}
#else
					else if([tableKey isEqualToString:@"resultX"])
					{
						NSArray*	pmids = @[];
						NSArray*	referenceArray = @[];
						NSArray*	references = [detailedInfo objectAtPath:@"results_reference"];
						if(references && ![references isKindOfClass:[NSArray class]])
							references = @[references];
						
						for(NSDictionary*d in references)
						{
							NSString*s =[d objectAtPath:@"citation"];
							if(s)
							{
								referenceArray = [referenceArray arrayByAddingObject:s];
								NSString*	pmid = [d objectAtPath:@"PMID"];
								pmids = [pmids arrayByAddingObject:pmid ? pmid : @""];
							}
						}
						
						references = [detailedInfo objectAtPath:@"reference"];
						if(references && ![references isKindOfClass:[NSArray class]])
							references = @[references];

						for(NSDictionary*d in references)
						{
							NSString*s =[d objectAtPath:@"citation"];
							if(s)
							{
								referenceArray = [referenceArray arrayByAddingObject:s];
								NSString*	pmid = [d objectAtPath:@"PMID"];
								pmids = [pmids arrayByAddingObject:pmid ? pmid : @""];
							}
						}
#if 0						
						cleanText = [referenceArray componentsJoinedByString:@"\n\n"];
#else
						additionalInfo = @{@"pmids": pmids};
						int ii;
						for(ii=0; ii< [referenceArray count]; ii++)
						{
							cleanText = referenceArray[ii];
							NSDictionary*	tInfo = @{@"title": @"Publication", 
													 @"text": cleanText, 
													 @"height": @([TrialViewCell neededCellHeightFor:cleanText forWidth:TEXT_WIDTH]), 
													 @"PMID": [pmids[ii] length] ? pmids[ii] : nil};
							[tmpArray addObject:tInfo];
						}
						continue;
#endif
					}
#endif
					else
					{
						if(tableKey)
							tableValue = [detailedInfo objectAtPath:tableKey];
						if([tableKey hasSuffix:@"textblock"])
							cleanText = [self reformTextBlock:tableValue];
						else
							cleanText = tableValue;
					}
				}
				NS_HANDLER
				cleanText = @"";
				NSLog(@"%@=%@", tableKey, tableValue);
				NS_ENDHANDLER
			}
			else if(primaryKey && secondaryKey)
			{
				cleanText = [self stringForPrimaryKey:primaryKey secondaryKey:secondaryKey allowDuplicates:NO];
			}
			else if(primaryKey && multiKey)
			{
				if([primaryKey isEqualToString:@"overall_contact"])
				{
					NSArray*		contactInfoArray = @[];
					NSDictionary*	contactInfo = [detailedInfo objectAtPath:primaryKey];
					id				location = detailedInfo[@"location"];
					if(contactInfo)
					{
						for(NSString* key in multiKey)
						{
							NS_DURING
							contactInfoArray = [contactInfoArray arrayByAddingObject:[contactInfo objectAtPath:key]];
							NS_HANDLER
							NSLog(@"Missing key: \"%@\" for contact.", key);
							NS_ENDHANDLER
						}
						NSDictionary*	backupContactInfo = [detailedInfo objectAtPath:@"overall_contact_backup"];
						if(backupContactInfo)
						{
							contactInfoArray = [contactInfoArray arrayByAddingObject:@""];
							for(NSString* key in multiKey)
							{
								NS_DURING
								contactInfoArray = [contactInfoArray arrayByAddingObject:[backupContactInfo objectAtPath:key]];
								NS_HANDLER
								NSLog(@"barfed trying to add contact info");
								NS_ENDHANDLER
							}
						}
						cleanText = [contactInfoArray componentsJoinedByString:@"\n"];
					}
					else if(location)
					{
						NSDictionary*	locationInfo = location;
						if([location isKindOfClass:[NSArray class]])
							locationInfo = location[0];
						if([locationInfo objectAtPath:@"contact/last_name"] != nil)
							contactInfoArray = [contactInfoArray arrayByAddingObject:[locationInfo objectAtPath:@"contact/last_name"]];
						if([locationInfo objectAtPath:@"contact/phone"] != nil)
							contactInfoArray = [contactInfoArray arrayByAddingObject:[locationInfo objectAtPath:@"contact/phone"]];
						if(contactInfoArray && [contactInfoArray count])
							cleanText = [contactInfoArray componentsJoinedByString:@"\n"];
					}
					else
						cleanText = @"No contact information is provided";
				}
				else if([primaryKey isEqualToString:@"secondary_outcome"])
				{
					NSArray*	secondaryArray = @[];
					NSArray*	secondary_outcome = detailedInfo[@"secondary_outcome"];
					if(secondary_outcome && ![secondary_outcome isKindOfClass:[NSArray class]])
						secondary_outcome = @[secondary_outcome];
					
					for(NSDictionary*d in secondary_outcome)
					{
						NSString* measure = [NSString stringWithFormat:@"• %@", d[@"measure"]];
						NSString* safety_issue = d[@"safety_issue"];
						NSString* time_frame = d[@"time_frame"];
						NSString* tmpText = measure;
						if(time_frame && [time_frame length])
							tmpText = [tmpText stringByAppendingFormat:@" [Time Frame: %@]",time_frame];
						   if(safety_issue && [safety_issue length])
						   tmpText = [tmpText stringByAppendingFormat:@" [Designated as safety issue: %@]",safety_issue];
						secondaryArray = [secondaryArray arrayByAddingObject:tmpText];
					}
					cleanText = [secondaryArray componentsJoinedByString:@"\n\n"];
				}
			}
			else
				continue;
			
			if(cleanText && [cleanText isKindOfClass:[NSString class]] && [cleanText length])
			{
                // Safety - cannot add a nil dictionary to another dictionary
                if(additionalInfo == nil)
                {
                    additionalInfo = [NSDictionary new];
                }
				NSDictionary*	tInfo = @{@"title": label,
										 @"text": cleanText, 
										 @"height": @([TrialViewCell neededCellHeightFor:cleanText forWidth:TEXT_WIDTH]), 
										 @"additionalInfo": additionalInfo};
				[tmpArray addObject:tInfo];
			}
		} // for row
		if([tableCellContent count] == 4 && [tmpArray count] == 0)
		{
			NSString* cleanText = @"None";
			NSDictionary*	tInfo = @{@"title": @"Publications", 
									 @"text": cleanText, 
									 @"height": @([TrialViewCell neededCellHeightFor:cleanText forWidth:TEXT_WIDTH])};
			[tmpArray addObject:tInfo];
		}
		[tableCellContent addObject:tmpArray];
	} // for section
	
} // preprocessCells

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(detailedInfo && [detailedInfo count])
		return [tableAccessInfo count];
	
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tableCellContent[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return tableHeaders[section];
} // titleForHeaderInSection
			
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"TrialCell";
	
	TrialViewCell *cell;
	cell = (TrialViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[TrialViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	cell.info = tableCellContent[indexPath.section][indexPath.row];

	if([(cell.info)[@"title"] isEqualToString:@"Locations"])
	{
		if(locations && [locations count])
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else if((cell.info)[@"PMID"])
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
		

	return cell;
} // cellForRowAtIndexPath

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	double myHeight = [tableCellContent[indexPath.section][indexPath.row][@"height"] doubleValue];
	return myHeight + 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary*	d = tableCellContent[indexPath.section][indexPath.row];
	
	if([d[@"title"] isEqualToString:@"Locations"])
	{
		if(locations && [locations count])
		{
			LocationsView *anotherViewController = [[LocationsView alloc] initWithNibName:@"LocationsView" bundle:nil];
			anotherViewController.contacts = self.locations;
			
			[self.navigationController pushViewController:anotherViewController animated:YES];
		}
	}
	else if(d[@"PMID"])
	{
		InAppWebBrowser*	browser = [[InAppWebBrowser alloc] initWithNibName:@"InAppWebBrowser" bundle:nil];
		browser.destination = [NSString stringWithFormat:@"http://www.ncbi.nlm.nih.gov/pubmed/%@",d[@"PMID"]];
		[self presentModalViewController: browser animated:YES];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
} // didSelectRowAtIndexPath

#define flipTime 1.0

- (IBAction) viewToggle:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:flipTime];
	
	if(showingOptions)
	{
		showingOptions = NO;
		optionsButton.title = @"Options";
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
		[optionsMenuView removeFromSuperview];
		jumpButton.hidden = NO;
		[self.view addSubview:mainView];
	}
	else 
	{
        optionsMenuView.frame = self.view.bounds;
		showingOptions = YES;
		optionsButton.title = @"Done";
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
		[mainView removeFromSuperview];
		jumpButton.hidden = YES;
		[self.view addSubview:optionsMenuView];
	}
	[UIView commitAnimations];
	
} // viewToggle

- (IBAction) doBookmark:(id)sender
{
	NSString*	nct_id = basicInfo[@"nct_id"];
	if([FavoritesController alreadyBookMarked:nct_id])
	{
		alertMode = kAlertModeFavorites;
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Favorites"
														message:@"This study is already in your favorites."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		
	}
	else
		[self finalizeBookmark];

} // doBookmark

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1 && alertMode == kAlertModeFavorites)
	{
		[self finalizeBookmark];
	}
	else if(buttonIndex == 1 && alertMode == kAlertModeContactPhone)
	{
		NSDictionary*	contactInfo = [detailedInfo objectAtPath:@"overall_contact"];
		NSString*	cleanPhoneNumber = [contactInfo objectAtPath:@"phone"];
		cleanPhoneNumber = [cleanPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
		cleanPhoneNumber = [cleanPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
		cleanPhoneNumber = [cleanPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
		//	cleanPhoneNumber = [cleanPhoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
		cleanPhoneNumber = [cleanPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		NSString*	phoneURL = [NSString stringWithFormat:@"tel://%@", cleanPhoneNumber];
		
#if 1
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
#else
		UIWebView*		webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
		NSURL*			tmpURL = [NSURL URLWithString:phoneURL];
		NSURLRequest*	tmpRequest = [NSURLRequest requestWithURL:tmpURL];
		[webview loadRequest:tmpRequest];
		
		// Assume we are in a view controller and have access to self.view
		[self.view addSubview:webview];
		//	[webview removeFromSuperview];
		[webview release];
#endif
	}
	
} // alertView:clickedButtonAtIndex:

- (void) finalizeBookmark
{
	[FavoritesController addBookmark:@{@"detailedInfo": detailedInfo, @"basicInfo": basicInfo}];
	
#if 0
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Favorites"
													message:@"This study has been added to your favorites"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
#else
	NotesView*		nv = [[NotesView alloc] initWithNibName:@"NotesView" bundle:nil];
	nv.noteTitleLabel = [basicInfo objectAtPath:@"title"];
	nv.note = [FavoritesController getNoteForID:[basicInfo objectAtPath:@"nct_id"]];
	nv.noteID = [basicInfo objectAtPath:@"nct_id"];
	nv.delegate = self;
	[self.navigationController pushViewController:nv animated:YES];
	[nv toggleEditing:self];
	
#endif
	
} // finalizeBookmark

-(void) updateBookmarkInfo:(NSString*)notes
{
	[FavoritesController saveNote:notes forID:[basicInfo objectAtPath:@"nct_id"]];
} // updateInfo


- (IBAction) doEmailStudy:(id)sender
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
    
	NSMutableString*	emailBody = [NSMutableString stringWithString:@"<html>\n<head></head>\n<body>\n"];
	int section;
	int row;
	
	for(section = 0; section < [tableCellContent count]; section++)
	{
		[emailBody appendFormat:@"<h2>%@</h2>\n", tableHeaders[section]];
		for(row = 0; row < [tableCellContent[section] count]; row++)
		{
			NSDictionary*	infoBits = tableCellContent[section][row];
			NSString*		pmid = infoBits[@"PMID"];
			if(pmid)
			{
				[emailBody appendFormat:@"<h3>%@</h3>\n<p><a href=%@>%@</a></p><hr/>", 
				 infoBits[@"title"], 
				 [NSString stringWithFormat:@"http://www.ncbi.nlm.nih.gov/pubmed/%@",infoBits[@"PMID"]],
				 infoBits[@"text"]];
			}
			else
				[emailBody appendFormat:@"<h3>%@</h3>\n<p>%@</p><hr/>", infoBits[@"title"], infoBits[@"text"]];
		} // for row
	} // for section
	[emailBody appendString:@"</body>\n</html>\n"];
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	picker.navigationBar.tintColor = ORKOV_TINT_COLOR;
	picker.mailComposeDelegate = self;
	NSString*	title = [detailedInfo objectAtPath:@"brief_title"];
	[picker setSubject:[NSString stringWithFormat:@"Clinical Trial Study Info %@", title]];
	[picker setMessageBody:emailBody isHTML:YES];
	[self presentModalViewController:picker animated:YES];
	
} // doEmailStudy

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
#if __DEBUG_OUTPUT__
	NSLog(@"Email status:%d",result);
#endif
	[self dismissModalViewControllerAnimated:YES];
} // mailComposeController


- (IBAction) doEmailContact:(id)sender
{
	BOOL	canContact = NO;
	NSDictionary*	contactInfo = [detailedInfo objectAtPath:@"overall_contact"];
	if(contactInfo)
	{
		NSString*	contactEmail = [contactInfo objectAtPath:@"email"];
		if(contactEmail != nil)
			canContact = YES;
	}
	
	if(!canContact)
	{
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Contact Error"
														message:@"No contact email information is available"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		
		
		return;
	}
	
	NSArray*	tmpProfiles = @[@{@"profileName": @"None"}];
	tmpProfiles = [tmpProfiles arrayByAddingObjectsFromArray:[ProfileManager profiles]];
	
	QuickChoiceList *anotherViewController = [[QuickChoiceList alloc] initWithNibName:@"QuickChoiceList" bundle:nil];
	anotherViewController.referenceObject = self;
	anotherViewController.referenceList = tmpProfiles;
	anotherViewController.referenceKey = @"profileName";
	anotherViewController.navTitle = @"Select a profile";
	anotherViewController.currentSelection = 0;
	
	[self.navigationController pushViewController:anotherViewController animated:YES];
	
} // doEmailContact

-(void) setChoice:(int)choice forKey:(NSString*) key
{
	NSMutableArray*	newStack = [self.navigationController.viewControllers mutableCopy];
	[newStack removeLastObject];

	int profileIndex = choice-1;
	ContactViaEmail *aViewController = [[ContactViaEmail alloc] initWithNibName:@"ContactViaEmail" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Contact Study";
	if(profileIndex >= 0)
		aViewController.profileInfo = [ProfileManager profiles][profileIndex];
	aViewController.detailedInfo = detailedInfo;
	
	[newStack addObject:aViewController];
	[self.navigationController setViewControllers:newStack animated:YES];
	
} // setChoice

- (IBAction) doCallContact:(id)sender
{
	BOOL			canContact = NO;
	NSString*		contactPhone = nil;
	NSDictionary*	contactInfo = [detailedInfo objectAtPath:@"overall_contact"];
	if(contactInfo)
	{
		contactPhone = [contactInfo objectAtPath:@"phone"];
		if(contactPhone != nil)
			canContact = YES;
	}
	
	if(!canContact)
	{
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Contact Error"
														message:@"No contact phone information is available"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		
		
		return;
	}

	alertMode = kAlertModeContactPhone;
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Warning"
													message:@"Calling will end your session with cTrials. Do you still want to call?"
												   delegate:self
										  cancelButtonTitle:@"NO"
										  otherButtonTitles:@"YES", nil];
	[alert show];
	
	
	
} // doCallContact

- (void) showStubAlert
{
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Stub"
													message:@"This feature is not ready yet"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
} // showStubAlert
@end
