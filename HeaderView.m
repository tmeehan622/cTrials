//
//  HeaderView.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 12/2/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "HeaderView.h"


@implementation HeaderView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	double	lineWidth = 1;
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);	// define stroke color
	CGContextSetLineWidth(ctx, lineWidth);	// define line width
    CGContextMoveToPoint(ctx, 0, self.frame.size.height-lineWidth);
	CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height-lineWidth);
    CGContextStrokePath(ctx); 
	
}


@end
