//
//  ProfileManager.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "ProfileManager.h"
#import "ProfileController.h"


@implementation ProfileManager
@synthesize profiles;

+(NSString*)profileFile
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
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/profiles.plist"];
	return prefPath;
} // profileFile

+(NSArray*) profiles
{
	ProfileManager*	pfm = [[ProfileManager alloc] init];
	[pfm readProfiles];
	
	return pfm.profiles;
	
} // profiles

-(void) readProfiles
{
	if(profileDict == nil)
	{
		profileDict = [[NSDictionary dictionaryWithContentsOfFile:[ProfileManager profileFile]] mutableCopy];
		if(!profileDict)
			profileDict = [[NSMutableDictionary alloc] init];
	}
	profiles = [profileDict[@"list"] mutableCopy];
	if(profiles == nil)
	{
		profiles = [NSMutableArray array];
		profileDict[@"list"] = profiles;
	}
	
} // readProfiles

-(void) saveProfiles
{
	profileDict[@"list"] = profiles;
	[profileDict writeToFile:[ProfileManager profileFile] atomically:YES];
} // saveProfiles


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		[self readProfiles];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProfile:)];
	self.navigationItem.leftBarButtonItem = plusButton;
	tmpProfile = nil;
}


-(void) viewDidAppear:(BOOL)animated
{
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Profile List Open"];
#endif
	[super viewDidAppear:animated];
	if(tmpProfile)
	{
		if(addingNewProfile)
		{
			if(tmpProfile.cancelled)
				[profiles removeLastObject];
			else
				[self saveProfiles];
		}
		else if(!tmpProfile.cancelled)
			[self saveProfiles];
			
		tmpProfile = nil;
	}
	[tableView reloadData];
			
} // viewDidAppear

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)addNewProfile:(id)sender
{
	addingNewProfile = YES;
	tmpProfile = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
	NSMutableDictionary *tempInfo = [NSMutableDictionary dictionary];
//	CFUUIDRef myUUIDRef = CFUUIDCreate(nil);
//	NSString* tmpUUID = (NSString*) CFBridgingRelease(CFUUIDCreateString(nil, myUUIDRef));
//	tempInfo[@"vmUUID"] = tmpUUID;
//	CFRelease(myUUIDRef);
    tempInfo[@"vmUUID"] = [[NSUUID UUID] UUIDString];
	[profiles addObject:tempInfo];
	tmpProfile.info = [profiles lastObject];
	[self.navigationController pushViewController:tmpProfile animated:YES];
} // addNewProfile


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#pragma mark table methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
	if(!editing)
		[self saveProfiles];
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [profiles count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"ProfileCell";
    UITableViewCell *cell = nil;
	
	cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	cell.textLabel.text = profiles[indexPath.row][@"profileName"];
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	addingNewProfile = NO;
	tmpProfile = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
	tmpProfile.info = profiles[indexPath.row];
	[self.navigationController pushViewController:tmpProfile animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
} // didSelectRowAtIndexPath

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)theTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)theTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id	item = profiles[sourceIndexPath.row];
    [profiles removeObjectAtIndex:sourceIndexPath.row];
    [profiles insertObject:item atIndex:destinationIndexPath.row];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		NSDictionary*	tmpInfo = profiles[indexPath.row];
		NSString*		vmPath = tmpInfo[@"vmUUID"];
		if(vmPath)
		{
			NSError*		error = nil;
			NSFileManager*	fm = [NSFileManager defaultManager];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = paths[0];
			vmPath = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory ,vmPath];

			if([fm fileExistsAtPath:vmPath])
				[fm removeItemAtPath:vmPath error:&error];
		}
		[profiles removeObjectAtIndex:indexPath.row];
		[theTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}   
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)theTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}

@end
