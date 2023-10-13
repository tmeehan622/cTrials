//
//  History.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/25/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasicSearchController;

@interface History : UIViewController {
	IBOutlet UITableView*		myTable;
	NSArray*					history;
	BasicSearchController*		delegate;
	int							recordIndex;
}

@property (nonatomic, strong) NSArray*					history;
@property (nonatomic, strong) BasicSearchController*	delegate;


- (IBAction)clearHistory:(id) sender;

@end
