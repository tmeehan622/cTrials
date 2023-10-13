//
//  NotesView.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/31/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCProtocols.h"

@interface NotesView : UIViewController {
	IBOutlet	UILabel*	noteTitle;
	IBOutlet	UITextView*	notes;
	IBOutlet	id			delegate;
	NSString*				note;
	NSString*				noteTitleLabel;
	NSString*				noteID;
	
	UIBarButtonItem*		editButton;
	BOOL					editing;
	BOOL					changed;
    
    IBOutlet NSLayoutConstraint *constraint_Keyboard;
}
@property (nonatomic, strong)	id<BookmarkUpdating> delegate;
@property (nonatomic, strong)	NSString*		note;
@property (nonatomic, strong)	NSString*		noteTitleLabel;
@property (nonatomic, strong)	NSString*		noteID;

-(IBAction)toggleEditing:(id)sender;
-(IBAction) addVoiceMemo:(id)sender;

@end
