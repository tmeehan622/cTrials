//
//  LocationsCell.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/20/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "LocationsCell.h"
#import "GenericParser.h"

#define	TEXT_PAD	4
#define	TEXT_OFFSET 10
#define TEXT_WIDTH (275-TEXT_OFFSET)



@implementation LocationsCell
@dynamic info;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
        name = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 0, 320 - (TEXT_PAD+TEXT_OFFSET*2), 40)];
        address = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 40, 320 - (TEXT_PAD+TEXT_OFFSET*2), 15)];
		contact = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 60, 320 - (TEXT_PAD+TEXT_OFFSET*2), 45)];
		contact_backup = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 110, 320 - (TEXT_PAD+TEXT_OFFSET*2), 45)];
		investigator = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PAD+TEXT_OFFSET, 155, 320 - (TEXT_PAD+TEXT_OFFSET*2), 45)];
 
		name.numberOfLines = 2;
		name.lineBreakMode = UILineBreakModeWordWrap;
		contact.numberOfLines = 3;
		contact.lineBreakMode = UILineBreakModeWordWrap;
		contact_backup.numberOfLines = 3;
		contact_backup.lineBreakMode = UILineBreakModeWordWrap;
		investigator.numberOfLines = 3;
		investigator.lineBreakMode = UILineBreakModeWordWrap;
		
		name.backgroundColor = [UIColor clearColor];
		address.backgroundColor = [UIColor clearColor];
		contact.backgroundColor = [UIColor clearColor];
		contact_backup.backgroundColor = [UIColor clearColor];
		investigator.backgroundColor = [UIColor clearColor];
		
		name.font = [UIFont boldSystemFontOfSize:15];
		address.font = [UIFont systemFontOfSize:13];
		contact.font = [UIFont systemFontOfSize:13];
		contact_backup.font = [UIFont systemFontOfSize:13];
		investigator.font = [UIFont systemFontOfSize:13];

		[self addSubview:name];
		[self addSubview:address];
		[self addSubview:contact];
		[self addSubview:contact_backup];
		[self addSubview:investigator];


		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
    return self;
}

 // dealloc

-(void) setInfo:(NSDictionary*)d
{
	info = d;
	if(info)
	{
		NSString*	nameString = [info objectAtPath:@"facility/name"];
		NSString*	cityString = [info objectAtPath:@"facility/address/city"];
		NSString*	stateString = [info objectAtPath:@"facility/address/state"];
		NSString*	zipString = [info objectAtPath:@"facility/address/zip"];
		NSString*	countryString = [info objectAtPath:@"facility/address/country"];
		
		if(stateString)
		{
			cityString = [cityString stringByAppendingFormat:@", %@", stateString];
			if(zipString)
				cityString = [cityString stringByAppendingFormat:@" %@", zipString];
		}
		
		if(countryString)
			cityString = [cityString stringByAppendingFormat:@", %@", countryString];
		
		name.text = nameString;
		address.text = cityString;
		
		NSDictionary*	contactInfo = [info objectAtPath:@"contact"];
		NSDictionary*	backupContactInfo = [info objectAtPath:@"contact_backup"];
		NSArray*		investigators = [info objectAtPath:@"investigator"];
		if(investigators && ![investigators isKindOfClass:[NSArray class]])
			investigators = @[investigators];
		
		if(contactInfo)
		{
			NSString*	tmpStr = @"";
			NSString*	phone = [contactInfo objectAtPath:@"phone"];
			NSString*	email = [contactInfo objectAtPath:@"email"];
			tmpStr = [tmpStr stringByAppendingFormat:@"Contact: %@\n   Phone: %@\n   Email: %@",
					  [contactInfo objectAtPath:@"last_name"], 
					  phone ? phone : @"(no phone given)",
					  email ? email : @"(no email given)"];
			contact.text = tmpStr;
		}
		if(backupContactInfo)
		{
			NSString*	tmpStr = @"";
			NSString*	phone = [backupContactInfo objectAtPath:@"phone"];
			NSString*	email = [backupContactInfo objectAtPath:@"email"];
			tmpStr = [tmpStr stringByAppendingFormat:@"Contact: %@\n   Phone: %@\n   Email: %@",
					  [backupContactInfo objectAtPath:@"last_name"], 
					  phone ? phone : @"(no phone given)",
					  email ? email : @"(no email given)"];
			contact_backup.text = tmpStr;
		}
#if 1
		if(investigators)
		{
			NSArray*	investigatorArray = @[];
			for(NSDictionary* inv in investigators)
			{
				NSString*	tmpStr = @"";
				NSString*	role = [inv objectAtPath:@"role"];
				NSString*	last_name = [inv objectAtPath:@"last_name"];
				tmpStr = [tmpStr stringByAppendingFormat:@"%@: %@", role, last_name];
				
				investigatorArray = [investigatorArray arrayByAddingObject:tmpStr];
			} // for
			investigator.text = [investigatorArray componentsJoinedByString:@"\n"];
		}
#endif
	} // setInfo
	else
	{
		name.text = @"";
		address.text = @"";
	}
} // setInfo

-(NSDictionary*)info
{
	return info;
} // info


@end
