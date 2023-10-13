//
//  SegmentedPref.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 8/24/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SegmentedPref : UIViewController {
	IBOutlet	UISegmentedControl*		__unsafe_unretained segmentedControl;
	IBOutlet	UILabel*				__unsafe_unretained prompt;
	
	NSArray*	segments;
	NSString*	prefName;
	NSString*	prefTitle;
}
@property ( unsafe_unretained, nonatomic) UISegmentedControl*		segmentedControl;
@property ( unsafe_unretained, nonatomic) UILabel*					prompt;

@property (nonatomic, strong) NSArray*	segments;
@property (nonatomic, strong) NSString*	prefName;
@property (nonatomic, strong) NSString*	prefTitle;
@end
