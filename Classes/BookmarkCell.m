//
//  BookmarkCell.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "BookmarkCell.h"
#import "FavoritesController.h"


@implementation BookmarkCell
@synthesize button_VM, button_Note;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    button_Note.hidden  = NO;
    button_VM.hidden    = NO;
    self.label_HeaderNumber.text = @"";
}

- (void) setInfo:(NSDictionary*) d
{
	[super setInfo:d];
	NSMutableDictionary* theNotes = [FavoritesController notes];
    
	NSString* nct_id = self.info[@"nct_id"];

	button_Note.alpha = (theNotes[nct_id]) ? 1.0 : 0.5;
	
	NSFileManager*	fm = [NSFileManager defaultManager];
	
	NSArray*	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString*	documentsDirectory = paths[0];
	NSString*	vmFile = [NSString stringWithFormat:@"%@/%@.caf", documentsDirectory, nct_id];

	button_VM.alpha = ([fm fileExistsAtPath:vmFile]) ? 1.0 : 0.25;

} // setInfo



@end
