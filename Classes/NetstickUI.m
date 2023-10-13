//
//  NetstickUI.m
//  NetstickUI
//
//  Created by Joseph Falcone on 4/25/15.
//  Copyright (c) 2015 Netstick. All rights reserved.
//

#import "NetstickUI.h"

@implementation NetstickUI

+(NSArray *)colorsAlongArray:(NSArray *)colorArr withSteps:(NSInteger)steps
{
    NSInteger arrCount = colorArr.count;
    //CGFloat stepIncrement = (steps%2==0) ? (CGFloat)arrCount/(CGFloat)(steps+1) : (CGFloat)arrCount/(CGFloat)(steps); // If even, add 1 to end at the final color
    CGFloat stepIncrement = (CGFloat)arrCount/(CGFloat)(steps);
    NSMutableArray *returnArr = [NSMutableArray array];
    
    for(NSInteger i = 0; i < steps; i++)
    {
        CGFloat stepVal = stepIncrement*i;
        CGFloat stepFactor = fmodf(stepVal, 1.0f);
        
        NSInteger stepIndex1 = floor(stepVal/1.0f);
        NSInteger stepIndex2 = ceilf(stepVal/1.0f);
        if(stepIndex2 > arrCount-1)
            stepIndex2 = arrCount-1;
        UIColor *color1 = colorArr[stepIndex1];
        UIColor *color2 = colorArr[stepIndex2];
        
        UIColor *c = [self colorByInterpolatingColor:color1 withColor:color2 factor:stepFactor];
        [returnArr addObject:c];
        
        //NSLog(@"StepIndex1: %ld, StepIndex2: %ld, StepFactor: %f, StepVal: %f", stepIndex1, stepIndex2, stepFactor, stepVal);
    }
    return returnArr;
}

