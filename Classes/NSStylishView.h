//
//  NSStylishView.h
//  InstagramCommentsPro
//
//  Created by Joseph Falcone on 6/16/15.
//  Copyright (c) 2015 American Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: Modernize this...based too heavily off of the old AOStylishView
@interface NSStylishView : UIView
{
    // Rounded Corners
    CGFloat		cornerTL, cornerTR, cornerBR, cornerBL;
    
    // Border
    CGFloat		borderWidth;
    UIColor		*borderColor;
    
    // Colors
    CGFloat		*bgColors; // array of colors used in drawrect
    NSArray		*bgColorArr; // used to keep track of the colors in the getter
    CGFloat		*bgLocations; // array of locations for the colors in the array
    NSArray		*bgLocationsArr; //
    
    // Gradient points
    CGPoint gradientStart;
    CGPoint gradientEnd;
}
/*
@property(nonatomic, assign)IBInspectable CGFloat cornerTL;
@property(nonatomic, assign)IBInspectable CGFloat cornerTR;
@property(nonatomic, assign)IBInspectable CGFloat cornerBL;
@property(nonatomic, assign)IBInspectable CGFloat cornerBR;
@property(nonatomic, assign)IBInspectable CGFloat borderWidth;
@property(nonatomic, strong)IBInspectable UIColor *borderColor;
*/

-(CGFloat)cornerTL;
-(CGFloat)cornerTR;
-(CGFloat)cornerBR;
-(CGFloat)cornerBL;
-(UIColor*)borderColor;
-(CGFloat)borderWidth;

-(UIColor*)backgroundColor;
-(NSArray*)backgroundColorArray;

-(void)setBackgroundGradientWithTopColor:(UIColor *)topColor andBottomColor:(UIColor *)bottomColor;
-(void)setBackgroundGradientWithColorArray:(NSArray *)colorArr;
-(void)setBackgroundGradientWithColorArray:(NSArray *)colorArr andLocationArray:(NSArray *)locationArr;
-(void)setBackgroundGradientStartPoint:(CGPoint)point; // 0.0-1.0
-(void)setBackgroundGradientEndPoint:(CGPoint)point;   // 0.0-1.0
-(void)setBackgroundGradientStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint;

-(void)setBorderColor:(UIColor *)borderColor;
-(void)setBorderWidth:(CGFloat)width;

-(void)setCornerRadius:(CGFloat)radius forCorners:(UIRectCorner)UIRectCorners;
-(void)setCornerRadiusForTopLeft:(NSInteger)topLeftRadius andTopRight:(NSInteger)topRightRadius andBottomLeft:(NSInteger)bottomLeftRadius andBottomRight:(NSInteger)bottomRightRadius;

@end
