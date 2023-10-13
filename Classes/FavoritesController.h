//
//  FavoritesController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCProtocols.h"

@interface FavoritesController : UIViewController <BookmarkUpdating>
{
	IBOutlet			UITableView*		tableView;
	
	NSMutableArray*							bookmarks;
	int										editingNoteIndex;
	
}
@property (nonatomic, strong) NSMutableArray*	bookmarks;

+(NSString*) bookmarksFile;
+(NSMutableDictionary*) gBookmarks;
+(void) addBookmark:(NSDictionary*)newBM;
+(void) saveBookmarks;
+(NSMutableArray*) bookmarks;
+(BOOL) alreadyBookMarked:(NSString*)nct_id;

+(NSString*)notesFile;
+(NSMutableDictionary*)notes;
+(void) saveNote:(NSString*)note forID:(NSString*)nct_id;
+(NSString*)getNoteForID:(NSString*)nct_id;

-(void) updateBookmarkInfo:(NSString*)notes;
-(void)voiceButtonClicked:(id)sender;
-(void)notesButtonClicked:(id)sender;

@end
