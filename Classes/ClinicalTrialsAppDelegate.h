//
//  ClinicalTrialsAppDelegate.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 9/10/09.
//  Copyright The Frodis Co 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClinicalTrialsViewController;

@interface ClinicalTrialsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	IBOutlet	UITabBarController *myTabBarController;
    ClinicalTrialsViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ClinicalTrialsViewController *viewController;

@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGFloat scaleFactorNative;
@property (nonatomic, assign) CGFloat screenWidthForUI;
@property (nonatomic, assign) CGFloat screenHeightForUI;


- (void) touchedAbout:(NSNotification*)notification;
- (IBAction)dismissOptions;
@end

