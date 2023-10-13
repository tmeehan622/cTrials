//
//  GlobeView.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 12/2/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchTrigger;

@interface GlobeView : UIViewController {

	IBOutlet		TouchTrigger*		northAmerica;
	IBOutlet		TouchTrigger*		world;
	
}
-(void) mapTouch:(NSNotification*)notification;

@end
