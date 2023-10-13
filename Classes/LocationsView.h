//
//  ContactsView.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/19/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationsView : UIViewController {
	IBOutlet	UITableView*	myTable;
	
	NSArray*					contacts;
}
@property (nonatomic, strong) NSArray*	 contacts;

@end
