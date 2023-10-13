//
//  WhateverListController.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 3/11/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvancedSearchController.h"

@interface WhateverListController : UITableViewController {
	NSArray*			masterList;
	NSString*			key;
	NSString*			headerString;
	NSMutableArray*		selectedIndexes;
	id<HeadingSelectionChanger>	sender;
}

- (instancetype)initWithTitle:(NSString *)aTitle list:(NSArray*)dList key:(NSString*)dKey initialSelections:(NSArray*)initialSelection sender:(id)dSender NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray* masterList;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* headerString;
@property (nonatomic, strong) id<HeadingSelectionChanger> sender;
@end
