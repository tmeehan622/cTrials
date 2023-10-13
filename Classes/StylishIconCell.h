//
//  StylishIconCell.h
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/13/16.
//
//

#import <UIKit/UIKit.h>

@class RoundedCornerView;

@interface StylishIconCell : UITableViewCell
{
    IBOutlet UILabel *label_Title;
    IBOutlet UIImageView *iv_Icon;
    IBOutlet RoundedCornerView *v_BGLeft;
    IBOutlet RoundedCornerView *v_BGRight;
}

-(void)setIconImage:(UIImage *)img;
-(void)setTitle:(NSString *)text;

@end
