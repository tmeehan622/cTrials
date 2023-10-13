//
//  TrialViewCell.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/5/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "TrialViewCell.h"

@implementation TrialViewCell
@dynamic info;

+(double) neededCellHeightFor:(NSString*)text forWidth:(double)withWidth
{
	CGRect dataRect = CGRectMake(0, 0, withWidth, 1000);
	
	UILabel*	theData = [[UILabel alloc] initWithFrame:dataRect];
	theData.lineBreakMode = UILineBreakModeWordWrap;
	theData.numberOfLines = 0;
	NS_DURING
	theData.text = text;
	NS_HANDLER
	theData.text = @"\n";
	NS_ENDHANDLER
	theData.font = [UIFont systemFontOfSize:13];
	
	CGRect	neededSize = [theData textRectForBounds:dataRect limitedToNumberOfLines:0];
	
	return neededSize.size.height + 20;
} //

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 4, 290, 24)];
        contentText = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 24, TEXT_WIDTH, 16)];

//		contentTitle.backgroundColor = [UIColor clearColor];
//		contentText.backgroundColor = [UIColor clearColor];

		contentTitle.lineBreakMode = UILineBreakModeWordWrap;
		contentTitle.numberOfLines = 1;
		contentTitle.font = [UIFont boldSystemFontOfSize:15];
		
		contentText.lineBreakMode = UILineBreakModeWordWrap;
		contentText.numberOfLines = 0;
		contentText.font = [UIFont systemFontOfSize:13];

		contentTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		contentText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:contentTitle];
		[self addSubview:contentText];

	}
    return self;
}

-(NSDictionary*)info
{
	return info;
} // info

-(void) setInfo:(NSDictionary*)d
{
	info = d;
	if(info)
	{
		contentTitle.text = info[@"title"];
		NS_DURING
		contentText.text = info[@"text"];
		NS_HANDLER
		NSLog(@"%@", info[@"text"]);
		NS_ENDHANDLER
		if(info[@"PMID"])
			contentText.textColor = [UIColor blueColor];
		else
			contentText.textColor = [UIColor blackColor];
	} // if info
	else
	{
		contentTitle.text = @"";
		contentText.text = @"";
	}
	
	CGRect r = contentText.frame;
	r.size.height = [d[@"height"] doubleValue];
	contentText.frame = r;
}
@end
