//
//  AdvancedCell.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/6/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrialViewCell.h"

#define TEXT_EDIT_WIDTH (300-TEXT_OFFSET)

@interface AdvancedCell : TrialViewCell {
	UITextField*		contentEdit;
	NSIndexPath*		tableIndex;
}
@property (nonatomic, readonly) UITextField*		contentEdit;
@property (nonatomic, strong) NSIndexPath*			tableIndex;

@end
