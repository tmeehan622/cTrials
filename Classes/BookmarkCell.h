//
//  BookmarkCell.h
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultCellView.h"

@interface BookmarkCell : ResultCellView {
	UIButton*		button_Note;
	UIButton*		button_VM;
}
/*
@property(nonatomic, strong)IBOutlet UIButton *button_Note;
@property(nonatomic, strong)IBOutlet UIButton *button_VM;
@property(nonatomic, strong)IBOutlet UIImageView *iv_UnreadDot;
@property(nonatomic, strong)IBOutlet UILabel *label_HeaderTitle;
@property(nonatomic, strong)IBOutlet UILabel *label_HeaderSubtitle;
@property(nonatomic, strong)IBOutlet UILabel *label_BodyTitle;
@property(nonatomic, strong)IBOutlet UILabel *label_BodyDescription;
@property(nonatomic, strong)IBOutlet UILabel *label_BodyType;
*/
@end
