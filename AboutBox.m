#import "AboutBox.h"
#import "ClinicalTrialsAppDelegate.h"


@implementation AboutBox
@synthesize modal,controller,tv;

-(IBAction)done:(id)sender
{
	
	[controller dismissOptions];	
	
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (YES);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = YES;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	tv.font = [UIFont fontWithName:@"Helvetica" size:12];
//	UIFont *jj = tv.font;
//	NSString *fn = jj.fontName;
//	CGFloat fs = jj.pointSize;
	
	self.navigationItem.title = @"About cTrials";
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"About Open"];
#endif
	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(done:)userInfo:nil repeats:NO];

}


@end

