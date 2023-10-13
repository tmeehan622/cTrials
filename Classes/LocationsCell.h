//
//  LocationsCell.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/20/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationsCell : UITableViewCell {
	UILabel*			name;
	UILabel*			address;
	UILabel*			contact;
	UILabel*			contact_backup;
	UILabel*			investigator;

	NSDictionary*		info;
	
}
@property (nonatomic, strong) 	NSDictionary*		info;

@end
