//
//  ContactViaEmail.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/16/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ContactViaEmail : UIViewController <MFMailComposeViewControllerDelegate>{
	NSDictionary*			profileInfo;
	NSDictionary*			detailedInfo;
}
@property (nonatomic, strong) NSDictionary*	profileInfo;
@property (nonatomic, strong) NSDictionary*	detailedInfo;

+(NSString*)emailRecordFile;

- (void) popLater:(NSTimer*)timer;

@end
