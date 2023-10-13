//
//  FavoritesController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "FavoritesController.h"
#import "BookmarkCell.h"
#import "TrialViewController.h"
#import "NotesView.h"
#import "VoiceRecorder.h"

static NSMutableDictionary*	gBookmarks;

@implementation FavoritesController
@synthesize bookmarks;

+(NSString*) bookmarksFile
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
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/bookmarks.plist"];
	return prefPath;
} // bookmarksFile

+(NSMutableDictionary*) gBookmarks
{
	if(gBookmarks == nil)
	{
		gBookmarks = [NSMutableDictionary dictionaryWithContentsOfFile:[FavoritesController bookmarksFile]];
		if(gBookmarks)
			;
		else
			gBookmarks = [[NSMutableDictionary alloc] init];
	}
	
	return gBookmarks;
} // gBookmarks

+(void) saveBookmarks
{
	if([FavoritesController gBookmarks] == nil)
		return;
	
	[gBookmarks writeToFile:[FavoritesController bookmarksFile] atomically:YES];
} // saveBookmarks

+(void) addBookmark:(NSDictionary*)newBM
{
	NSMutableArray*			bmList = [FavoritesController gBookmarks][@"list"];
	
	if(bmList == nil)
		bmList = [NSMutableArray array];
	
	[bmList addObject:newBM];
	[FavoritesController gBookmarks][@"list"] = bmList;
	
	[FavoritesController saveBookmarks];
} // addBookmark

+(NSMutableArray*) bookmarks
{
	NSMutableArray*			bmList = [FavoritesController gBookmarks][@"list"];
	
	if(bmList == nil)
		bmList = [NSMutableArray array];
	
	[FavoritesController gBookmarks][@"list"] = bmList;
	
	return bmList;
} // bookmarksForDB

+(BOOL) alreadyBookMarked:(NSString*)nct_id
{
	for(NSDictionary*d in [FavoritesController bookmarks])
	{
		if([[d objectAtPath:@"basicInfo/nct_id"] isEqualToString:nct_id])
			return YES;
	}
	
	return NO;
} // alreadyBookMarked

+(NSString*)notesFile
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
	
    NSString *prefPath = [documentsDirectory stringByAppendingFormat:@"/notes.plist"];
	return prefPath;
} // notesFile

+(NSMutableDictionary*)notes
{
	NSMutableDictionary*	theNotes = [NSMutableDictionary dictionaryWithContentsOfFile:[FavoritesController notesFile]];
	if(theNotes == nil)
		theNotes = [NSMutableDictionary dictionary];
	
	return theNotes;
} // notes

+(void) saveNote:(NSString*)note forID:(NSString*)nct_id
{
	NSMutableDictionary*	theNotes = [FavoritesController notes];
	theNotes[nct_id] = note;
	[theNotes writeToFile:[FavoritesController notesFile] atomically:YES];
} // saveNote:forID:

+(NSString*)getNoteForID:(NSString*)nct_id
{
	NSMutableDictionary*	theNotes = [FavoritesController notes];
	NSString* note = theNotes[nct_id];
	if(note == nil)
		note = @"";
	
	return note;
} // getNoteForID

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.bookmarks = [FavoritesController bookmarks];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[tableView reloadData];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

-(void) viewDidAppear:(BOOL)animated
{
#ifndef __DEBUG_OUTPUT__
		[Flurry logEvent:@"Advanced Search Open"];
#endif
	
	[super viewDidAppear:animated];
	[tableView reloadData];
} // viewDidAppear

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



#pragma mark table methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
	if(!editing)
		[FavoritesController saveBookmarks];
	
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)theTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)theTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id	item = bookmarks[sourceIndexPath.row];
    [bookmarks removeObjectAtIndex:sourceIndexPath.row];
    [bookmarks insertObject:item atIndex:destinationIndexPath.row];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary*	study = bookmarks[indexPath.row];
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSString*		vmPath = [FavoritesController getNoteForID:[study[@"basicInfo"] objectAtPath:@"nct_id"]];
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
		
		[bookmarks removeObjectAtIndex:indexPath.row];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [bookmarks count];
}


// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"BookmarkCell"; // TODO: remove BookmarkCell classes
    BookmarkCell *cell = (BookmarkCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        //UINib *nib = [UINib nibWithNibName:@"BookmarkCell" bundle:nil];
        UINib *nib = [UINib nibWithNibName:@"ResultCellView" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        [cell.button_Note   addTarget:self action:@selector(notesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button_VM     addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    /*
    NSString *CellIdentifier = @"BookmarkCell";
	BookmarkCell *cell;
	cell = (BookmarkCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[BookmarkCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		UIButton*	xButton = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage*	ftImage = [UIImage imageNamed:@"button_stickies.png"];
		[xButton setImage:ftImage forState:UIControlStateNormal];
		[xButton setImage:ftImage forState:UIControlStateSelected];
		[xButton addTarget:self action:@selector(notesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		CGRect noteFrame = CGRectMake(4, 20, 30, 30);
		xButton.frame = noteFrame;
		[cell.contentView addSubview:xButton];
		xButton.frame = noteFrame;
		cell.button_Note = xButton;
		
		xButton = [UIButton buttonWithType:UIButtonTypeCustom];
		ftImage = [UIImage imageNamed:@"microphone.png"];
		[xButton setImage:ftImage forState:UIControlStateNormal];
		[xButton setImage:ftImage forState:UIControlStateSelected];
		[xButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		noteFrame = CGRectMake(4, 60, 30, 30);
		xButton.frame = noteFrame;
		[cell.contentView addSubview:xButton];
		xButton.frame = noteFrame;
		cell.button_VM = xButton;
	}
    */
	NSDictionary *info = bookmarks[indexPath.row][@"basicInfo"];
	cell.info = info;
    
    // Instead of having a subclass just to override setInfo, do the extra stuff here
    cell.button_Note.hidden  = NO;
    cell.button_VM.hidden    = NO;
    cell.label_HeaderNumber.text = @"";
    
    NSString* nct_id = info[@"nct_id"];
    NSFileManager*	fm = [NSFileManager defaultManager];
    
    NSArray*	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	documentsDirectory = paths[0];
    NSString*	vmFile = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory, nct_id];
    
    cell.button_Note.alpha = ([FavoritesController notes][nct_id]) ? 1.0 : 0.25;
    cell.button_VM.alpha = ([fm fileExistsAtPath:vmFile]) ? 1.0 : 0.05;
    // End extra stuff
    
	return cell;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	TrialViewController* controller = [[TrialViewController alloc] initWithNibName:@"TrialViewController" bundle:nil];
	controller.basicInfo = bookmarks[indexPath.row][@"basicInfo"];
	
	[self.navigationController pushViewController:controller animated:YES];
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
	
} // didSelectRowAtIndexPath


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 96;
} // heightForRowAtIndexPath


-(void)notesButtonClicked:(id)sender
{
	UIView *senderButton = (UIView*) sender;
	NSIndexPath *indexPath = [tableView indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
	//you have the indexPath of the cell who holds the pushed button
	
	editingNoteIndex  = indexPath.row;
	NSDictionary*	study = bookmarks[indexPath.row];
	
	NotesView*		nv = [[NotesView alloc] initWithNibName:@"NotesView" bundle:nil];
	nv.noteTitleLabel = [study[@"basicInfo"] objectAtPath:@"title"];
	nv.note = [FavoritesController getNoteForID:[study[@"basicInfo"] objectAtPath:@"nct_id"]];
	nv.noteID = [study[@"basicInfo"] objectAtPath:@"nct_id"];
	nv.delegate = self;
	[self.navigationController pushViewController:nv animated:YES];
	[nv toggleEditing:self];
	
} // notesButtonClicked

-(void)voiceButtonClicked:(id)sender
{
	UIView *senderButton = (UIView*) sender;
	NSIndexPath *indexPath = [tableView indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
	//you have the indexPath of the cell who holds the pushed button
	
	editingNoteIndex  = indexPath.row;
	NSDictionary*	study = bookmarks[indexPath.row];
	
	VoiceRecorder*		vr = [[VoiceRecorder alloc] initWithNibName:@"VoiceRecorder" bundle:nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	vr.pathToFile = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory ,[study[@"basicInfo"] objectAtPath:@"nct_id"]];
#if __DEBUG_OUTPUT__
	NSLog(vr.pathToFile);
#endif
	[self.navigationController pushViewController:vr animated:YES];
	
} // voiceButtonClicked

-(void) updateBookmarkInfo:(NSString*)notes
{
	NSDictionary*	info = bookmarks[editingNoteIndex];
	[FavoritesController saveNote:notes forID:[info objectAtPath:@"basicInfo/nct_id"]];
} // updateInfo

@end
