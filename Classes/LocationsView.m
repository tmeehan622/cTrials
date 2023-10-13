//
//  LocationsView.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/19/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "LocationsView.h"
#import "LocationsCell.h"
#import "GenericParser.h"
#import "TrialViewCell.h"


@implementation LocationsView
@synthesize contacts;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Locations";
} // viewDidLoad

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ContactCell";
	
	LocationsCell *cell;
	cell = (LocationsCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[LocationsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.info = contacts[indexPath.row];
		
	return cell;
} // 	cellForRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
} // didSelectRowAtIndexPath

#if 0
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row % 2)
	{
        [cell setBackgroundColor:[UIColor colorWithRed:.9 green:.9 blue:1 alpha:1]];
	}
	else [cell setBackgroundColor:[UIColor clearColor]];
} // willDisplayCell
#endif

@end
