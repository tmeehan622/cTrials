//
//  StylishIconCell.m
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/13/16.
//
//

#import "StylishIconCell.h"
#import "RoundedCornerView.h"

@implementation StylishIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    v_BGLeft.backgroundColor = [UIColor colorWithRed:0.67 green:0.00 blue:0.00 alpha:1.0];
    [v_BGLeft   setRadius:12 forCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [v_BGRight  setRadius:12 forCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIconImage:(UIImage *)img
{
    iv_Icon.image = img;
}
-(void)setTitle:(NSString *)text
{
    label_Title.text = text;
}

@end
