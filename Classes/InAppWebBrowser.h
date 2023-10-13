//
//  InAppWebBrowser.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InAppWebBrowser : UIViewController {
	IBOutlet		UIWebView*			mainWebView;
	IBOutlet		UINavigationBar*	navBar;
	IBOutlet		UIToolbar*			toolBar;
	IBOutlet		UIBarButtonItem*	backButton;
	IBOutlet		UIBarButtonItem*	forwardButton;
	IBOutlet		UIBarButtonItem*	refreshButton;
	IBOutlet		UIView*				busy;
	
	NSString*		destination;
	
}
@property (nonatomic, strong) NSString*       destination;
@property (nonatomic, strong) NSTimer*        vTimer;

- (IBAction) done:(id)sender;
- (IBAction) back:(id)sender;
- (IBAction) next:(id)sender;
- (IBAction) refresh:(id)sender;

-(void) showControls;

@end
