//
//  NetstickUI.h
//  NetstickUI
//
//  Created by Joseph Falcone on 4/25/15.
//  Copyright (c) 2015 American Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetstickUI : NSObject

/*!
 * @discussion Takes a gradient as an array of colors, then returns an array of colors selected from the gradient.
 * @param colorArr Array of UIColors representing a gradient with even steps.
 * @param steps Number of sample points from which colors will be selected evenly along the gradient.
 * @return The UIColors selected from the gradient.
 */
+(NSArray *)colorsAlongArray:(NSArray *)colorArr withSteps:(NSInteger)steps;

/*!
 * @discussion Blends two colors together.
 * @param color1 The starting color.
 * @param color2 The ending color.
 * @param factor A value between 0 and 1 defining the sample point.
 * @return The blended UIColor.
 */
+(UIColor *)colorByInterpolatingColor:(UIColor *)color1 withColor:(UIColor *)color2 factor:(CGFloat)factor;

/*!
 * @discussion Converts an array of NSNumbers to an array of floats.
 * @param arrNumbers The array of NSNumbers to convert.
 * @return A C array of floats.
 */
+(CGFloat *)getFloatArrayFromNSNumbers:(NSArray *)arrNumbers;

/*!
 * @discussion Converts an array of UIColors to an array of floats.
 * @param arrColors The array of UIColors to convert.
 * @return A C array of floats. Each color becomes a sequence of four floats (RGBA).
 */
+(CGFloat *)getFloatArrayFromUIColors:(NSArray*)arrColors;

/*!
 * @discussion Creates a CGPathRef with rounded corners. Remember to deallocate.
 * @param radiusTL Radius of the top left corner.
 * @param radiusTR Radius of the top right corner.
 * @param radiusBL Radius of the bottom left corner.
 * @param radiusBR Radius of the bottom right corner.
 * @return A CGPathRef with rounded corners.
 */
+(CGPathRef)newPathForRoundedRect:(CGRect)rect
                         radiusTL:(CGFloat)radTL
                         radiusTR:(CGFloat)radTR
                         radiusBL:(CGFloat)radBL
                         radiusBR:(CGFloat)radBR;

/*!
 * @discussion Creates a CGPathRef with rounded corners. Only the specified edges will be included. Remember to deallocate.
 * @param radiusTL Radius of the top left corner.
 * @param radiusTR Radius of the top right corner.
 * @param radiusBL Radius of the bottom left corner.
 * @param radiusBR Radius of the bottom right corner.
 * @param edges The UIRectEdges which should be included in the path.
 * @return A CGPathRef with rounded corners.
 */
+(CGPathRef)newPathForRoundedRect:(CGRect)rect
                         radiusTL:(CGFloat)radTL
                         radiusTR:(CGFloat)radTR
                         radiusBL:(CGFloat)radBL
                         radiusBR:(CGFloat)radBR
                            edges:(NSInteger)edges;

@end
