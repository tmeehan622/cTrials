//
//  WorldCountries.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#if 0
enum {kWorld = 0, kNorthAmerica, kAustralia};
#else
enum {kWorld = 0, kAmerica, kCanada, kAustralia};
#endif

@interface WorldCountries : UIViewController {
	IBOutlet		UITableView*	myTable;
	
	NSArray*						masterList;
	NSArray*						indexArray;
	int								region;
}
@property (nonatomic, assign) int region;

@end
