//
//  TrialViewCell.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/5/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#define	TEXT_PAD	4
#define	TEXT_OFFSET 12
#define TEXT_WIDTH (275-TEXT_OFFSET)
#define TEXT_HEIGHT 20


@interface TrialViewCell : UITableViewCell {
	UILabel*			contentTitle;
	UILabel*			contentText;
	
	NSDictionary*		info;
	
}
@property (nonatomic, strong) 	NSDictionary*		info;

+(double) neededCellHeightFor:(NSString*)text forWidth:(double)withWidth;
@end
