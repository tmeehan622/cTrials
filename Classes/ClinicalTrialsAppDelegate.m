//
//  ClinicalTrialsAppDelegate.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 9/10/09.
//  Copyright The Frodis Co 2009. All rights reserved.
//

#import "ClinicalTrialsAppDelegate.h"
#import "SearchController.h"
#import "AdvancedSearchController.h"
#import "TermsOfUse.h"
#import "ProfileManager.h"
#import "FavoritesController.h"
#import "Settings.h"
#import "Registration.h"
#import "AboutBox.h"

@implementation ClinicalTrialsAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize scaleFactor;
@synthesize scaleFactorNative;
@synthesize screenWidthForUI;
@synthesize screenHeightForUI;

- (IBAction)dismissOptions
{
    [myTabBarController.selectedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) viewToggle:(id)sender
{
	AboutBox*	ABView = nil;

	ABView = [[AboutBox alloc] initWithNibName:@"AboutBox" bundle:nil];
	ABView.controller = self;
	
	ABView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	UIViewController *cvc = myTabBarController.selectedViewController;
	
    
    [ABView setEdgesForExtendedLayout:UIRectEdgeNone];
    [cvc setEdgesForExtendedLayout:UIRectEdgeNone];
    [myTabBarController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [cvc presentViewController:ABView animated:YES completion:nil];
}

- (void) touchedAbout:(NSNotification*)notification
{
	[self viewToggle:self];
//	AboutBox*	nextView = nil;
//	nextView = [[AboutBox alloc] initWithNibName:@"AboutBox" bundle:nil];
//	nextView.modal=YES;
//	nextView.controller = myTabBarController.selectedViewController;
//	//	[myTabBarController.selectedViewController presentModalViewController:nextView animated:YES];
//	[myTabBarController.selectedViewController pushViewController:nextView animated:YES];
//	[nextView release];
	
} // touchedAbout

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 @{@"itemsPerPage": @1}];

	NSMutableArray*		controllers = [NSMutableArray array];
    UINavigationController *navController = [[UINavigationController alloc] init];
	UIViewController *aViewController = [[SearchController alloc] initWithNibName:@"SearchController" bundle:[NSBundle mainBundle]];
    aViewController.title = @"Search";
    //aViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    aViewController.tabBarItem.image = [UIImage imageNamed:@"TabbarIcon_Search"];

	[navController pushViewController:aViewController animated:NO];
	[controllers addObject:navController];
		
	navController = [[UINavigationController alloc] init];
	//	navController.navigationBar.tintColor = ORKOV_TINT_COLOR;
    aViewController = [[FavoritesController alloc] initWithNibName:@"FavoritesController" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Favorites";
	aViewController.tabBarItem.image = [UIImage imageNamed:@"TabbarIcon_Star"];
    [navController pushViewController:aViewController animated:NO];
	[controllers addObject:navController];
	
	navController = [[UINavigationController alloc] init];
	//	navController.navigationBar.tintColor = ORKOV_TINT_COLOR;
    aViewController = [[ProfileManager alloc] initWithNibName:@"ProfileManager" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Profile";
	aViewController.tabBarItem.image = [UIImage imageNamed:@"TabbarIcon_Profile"];
    [navController pushViewController:aViewController animated:NO];
	[controllers addObject:navController];
	
	navController = [[UINavigationController alloc] init];
	//	navController.navigationBar.tintColor = ORKOV_TINT_COLOR;
    aViewController = [[Settings alloc] initWithNibName:@"Settings" bundle:[NSBundle mainBundle]];
	aViewController.title = @"Settings";
	aViewController.tabBarItem.image = [UIImage imageNamed:@"TabbarIcon_Settings"];
    [navController pushViewController:aViewController animated:NO];
	[controllers addObject:navController];
	
	[myTabBarController setViewControllers:controllers animated:NO];
	myTabBarController.delegate = self;
    
    // This is a bit hacky, but it's better than going into each controller's implementation and setting edges.
    for(UIViewController *c in controllers)
    {
        [c setEdgesForExtendedLayout:UIRectEdgeNone];
        for(UIViewController *child in c.childViewControllers)
        {
            [child setEdgesForExtendedLayout:UIRectEdgeNone];
        }
    }
    /*
    for(UIViewController *c in myTabBarController.viewControllers)
    {
        [c setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    for(UIViewController *c in navController.viewControllers)
    {
        [c setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    myTabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    navController.edgesForExtendedLayout = UIRectEdgeNone;
    */
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchedAbout:) name:@"ABOUT_TOUCH" object:nil];

//	[window addSubview:[myTabBarController view]];
//    [window makeKeyAndVisible];
    
    // Style the navigation bar
    UIColor *navBarColor = [UIColor colorWithRed:0.58 green:0.00 blue:0.00 alpha:1.0];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    // Style the tab bar
    [[UITabBar appearance] setTintColor:navBarColor];
    //    [[UITabBar appearance] setBarTintColor:navBarColor];
    
    // Style the toolbar
    [[UIToolbar appearance] setTintColor:navBarColor];
    
    // Style mail controller toolbar
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTintColor:[UIColor whiteColor]];
    
    // Style the status bar
    // possible private API?
    
    /*
     //commented out 5/3/2022
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor colorWithRed:0.58 green:0.00 blue:0.00 alpha:1.0];
    }
     
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

     */
//    [UIApplication sharedApplication]
    
    window.frame = [[UIScreen mainScreen] bounds];
    window.rootViewController = myTabBarController;
    [window makeKeyAndVisible];
    
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"agreedToTerms"])
	{
		TermsOfUse*	nextView = [[TermsOfUse alloc] initWithNibName:@"TermsOfUse" bundle:nil];
        [nextView setEdgesForExtendedLayout:UIRectEdgeNone];
		[myTabBarController presentModalViewController:nextView animated:NO];
	}
	
//	[NSThread detachNewThreadSelector:@selector(checkRegistration) toTarget:self withObject:nil];

#ifndef __DEBUG_OUTPUT__
	[Flurry startSession:@"JX1Z5M5RIFCQ2X8LKMF4"];
#endif
} // applicationDidFinishLaunching

-(void) checkRegistration
{
	[Registration checkRegistration];
}



//- (void)dealloc {
//    [viewController release];
//    [window release];
//    [super dealloc];
//}


@end
