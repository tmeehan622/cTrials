//
//  ResultCellView.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 10/12/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "ResultCellView.h"
#import "ResultsViewController.h"
#import "RoundedCornerView.h"

#define	TEXT_PAD	4
#define	TEXT_OFFSET 36
#define TEXT_WIDTH (275-TEXT_OFFSET)

#define CHANGED_WIDTH 180
#define STATUS_WIDTH (320 - CHANGED_WIDTH - TEXT_PAD)

#define color_DarkGreen   [UIColor colorWithRed:0 green:0.5 blue:0.25 alpha:1]
#define color_DarkYellow  [UIColor colorWithRed:207.0/256.0 green:154.0/256.0 blue:0 alpha:1]
#define color_DarkRed     [UIColor colorWithRed:0.67 green:0.00 blue:0.00 alpha:1.0];
#define color_Amber       [UIColor colorWithRed:231/256.0 green:170.0/256.0 blue:46.0/256.0 alpha:1]

@interface NSString(substringExtension)
-(BOOL) hasSubString:(NSString*)sub;
@end

@implementation NSString(substringExtension)
-(BOOL) hasSubString:(NSString*)sub
{
	NSString*	subper = [sub uppercaseString];
	NSString*	selper = [self uppercaseString];
	
	NSRange		r = [selper rangeOfString:subper];
	
	return (r.location != NSNotFound);
}
@end

@implementation ResultCellView
//@dynamic info;

//@synthesize label_HeaderNumber;
@synthesize label_BodyTitle,
            label_BodySummary,
            label_HeaderNumber,
            label_HeaderStatus,
            label_BodyLastChanged,
            button_VM,
            button_Note,
            iv_UnreadDot,
            view_BGTop,
            view_BGBottom,
            info;

/*
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
    }
    return self;
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    button_Note.hidden = YES;
    button_VM.hidden = YES;
    [view_BGTop     setRadius:8 forCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [view_BGBottom  setRadius:8 forCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
}

/*
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        label_BodyTitle = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 16, 320 -(TEXT_PAD+TEXT_OFFSET), 36)];
        label_BodySummary = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 36+16, TEXT_WIDTH, 30)];
		label_BodyLastChanged = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 36+27+16, 320 -(TEXT_PAD+TEXT_OFFSET), 15)];
		label_HeaderStatus = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD, 0, 320-TEXT_PAD, 16)];

		label_HeaderNumber = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD, 20, TEXT_OFFSET, 15)];
		view_BGTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];

		title.backgroundColor = [UIColor clearColor];
		condition_summary.backgroundColor = [UIColor clearColor];
		last_changed.backgroundColor = [UIColor clearColor];
		status.backgroundColor = [UIColor clearColor];
		recordNumber.backgroundColor = [UIColor clearColor];
		view_BGTop.backgroundColor = [UIColor colorWithHue:58.0/360.0 saturation:0.68 brightness:0.90 alpha:1.0];
		
		title.lineBreakMode = UILineBreakModeWordWrap;
		title.numberOfLines = 2;
		title.font = [UIFont boldSystemFontOfSize:15];
		
		condition_summary.lineBreakMode = UILineBreakModeWordWrap;
		condition_summary.numberOfLines = 2;
		condition_summary.font = [UIFont systemFontOfSize:13];

		last_changed.font = [UIFont systemFontOfSize:13];
		status.font = [UIFont boldSystemFontOfSize:13];
		status.textAlignment = UITextAlignmentLeft;
		status.textColor = [UIColor whiteColor];
		
		recordNumber.font = [UIFont boldSystemFontOfSize:10];
		recordNumber.textAlignment = UITextAlignmentLeft;
		recordNumber.textColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];

		iv_UnreadDot = [[UIImageView alloc] initWithFrame:CGRectMake(TEXT_OFFSET/3, 98/2 - 8, 16, 16)];

		[self addSubview:label_BodyTitle];
		[self addSubview:label_BodySummary];
		[self addSubview:label_BodyLastChanged];
		[self addSubview:view_BGTop];
		[view_BGTop addSubview:label_HeaderStatus];
		[self addSubview:iv_UnreadDot];
		[self addSubview:label_HeaderNumber];
		

		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		condition_summary.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		last_changed.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		status.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		view_BGTop.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.backgroundColor = [UIColor clearColor];
	}
    return self;
}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	double	lineWidth = 2;
	CGContextSetRGBStrokeColor(ctx, 0.75, 0.75, 0.75, 1.0);	// define stroke color
	CGContextSetLineWidth(ctx, lineWidth);	// define line width
    CGContextMoveToPoint(ctx, 0, self.frame.size.height-lineWidth);
	CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height-lineWidth);
    CGContextStrokePath(ctx); 
} // drawRect
*/


-(void)setInfo:(NSDictionary*)d
{
	info = d;
	if(info)
	{
		label_BodyTitle.text        = d[@"title"];
		label_BodySummary.text      = d[@"condition_summary"];
		label_BodyLastChanged.text  = [NSString stringWithFormat:@"Last Changed:%@", d[@"last_changed"]];

		NSString* value = [d objectAtPath:@"status/value"];
		if([[d objectAtPath:@"status/attributes/open"] hasPrefix:@"Y"])
		{
			label_HeaderStatus.text = [NSString stringWithFormat:@"Open %@", value];
			if(![[value uppercaseString] hasPrefix:@"REC"])
				view_BGTop.backgroundColor = color_Amber;
			else
				view_BGTop.backgroundColor = color_DarkGreen;
		}
		else
		{
			label_HeaderStatus.text = [NSString stringWithFormat:@"Closed %@", value];
			if([[value uppercaseString] hasPrefix:@"ACT"])
				view_BGTop.backgroundColor = color_Amber;
			else
				view_BGTop.backgroundColor = color_DarkRed;
		}
        
        iv_UnreadDot.hidden = [ResultsViewController hasBeenViewed:info[@"nct_id"]];
					
        /*
		if(![ResultsViewController hasBeenViewed:info[@"nct_id"]])
            iv_UnreadDot.image = [UIImage imageNamed:@"Cell_Unread"];
			//theDot.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blueDot" ofType:@"png"]];
		else
			iv_UnreadDot.image = nil;
        */
	}
} // setInfo

-(NSDictionary*)info
{
	return info;
} // info

@end
