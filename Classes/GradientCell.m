//
//  GradientCell.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/18/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "GradientCell.h"


@implementation GradientCell

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGColorRef colors[2];
	CGFloat locations[2] = {0.0, 1.0};
	CGColorSpaceRef colorSpace;
	
	colorSpace = CGColorSpaceCreateDeviceGray();
	colors[0] = [[UIColor colorWithWhite:1.00 alpha:0.8] CGColor];
	colors[1] = [[UIColor colorWithWhite:0.85 alpha:0.8] CGColor];
	
	CFArrayRef gradientColors = CFArrayCreate(NULL, (void *)colors, 2, &kCFTypeArrayCallBacks);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextDrawLinearGradient(ctxt, gradient, rect.origin, CGPointMake(rect.origin.x, rect.origin.y+rect.size.height), 0);
	CFRelease(gradientColors);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	
}

@end
