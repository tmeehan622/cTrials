//
//  RoundedCornerView.m
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/14/16.
//
//

#import "RoundedCornerView.h"

@implementation RoundedCornerView

-(void)setRadius:(CGFloat)radius forCorners:(UIRectCorner)corners
{
    _radius = radius;
    _corners = corners;
    
    if(radius == 0)
    {
        self.layer.mask = nil;
        return;
    }
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.bounds
                              byRoundingCorners:corners//(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(radius, radius)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // Need a new mask
    [self setRadius:_radius forCorners:_corners];
}

@end
