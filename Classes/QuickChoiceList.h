//
//  QuickChoiceList.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 9/21/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickChoiceList : UITableViewController {
	id			referenceObject;
	int			currentSelection;
	NSArray*	referenceList;
	NSString*	referenceKey;
	NSString*	navTitle;
	BOOL		popsOnChoice;
	
}
@property (nonatomic, strong) id		referenceObject;
@property (nonatomic, strong) NSArray*	referenceList;
@property (nonatomic, strong) NSString*	referenceKey;
@property (nonatomic, strong) NSString*	navTitle;
@property int currentSelection;
@property BOOL popsOnChoice;

@end
