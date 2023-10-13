//
//  VoiceRecorder.h
//  VoiceMessage
//
//  Created by Matthew Mashyna on 12/4/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQPlayer.h"
#import "AQRecorder.h"


@interface VoiceRecorder : UIViewController {

	IBOutlet	UIButton*		recordButton;
	IBOutlet	UIButton*		playButton;
	IBOutlet	UILabel*		playLabel;
	IBOutlet	UILabel*		recordLabel;
	IBOutlet	UIImageView*	recordingImage;
	
	BOOL						playbackWasInterrupted;
	BOOL						playbackWasPaused;
	
	CFStringRef					recordFilePath;	
	NSString*	pathToFile;

	AQPlayer*					player;
	AQRecorder*					recorder;
}
@property (nonatomic, strong) NSString*	pathToFile;

-(IBAction) doPlayButton:(id)sender;
-(IBAction) doRecordButton:(id)sender;

-(IBAction) erase:(id)sender;

- (void)stopRecord;
-(void)stopPlayQueue;

@end
