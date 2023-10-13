//
//  ResultsOptionsHandler.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/18/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "ResultsOptionsHandler.h"
#import "ResultsViewController.h"
#import "GradientCell.h"
#import "StylishIconCell.h"

@implementation ResultsOptionsHandler
@synthesize myController,delegate;
-(void) awakeFromNib
{
	UIDevice*	me = [UIDevice currentDevice];
	NSString*	ima = [me.model uppercaseString];
[self setBackgroundImageForOrientation:(UIInterfaceOrientation)nil];
	menuOptions = @[@"Show all studies", @"Show only open studies", @"Show only closed studies", @"Email these results"];

} // awakeFromNib
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

-(IBAction)done
{
	
	[delegate dismissOptions];	
	
}
-(void)viewWillAppear:(BOOL)animated
{
	[self setBackgroundImageForOrientation:(UIInterfaceOrientation) nil];
	myController = delegate;
	myController.shouldReloadAfterToggle = NO;	
}
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
	 myController = delegate;
	 menuOptions = @[@"Show all studies", @"Show only open studies", @"Show only closed studies", @"Email these results"];
 }

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self setBackgroundImageForOrientation:toInterfaceOrientation];	
	
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
//	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
	 return (YES);
 }


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	CGRect PFrame = CGRectMake(21,100,280,239);
	CGRect LFrame = CGRectMake(0,0,480,280);
//	CGRect PFrame = myTable.frame;
//	CGRect LFrame = myTable.frame;
	
	CGFloat pheight = 60;
	CGFloat lheight = 56;
	CGFloat lwidth = 280;
	CGFloat ypos = 55;
	
	LFrame.origin.y = ypos;
	LFrame.size.width = lwidth;
	LFrame.size.height = 4 * lheight + 15;
	LFrame.origin.x = (480 - lwidth)/2 ;
	
	
	UIView *rootView = self.view;
	UIView *LView;
	UIView *PView;
	UIView *VSView;
	
	LView = [rootView viewWithTag:101];
	PView = [rootView viewWithTag:100];
	VSView = [rootView viewWithTag:200];
	
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
		myTable.rowHeight = lheight;
		myTable.frame = LFrame;
	}
	else 
	{
		VSView.hidden = NO;
		PView.hidden = NO;
		LView.hidden = YES;
		myTable.rowHeight = pheight;
		myTable.frame = PFrame;
	}
	
	//	[self.view setNeedsLayout];
	[rootView setNeedsLayout];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
} // numberOfSectionsInTableView


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
//	return [menuOptions count];
} // numberOfRowsInSection


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

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
    [cell setTitle:menuOptions[indexPath.row]];
    /*
    static NSString *CellIdentifier = @"TermCell";
  //  GradientCell *cell = (GradientCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GradientCell *cell=nil;
    if (cell == nil) {
        cell = [[GradientCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		cell.textLabel.numberOfLines = 2;
    }
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.text = menuOptions[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    */
	switch (indexPath.row) {
		case 0:
			[cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_StudiesAll"]];
			break;
		case 1:
			[cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_StudiesOpen"]];
			break;
		case 2:
			[cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_StudiesClosed"]];
			break;
		case 3:
			[cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Email"]];
			break;
		default:
			break;
	}
	
	return cell;
} // cellForRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch(indexPath.row)
	{
		case 0:
			myController.showOnlyStudies = kShowAllStudies;
			myController.shouldReloadAfterToggle = YES;
			//[myController viewToggle:self];
			[self done];
			break;
			
		case 1:
			myController.showOnlyStudies = kShowOpenStudies;
			myController.shouldReloadAfterToggle = YES;
			//[myController viewToggle:self];
			[self done];
			break;
			
		case 2:
			myController.showOnlyStudies = kShowClosedStudies;
			myController.shouldReloadAfterToggle = YES;
			//[myController viewToggle:self];
			[self done];
			break;
			
		case 3:
			[myController doEmail:self];
			break;
			
	} // switch

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

} // didSelectRowAtIndexPath

@end
