//
//  RoundedCornerView.h
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/14/16.
//
//

#import <UIKit/UIKit.h>

@interface RoundedCornerView : UIView
{
    CGFloat      _radius;
    UIRectCorner _corners;
}

-(void)setRadius:(CGFloat)radius forCorners:(UIRectCorner)corners;

@end
