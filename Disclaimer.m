#import "Disclaimer.h"


@implementation Disclaimer

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = YES;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Disclaimer";
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Disclaimer Open"];
#endif
}


@end
