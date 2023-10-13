//
//  WhateverListController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 3/11/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "WhateverListController.h"

@implementation WhateverListController
@synthesize masterList, key, headerString, sender;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (instancetype)initWithTitle:(NSString *)aTitle list:(NSArray*)dList key:(NSString*)dKey initialSelections:(NSArray*)initialSelection sender:(id)dSender
{
    if (self = [super initWithNibName:@"WhateverList" bundle:nil]) {
		self.masterList = dList;
		self.headerString = aTitle;
		self.key = dKey;
		self.sender = dSender;
		selectedIndexes = [initialSelection mutableCopy];
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[sender changeSelection:selectedIndexes forHeading:headerString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title=headerString;
} // viewDidLoad


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [masterList count];
}

#if 0

this seems redundant when the navigationItem shows the same text
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return headerString;
} // titleForHeaderInSection
#endif

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WhateverCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
	
    // Set up the cell...
	if(key)
		cell.textLabel.text = masterList[indexPath.row][key];
	else
		cell.textLabel.text = masterList[indexPath.row];
		
	if([selectedIndexes[indexPath.row] boolValue])
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
		
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int selectedIndex = indexPath.row;
	BOOL newValue = ![selectedIndexes[selectedIndex] boolValue];
	
	selectedIndexes[selectedIndex] = @(newValue);
	UITableViewCell* xCell = [tableView cellForRowAtIndexPath:indexPath];
	xCell.selected = YES;
	xCell.accessoryType = newValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




@end

