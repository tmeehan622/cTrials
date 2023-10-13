//
//  AdvancedCell.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/6/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "AdvancedCell.h"


@implementation AdvancedCell
@synthesize contentEdit, tableIndex;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        contentEdit = [[UITextField alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 24, TEXT_EDIT_WIDTH, TEXT_HEIGHT+4)];
				
//		contentEdit.lineBreakMode = UILineBreakModeWordWrap;
//		contentEdit.numberOfLines = 0;
		contentEdit.font = [UIFont systemFontOfSize:13];
		contentEdit.borderStyle = UITextBorderStyleNone;
		contentEdit.returnKeyType = UIReturnKeyDone;
		contentEdit.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		contentEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self addSubview:contentEdit];
		
		contentEdit.hidden = YES;
	}
    return self;
}




-(void) setInfo:(NSDictionary*)d
{
	contentEdit.hidden = YES;
	contentText.hidden = NO;
	info = d;
	if(info)
	{
#ifdef __DEBUG_OUTPUT__
		NSLog(@"%@",d);
#endif
		contentTitle.text = info[@"label"];
		id			value = info[@"value"];
		NSArray*	labels = info[@"labels"];
		NSArray*	values = info[@"values"];
		if(labels)
		{
			if(![info[@"multi"] boolValue])
			{
				contentText.text = labels[[value intValue]];
			}
			else
			{
				NSArray*	displayStrings = @[];
				int			i;
				for(i=0;i<[values count]; i++)
				{
					if([values[i] intValue])
						displayStrings = [displayStrings arrayByAddingObject:labels[i]];
				}
				contentText.text = [displayStrings componentsJoinedByString:@", "];
			}
		} // labels
		else if([info[@"dateRange"] boolValue])
		{
			NSString* beginString = values[0];
			NSString* endString = values[1];
			if([beginString length] == 0 && [endString length] == 0)
				contentText.text = @"";
			else if([beginString length] != 0 && [endString length] == 0)
				contentText.text = [NSString stringWithFormat:@"After %@", values[0]];
			else if([beginString length] == 0 && [endString length] != 0)
				contentText.text = [NSString stringWithFormat:@"Before %@", values[1]];
			else
				contentText.text = [NSString stringWithFormat:@"From: %@ To: %@", values[0], values[1]];
		} // dateRange
		else if(info[@"edit"])
		{
			contentEdit.text = value;
			contentText.hidden = YES;
			contentEdit.hidden = NO;
		}
		else
			contentText.text = @"";
		
	} // if info
	else
	{
		contentTitle.text = @"";
		contentText.text = @"";
	}
	
}

@end