+(UIColor *)colorByInterpolatingColor:(UIColor *)color1 withColor:(UIColor *)color2 factor:(CGFloat)factor
{
    //t would then be a location between 0.0..1.0 relative to the two colors, not the entire gradient
    //factor = MIN(MAX(t, 0.0), 1.0);
    
    const CGFloat *startComponent = CGColorGetComponents(color1.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(color2.CGColor);
    
    float startAlpha = CGColorGetAlpha(color1.CGColor);
    float endAlpha = CGColorGetAlpha(color2.CGColor);
    
    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * factor;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * factor;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * factor;
    float a = startAlpha + (endAlpha - startAlpha) * factor;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+(CGFloat *)getFloatArrayFromNSNumbers:(NSArray *)arrNumbers
{
    NSInteger index = 0;
    CGFloat *returnArr = (CGFloat *) malloc(sizeof(CGFloat) * [arrNumbers count]);
    for(NSNumber *number in arrNumbers)
    {
        returnArr[index] = [number floatValue];
        index++;
    }
    
    return returnArr;
}

+(CGFloat *)getFloatArrayFromUIColors:(NSArray*)arrColors
{
    arrColors = @[[UIColor redColor], [UIColor blueColor]];
    
    NSInteger index = 0;
    CGFloat *returnArr = (CGFloat *) malloc(sizeof(CGFloat) * [arrColors count]*4);
    for(UIColor *color in arrColors)
    {
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        if([color respondsToSelector:@selector(getRed:green:blue:alpha:)])
        { [color getRed:&red green:&green blue:&blue alpha:&alpha]; }
        else
        {
            const CGFloat *components = CGColorGetComponents(color.CGColor);
            red = components[0];
            green = components[1];
            blue = components[2];
            alpha = components[3];
        }
        
        red = 1;
        green = 0;
        blue = 0;
        alpha = 1;
        
        returnArr[index] = red;		index++;
        returnArr[index] = green;	index++;
        returnArr[index] = blue;	index++;
        returnArr[index] = alpha;	index++;
        
        //NSLog(@"Adding Color: r:%f, g:%f, b%f, a%f", red, green, blue, alpha);
    }
    
    return returnArr;
}

+(CGPathRef)newPathForRoundedRect:(CGRect)rect
                         radiusTL:(CGFloat)radTL
                         radiusTR:(CGFloat)radTR
                         radiusBL:(CGFloat)radBL
                         radiusBR:(CGFloat)radBR
{
//	CGFloat scale = [[UIScreen mainScreen] scale];
//    radTL /= scale;
//    radTR /= scale;
//    radBL /= scale;
//    radBR /= scale;
    
    CGMutablePathRef retPath = CGPathCreateMutable();
    
    // Convenience
    CGFloat rectL = rect.origin.x;
    CGFloat rectR = rect.origin.x+rect.size.width;
    CGFloat rectT = rect.origin.y;
    CGFloat rectB = rect.origin.y+rect.size.height;
    
    // Starting from the top left arc, move clockwise
    CGPoint p1 = CGPointMake(rectL		, rectT+radTL);
    CGPoint p2 = CGPointMake(rectL+radTL, rectT);
    CGPoint p3 = CGPointMake(rectR-radTR, rectT);
    CGPoint p4 = CGPointMake(rectR		, rectT+radTR);
    CGPoint p5 = CGPointMake(rectR		, rectB-radBR);
    CGPoint p6 = CGPointMake(rectR-radBR, rectB);
    CGPoint p7 = CGPointMake(rectL+radBL, rectB);
    CGPoint p8 = CGPointMake(rectL		, rectB-radBL);
    
    CGPoint c1 = CGPointMake(rect.origin.x					, rect.origin.y);
    CGPoint c2 = CGPointMake(rect.origin.x+rect.size.width	, rect.origin.y);
    CGPoint c3 = CGPointMake(rect.origin.x+rect.size.width	, rect.origin.y+rect.size.height);
    CGPoint c4 = CGPointMake(rect.origin.x					, rect.origin.y+rect.size.height);
    
    CGPathMoveToPoint(retPath, NULL, p1.x, p1.y);
    
    CGPathAddArcToPoint (retPath, NULL, c1.x, c1.y, p2.x, p2.y, radTL);
    CGPathAddLineToPoint(retPath, NULL, p3.x, p3.y);
    
    CGPathAddArcToPoint (retPath, NULL, c2.x, c2.y, p4.x, p4.y, radTR);
    CGPathAddLineToPoint(retPath, NULL, p5.x, p5.y);
    
    CGPathAddArcToPoint (retPath, NULL, c3.x, c3.y, p6.x, p6.y, radBR);
    CGPathAddLineToPoint(retPath, NULL, p7.x, p7.y);
    
    CGPathAddArcToPoint (retPath, NULL, c4.x, c4.y, p8.x, p8.y, radBL);
    CGPathAddLineToPoint(retPath, NULL, p1.x, p1.y);
    
    CGPathCloseSubpath(retPath);
    
    return retPath;
}

+(CGPathRef)newPathForRoundedRect:(CGRect)rect
                         radiusTL:(CGFloat)radTL
                         radiusTR:(CGFloat)radTR
                         radiusBL:(CGFloat)radBL
                         radiusBR:(CGFloat)radBR
                            edges:(NSInteger)edges
{
    // Only draw the path for the specified edges
    if(edges & UIRectEdgeAll ||
       (edges & UIRectEdgeLeft && edges & UIRectEdgeRight && edges & UIRectEdgeTop && edges & UIRectEdgeBottom))
    { return [self newPathForRoundedRect:rect radiusTL:radTL radiusTR:radTR radiusBL:radBL radiusBR:radBR]; }
    
    CGMutablePathRef retPath = CGPathCreateMutable();
    
    // Convenience
    CGFloat rectL = rect.origin.x;
    CGFloat rectR = rect.origin.x+rect.size.width;
    CGFloat rectT = rect.origin.y;
    CGFloat rectB = rect.origin.y+rect.size.height;
    
    // Starting from the top left arc, move clockwise
    CGPoint p1 = CGPointMake(rectL		, rectT+radTL);
    CGPoint p2 = CGPointMake(rectL+radTL, rectT);
    CGPoint p3 = CGPointMake(rectR-radTR, rectT);
    CGPoint p4 = CGPointMake(rectR		, rectT+radTR);
    CGPoint p5 = CGPointMake(rectR		, rectB-radBR);
    CGPoint p6 = CGPointMake(rectR-radBR, rectB);
    CGPoint p7 = CGPointMake(rectL+radBL, rectB);
    CGPoint p8 = CGPointMake(rectL		, rectB-radBL);
    
    CGPoint c1 = CGPointMake(rect.origin.x					, rect.origin.y);
    CGPoint c2 = CGPointMake(rect.origin.x+rect.size.width	, rect.origin.y);
    CGPoint c3 = CGPointMake(rect.origin.x+rect.size.width	, rect.origin.y+rect.size.height);
    CGPoint c4 = CGPointMake(rect.origin.x					, rect.origin.y+rect.size.height);
    
    if(edges & UIRectEdgeTop)
    {
        CGPathMoveToPoint(retPath, NULL, p1.x, p1.y);
        CGPathAddArcToPoint (retPath, NULL, c1.x, c1.y, p2.x, p2.y, radTL);
        CGPathAddLineToPoint(retPath, NULL, p3.x, p3.y);
        CGPathAddArcToPoint (retPath, NULL, c2.x, c2.y, p4.x, p4.y, radTR);
    }
    
    if(edges & UIRectEdgeRight)
    {
        CGPathMoveToPoint(retPath, NULL, p3.x, p3.y);
        CGPathAddArcToPoint (retPath, NULL, c2.x, c2.y, p4.x, p4.y, radTR);
        CGPathAddLineToPoint(retPath, NULL, p5.x, p5.y);
        CGPathAddArcToPoint (retPath, NULL, c3.x, c3.y, p6.x, p6.y, radBR);
    }
    
    if(edges & UIRectEdgeBottom)
    {
        CGPathMoveToPoint(retPath, NULL, p5.x, p5.y);
        CGPathAddArcToPoint (retPath, NULL, c3.x, c3.y, p6.x, p6.y, radBR);
        CGPathAddLineToPoint(retPath, NULL, p7.x, p7.y);
        CGPathAddArcToPoint (retPath, NULL, c4.x, c4.y, p8.x, p8.y, radBL);
    }
    
    if(edges & UIRectEdgeLeft)
    {
        CGPathMoveToPoint(retPath, NULL, p7.x, p7.y);
        CGPathAddArcToPoint (retPath, NULL, c4.x, c4.y, p8.x, p8.y, radBL);
        CGPathAddLineToPoint(retPath, NULL, p1.x, p1.y);
        CGPathAddArcToPoint (retPath, NULL, c1.x, c1.y, p2.x, p2.y, radTL);
    }
    
    return retPath;
}

@end
