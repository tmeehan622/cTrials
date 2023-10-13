//
//  NSStylishView.m
//  InstagramCommentsPro
//
//  Created by Joseph Falcone on 6/16/15.
//  Copyright (c) 2015 American Mobile Solutions. All rights reserved.
//

#import "NSStylishView.h"

#import "NetstickUI.h"

@implementation NSStylishView

//@synthesize cornerTL, cornerTR, cornerBL, cornerBR, borderColor, borderWidth;

#pragma mark- Lifecycle

-(id)init
{
    if(self = [super init]){}
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        [self initStylishStuff];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
        [self initStylishStuff];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initStylishStuff];
}

-(void)initStylishStuff // TODO: should I call this setup instead?
{
    // Initialize private variables
    cornerTL = 0;
    cornerTR = 0;
    cornerBR = 0;
    cornerBL = 0;
    
    // Gradient stuff
    gradientStart 	= CGPointMake(0.5f, 0.0f);
    gradientEnd		= CGPointMake(0.5f, 1.0f);
    
    // Initialize values
    [self setBackgroundColor:[UIColor clearColor]];
    [self setContentMode:UIViewContentModeRedraw];
}

+(Class)layerClass
{
    return [CAGradientLayer class];
}

#pragma mark- Layout

-(void)layoutSubviews
{
    // Super first
    [super layoutSubviews];
}

#pragma mark- Color

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]]; // We're using the backgroundLayer for color now
    
    bgColorArr = [NSArray arrayWithObject:backgroundColor];
    //numColors = 1;
    free(bgColors); // TODO: not 100% sure this is safe...maybe should free this in dealloc as well
    bgColors = [NetstickUI getFloatArrayFromUIColors:[NSArray arrayWithObjects:backgroundColor, backgroundColor, nil]];
}

-(void)setBackgroundGradientWithTopColor:(UIColor *)topColor andBottomColor:(UIColor *)bottomColor
{
    bgColorArr = [NSArray arrayWithObjects:topColor, bottomColor, nil];
    free(bgColors); // TODO: not 100% sure this is safe...maybe should free this in dealloc as well
    bgColors = [NetstickUI getFloatArrayFromUIColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

-(void)setBackgroundGradientWithColorArray:(NSArray *)colorArr
{
    bgColorArr = colorArr;
    free(bgColors); // TODO: not 100% sure this is safe...maybe should free this in dealloc as well
    bgColors = [NetstickUI getFloatArrayFromUIColors:bgColorArr];
}

-(void)setBackgroundGradientWithColorArray:(NSArray *)colorArr andLocationArray:(NSArray *)locationArr
{
    // Safety
    NSAssert(colorArr.count == locationArr.count, @"The number of colors and locations must match!");
    
    bgColorArr = colorArr;
    free(bgColors); // TODO: not 100% sure this is safe...maybe should free this in dealloc as well
    bgColors = [NetstickUI getFloatArrayFromUIColors:bgColorArr];
    
    bgLocationsArr = locationArr;
    free(bgLocations); // TODO: not 100% sure this is safe...maybe should free this in dealloc as well
    bgLocations = [NetstickUI getFloatArrayFromNSNumbers:bgLocationsArr];
}

-(void)setBackgroundGradientStartPoint:(CGPoint)point 	{ gradientStart = point; }
-(void)setBackgroundGradientEndPoint:(CGPoint)point		{ gradientEnd 	= point; }
-(void)setBackgroundGradientStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint{ gradientStart = startPoint; gradientEnd = endPoint; }

#pragma mark- Border

-(void)setBorderColor:(UIColor *)color
{
    borderColor = color;
}

-(void)setBorderWidth:(CGFloat)width
{
    borderWidth = width;
}

#pragma mark- Corners

-(void)setCornerRadius:(CGFloat)radius forCorners:(UIRectCorner)UIRectCorners
{
    cornerTL = (UIRectCorners & UIRectCornerTopLeft) 		? radius : 0;
    cornerTR = (UIRectCorners & UIRectCornerTopRight) 		? radius : 0;
    cornerBR = (UIRectCorners & UIRectCornerBottomRight) 	? radius : 0;
    cornerBL = (UIRectCorners & UIRectCornerBottomLeft) 	? radius : 0;
}

// Functional, but more complex than what we need?
-(void)setCornerRadiusForTopLeft:(NSInteger)topLeftRadius andTopRight:(NSInteger)topRightRadius andBottomLeft:(NSInteger)bottomLeftRadius andBottomRight:(NSInteger)bottomRightRadius;
{
    cornerTL = topLeftRadius;
    cornerTR = topRightRadius;
    cornerBR = bottomRightRadius;
    cornerBL = bottomLeftRadius;
}

#pragma mark- Drawing

-(void)drawRect:(CGRect)rect
{
    /* TODO: Test with transparent gradients
     UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
     CGContextSaveGState(UIGraphicsGetCurrentContext());
     CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
     CGContextRestoreGState(UIGraphicsGetCurrentContext());
     
     //Draw stuffs
     UIGraphicsEndImageContext();
     */
    
    // Get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Make the background gradient
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, bgColors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // Set the border color and stroke
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    
    // Fill in the background, inset by the border
    CGRect bounds = [self bounds];
    CGRect bgRect 		= CGRectMake(bounds.origin.x+borderWidth  , bounds.origin.y+borderWidth  , bounds.size.width-borderWidth*2, bounds.size.height-borderWidth*2);
    CGRect borderRect 	= CGRectMake(bounds.origin.x+borderWidth/2, bounds.origin.y+borderWidth/2, bounds.size.width-borderWidth  , bounds.size.height-borderWidth);
    CGPathRef bgPath 	= [NetstickUI newPathForRoundedRect:bgRect 		radiusTL:cornerTL radiusTR:cornerTR radiusBL:cornerBL radiusBR:cornerBR];
    CGPathRef borderPath= [NetstickUI newPathForRoundedRect:borderRect 	radiusTL:cornerTL radiusTR:cornerTR radiusBL:cornerBL radiusBR:cornerBR];
    
    // Background
    CGContextSaveGState(context); // Saves the state from before we clipped to the path
    CGContextAddPath(context, bgPath);
    CGContextClip(context); // Makes the gradient fill only the path
    CGPoint gradientStartInPoints 	= CGPointMake(gradientStart.x*bounds.size.width, gradientStart.y*bounds.size.height);
    CGPoint gradientEndInPoints 	= CGPointMake(gradientEnd.x*bounds.size.width, gradientEnd.y*bounds.size.height);
    CGContextDrawLinearGradient(context, gradient, gradientStartInPoints, gradientEndInPoints, 0); // Draw a vertical gradient
    CGContextRestoreGState(context); // Now we are no longer clipped to the path
    
    // Border
    CGContextAddPath(context, borderPath);
    CGContextStrokePath(context);
    
    // Clean up memory
    CGPathRelease(bgPath);
    CGPathRelease(borderPath);
    CGGradientRelease(gradient);
}
#pragma mark- Convenience

-(void)removeAllSubviews
{
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
}

#pragma mark- Getters

-(CGFloat)cornerTL{return cornerTL;}
-(CGFloat)cornerTR{return cornerTR;}
-(CGFloat)cornerBR{return cornerBR;}
-(CGFloat)cornerBL{return cornerBL;}

-(UIColor*)borderColor			{ return borderColor; }
-(CGFloat)borderWidth			{ return borderWidth; }
-(UIColor*)backgroundColor		{ return ([bgColorArr count] > 0) ? [bgColorArr objectAtIndex:0] : nil; }
-(NSArray*)backgroundColorArray { return bgColorArr; }


@end
