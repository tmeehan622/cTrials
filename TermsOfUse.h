//
//  TermsOfUse.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/1/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TermsOfUse : UIViewController {
	IBOutlet	UIWebView*	mainWebView;
	IBOutlet	UIButton*	acceptButton;
	IBOutlet	UIButton*	declineButton;
	IBOutlet	UIButton*	okButton;
}

- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;

@end
