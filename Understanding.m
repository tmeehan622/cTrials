//
//  Understanding.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/1/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "Understanding.h"
#import "ClinicalTrialsAppDelegate.h"


@implementation Understanding
@synthesize contentView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;
@synthesize adBannerView = _adBannerView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //[self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self createAdBannerView];
//	ContFrameLand = CGRectMake(0,0,480,193);
//	ContFramePort = CGRectMake(0,0,320,346);
//	BannerOriginLand = CGPointMake(0.0, 186.0);
//	BannerOriginPort = CGPointMake(0.0, 317.0);
//	BannerHeightLand = 32.0;
//	BannerHeightPort = 50.0;
	VShiftLandscape = 32.0;
	VShiftPortrait = 50.0;
	
	self.navigationItem.title = @"Understanding CT";
	[mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"understanding" ofType:@"html"]]]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
}



-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Understanding CT Open"];
#endif
}

-(BOOL)isLandscape
{
	return ([UIDevice currentDevice].orientation != UIInterfaceOrientationPortrait);
}




#pragma mark Orientation support

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixupAdView:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createAdBannerView {
    // TODO: Implement new ad solution
    /*
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.adBannerView = [[classAdBannerView alloc] initWithFrame:CGRectZero];
        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil]];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];            
        }
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0, -[self getBannerHeight])];
        [_adBannerView setDelegate:self];
        
        [self.view addSubview:_adBannerView];        
    }
    */
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    // TODO: Implement new ad solution
    /*
    if (_adBannerView != nil) {        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }          
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible) {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 0;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = contentView.frame;
            contentViewFrame.origin.y = [self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height - [self getBannerHeight:toInterfaceOrientation];
            contentView.frame = contentViewFrame;
        } else {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = -[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            contentView.frame = contentViewFrame;            
        }
        [UIView commitAnimations];
    }
    */
}

#pragma mark ADBannerViewDelegate

//- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
//    if (!_adBannerViewIsVisible) {                
//        _adBannerViewIsVisible = YES;
//        [self fixupAdView:[UIDevice currentDevice].orientation];
//    }
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    if (_adBannerViewIsVisible)
//    {        
//        _adBannerViewIsVisible = NO;
//        [self fixupAdView:[UIDevice currentDevice].orientation];
//    }
//}

@end
