#import <UIKit/UIKit.h>
#import "ClinicalTrialsAppDelegate.h"


@interface AboutBox : UIViewController {
	BOOL                    modal;
//	id<genericDelegate>     __unsafe_unretained controller;
    id      __unsafe_unretained controller;
	IBOutlet UITextView     *__unsafe_unretained tv;
	
}
@property (nonatomic, assign) BOOL                              modal;
//@property (nonatomic, unsafe_unretained) id<genericDelegate>       controller;
@property (nonatomic, unsafe_unretained) id      controller;
@property ( unsafe_unretained, nonatomic) IBOutlet UITextView       *tv;
-(IBAction)done:(id)sender;
@end
