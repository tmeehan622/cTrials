//
//  ProfileManager.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileController;

@interface ProfileManager : UIViewController {
	IBOutlet	UITableView*	tableView;
	
	UIBarButtonItem*			plusButton;
	NSMutableDictionary*		profileDict;
	NSMutableArray*				profiles;
	ProfileController*			tmpProfile;
	BOOL						addingNewProfile;
}
@property (nonatomic, readonly) NSMutableArray* profiles;

+(NSString*)profileFile;
+(NSArray*) profiles;

-(void) readProfiles;
-(void) saveProfiles;
-(IBAction) addNewProfile:(id)sender;
@end
