//
//  DateLabel.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/27/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DateRangeHandler.h"

@interface DateLabel : UILabel {
	IBOutlet	DateRangeHandler*	delegate;
}

@end
