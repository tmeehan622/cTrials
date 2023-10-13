//
//  OptionsHandler.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/18/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "OptionsHandler.h"
#import "TrialViewController.h"
#import "GradientCell.h"
#import "StylishIconCell.h"

@implementation OptionsHandler

-(void) awakeFromNib
{
	UIDevice*	me = [UIDevice currentDevice];
	NSString*	ima = [me.model uppercaseString];

#if 0
	if(([ima hasSuffix:@"SIMULATOR"] || [ima hasPrefix:@"IPOD"]))
		menuOptions = [[NSArray arrayWithObjects:@"Add this study to favorites", @"Send this study info via Email", @"Contact this study info via Email", nil] retain];
	else
#endif
		menuOptions = @[@"Add this study to favorites", @"Send this study info via Email", @"Contact this study info via Email", @"Contact this study info via phone"];

} // awakeFromNib

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
} // numberOfSectionsInTableView


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuOptions count];
} // numberOfRowsInSection

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TermCell";
    
    GradientCell *cell = (GradientCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GradientCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		cell.textLabel.numberOfLines = 2;
    }
	
	cell.textLabel.text = menuOptions[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	switch (indexPath.row) {
		case 0:
			cell.imageView.image = [UIImage imageNamed:@"Notes.png"];
			break;
		case 1:
			cell.imageView.image = [UIImage imageNamed:@"Mail.png"];
			break;
		case 2:
			cell.imageView.image = [UIImage imageNamed:@"Mail.png"];
			break;
		case 3:
			cell.imageView.image = [UIImage imageNamed:@"Phone.png"];
			break;
			
		default:
			break;
	}
	
	return cell;
} // cellForRowAtIndexPath
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"TermCell";
    StylishIconCell *cell = (StylishIconCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"StylishIconCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell = [[StylishIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setTitle:menuOptions[indexPath.row]];
    switch (indexPath.row) {
        case 0:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Favorites"]];
            break;
        case 1:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Email"]];
            break;
        case 2:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Email"]];
            break;
        case 3:
            [cell setIconImage:[UIImage imageNamed:@"Cell_SearchIcon_Call"]];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch(indexPath.row)
	{
		case 0:
			[myController doBookmark:self];
			break;
			
		case 1:
			[myController doEmailStudy:self];
			break;
			
		case 2:
			[myController doEmailContact:self];
			break;
			
		case 3:
			[myController doCallContact:self];
			break;
	} // switch

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

} // didSelectRowAtIndexPath

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Options Open"];
#endif
}


@end
