//
//  ResultsOptionsHandler.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/18/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResultsViewController;

@interface ResultsOptionsHandler : UIViewController {
	IBOutlet	UITableView*				myTable;
	IBOutlet	ResultsViewController*		myController;
	NSArray*								menuOptions;
	ResultsViewController		*delegate;
	
}
@property (strong, nonatomic) IBOutlet	ResultsViewController*		myController;
@property (strong, nonatomic) 	ResultsViewController		*delegate;
-(IBAction)done;
@end
