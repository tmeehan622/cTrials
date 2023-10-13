//
//  VoiceRecorder.m
//  VoiceMessage
//
//  Created by Matthew Mashyna on 12/4/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "VoiceRecorder.h"

void interruptionListener(void* inClientData, UInt32 inInterruptionState);
void propListener(void* inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void* inData);


@implementation VoiceRecorder
@synthesize pathToFile;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = paths[0];

		BOOL exists = [fileManager fileExistsAtPath:documentsDirectory];
		if (!exists) {
			BOOL success = [fileManager createDirectoryAtPath:documentsDirectory attributes:nil];
			if (!success) {
				NSAssert(0, @"Failed to create Documents directory.");
			}
		}
		
		self.pathToFile=[documentsDirectory stringByAppendingFormat:@"/memox.caf"];
		
		// Allocate our singleton instance for the recorder & player object
		recorder = new AQRecorder();
		player = new AQPlayer();
		
		OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, (__bridge void*)self);
		if (error) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", error);
//		else 
		{
			UInt32 category = kAudioSessionCategory_PlayAndRecord;	
			error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
			if (error) printf("couldn't set audio category!");
			
			error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, (__bridge void*)self);
			if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", error);
			UInt32 inputAvailable = 0;
			UInt32 size = sizeof(inputAvailable);
			
			// we do not want to allow recording if input is not available
			error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
			if (error) printf("ERROR GETTING INPUT AVAILABILITY! %d\n", error);
			recordButton.enabled = (inputAvailable) ? YES : NO;
			
			// we also need to listen to see if input availability changes
			error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, (__bridge void*)self);
			if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", error);
			
			error = AudioSessionSetActive(true); 
			if (error) printf("AudioSessionSetActive (true) failed");
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];
		
		// disable the play button since we have no recording to play yet
		playButton.enabled = NO;
		playbackWasInterrupted = NO;
		playbackWasPaused = NO;
		
	}
    return self;
}

-(IBAction) doPlayButton:(id)sender
{
	if (player->IsRunning())
	{
		if (playbackWasPaused) {
			OSStatus result = player->StartQueue(true);
			if (result == noErr)
				[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
		}
		else
			[self stopPlayQueue];
	}
	else
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:self.pathToFile])
			player->CreateQueueForFile((__bridge CFStringRef)self.pathToFile);
			
		OSStatus result = player->StartQueue(false);
		if (result == noErr)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
	}
} // doPlayButton

-(IBAction) doRecordButton:(id)sender
{
	if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
	{
		[self stopRecord];
		[recordingImage stopAnimating];
		recordingImage.hidden = YES;
		[recordButton setImage:[UIImage imageNamed:@"Recording_Record"] forState:UIControlStateNormal] ;
	}
	else // If we're not recording, start.
	{
		playButton.enabled = NO;	
		[recordingImage startAnimating];
		recordingImage.hidden = NO;
		
		// Set the button's state to "stop"
		recordLabel.text = @"STOP";
		[recordButton setImage:[UIImage imageNamed:@"Recording_Stop"] forState:UIControlStateNormal] ;
		 
		
		// Start the recorder
		recorder->StartRecord(CFSTR("memox.caf"));
		
	}	
} // doRecordButton


-(IBAction) erase:(id)sender
{
} // erase

char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4], *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}


#pragma mark Playback routines

-(void)stopPlayQueue
{
	player->StopQueue();
	recordButton.enabled = YES;
}

-(void)pausePlayQueue
{
	player->PauseQueue();
	playbackWasPaused = YES;
}

- (void)stopRecord
{
	recorder->StopRecord();
	
	// dispose the previous playback queue
	player->DisposeQueue(true);
	
	// now create a new queue for the recorded file
	recordFilePath = (__bridge CFStringRef)[NSTemporaryDirectory() stringByAppendingPathComponent: @"memox.caf"];
	NSFileManager*	fm = [NSFileManager defaultManager];
	NSError*	error = nil;
#if __DEBUG_OUTPUT__
	NSLog(pathToFile);
#endif
	
	if([fm fileExistsAtPath:self.pathToFile])
		[fm removeItemAtPath:self.pathToFile error:&error];
	
	BOOL copiedOK = [fm copyItemAtPath:(__bridge NSString*) recordFilePath toPath:self.pathToFile error:&error];
	if(error)
		NSLog([error description]);
#if 0
	player->CreateQueueForFile(recordFilePath);
#else
	player->CreateQueueForFile((__bridge CFStringRef)self.pathToFile);
#endif

	playButton.enabled = ([[NSFileManager defaultManager] fileExistsAtPath:self.pathToFile]);

	// Set the button's state back to "record"
	recordLabel.text = @"REC";
	[recordButton setImage:[UIImage imageNamed:@"Recording_Record"] forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled];

	playButton.enabled = YES;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.title = @"Voice Memo";
	playButton.enabled = ([[NSFileManager defaultManager] fileExistsAtPath:self.pathToFile]);
	
	recordingImage.animationImages = @[[UIImage imageNamed:@"Recording_LabelWhite"],
									  [UIImage imageNamed:@"Recording_LabelRed"]];
	
	recordingImage.animationDuration = 2.0;
	
	
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Voice Memo Open"];
#endif
}


#pragma mark AudioSession listeners
void interruptionListener(void* inClientData, UInt32 inInterruptionState)
{
	VoiceRecorder *THIS = (__bridge VoiceRecorder*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
		else if (THIS->player->IsRunning()) {
			//the queue will stop itself on an interruption, we just need to update the UI
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
			THIS->playbackWasInterrupted = YES;
		}
	}
	else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
	{
		// we were playing back when we were interrupted, so reset and resume now
		THIS->player->StartQueue(true);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
		THIS->playbackWasInterrupted = NO;
	}
}

void propListener(	void *                  inClientData,
				  AudioSessionPropertyID	inID,
				  UInt32                  inDataSize,
				  const void *            inData)
{
	VoiceRecorder *THIS = (__bridge VoiceRecorder*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
			{			
				if (THIS->player->IsRunning()) {
					[THIS pausePlayQueue];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
				}		
			}
			
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
				[THIS stopRecord];
			}
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
			THIS->recordButton.enabled = (isAvailable > 0) ? YES : NO;
		}
	}
}

# pragma mark Notification routines
- (void)playbackQueueStopped:(NSNotification *)note
{
	playLabel.text = @"PLAY";
	[playButton setImage:[UIImage imageNamed:@"Recording_Play"] forState:UIControlStateNormal] ;
	recordButton.enabled = YES;
}

- (void)playbackQueueResumed:(NSNotification *)note
{
	[playButton setImage:[UIImage imageNamed:@"Recording_Pause"] forState:UIControlStateNormal] ;
	playLabel.text = @"STOP";
	recordButton.enabled = NO;
}

#pragma mark Cleanup
- (void)dealloc
{
	
	delete player;
	delete recorder;
	
}


@end
