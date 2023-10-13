//
//  ResultCellView.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoundedCornerView;

@interface ResultCellView : UITableViewCell
{
    /*
	UILabel*			label_BodyTitle;
	UILabel*			label_BodySummary;
	UILabel*			label_BodyLastChanged;
	UILabel*			label_HeaderStatus;
    
	UIImageView*		iv_UnreadDot;
	UIView*				view_BGTop;
	UILabel*			label_HeaderNumber;

	NSDictionary*		info;
    */
}
@property (nonatomic, strong) IBOutlet NSDictionary*	info;
@property (nonatomic, strong) IBOutlet UILabel*			label_HeaderStatus;
@property (nonatomic, strong) IBOutlet UILabel*			label_HeaderNumber;
@property (nonatomic, strong) IBOutlet UILabel*			label_BodyTitle;
@property (nonatomic, strong) IBOutlet UILabel*			label_BodySummary;
@property (nonatomic, strong) IBOutlet UILabel*			label_BodyLastChanged;
@property (nonatomic, strong) IBOutlet UIImageView*     iv_UnreadDot;
@property (nonatomic, strong) IBOutlet UIButton*        button_Note;
@property (nonatomic, strong) IBOutlet UIButton*        button_VM;
@property (nonatomic, strong) IBOutlet RoundedCornerView* view_BGTop;
@property (nonatomic, strong) IBOutlet RoundedCornerView* view_BGBottom;

@end
