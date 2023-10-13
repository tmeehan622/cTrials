//
//  OptionsHandler.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/18/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrialViewController;

@interface OptionsHandler : UIViewController {
	IBOutlet	UITableView*				myTable;
	IBOutlet	TrialViewController*		myController;
	NSArray*								menuOptions;
	
}

@end
