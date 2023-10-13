//
//  AdvancedSearchController.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 9/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "AdvancedSearchController.h"
#import "AdvancedCell.h"
#import "WhateverListController.h"
#import "ResultsViewController.h"
#import "DateRangeHandler.h"

enum {kBasic = 0, kTargeted, kLocation, kAdditional };

@implementation AdvancedSearchController
@dynamic state1, allFields;
@synthesize searchButton;

- (void)setAllFields:(NSString*)term
{
	NSMutableDictionary* x = tableCellContent[1][0];
	x[@"value"] = term;
} // setAllFields

- (NSString*) allFields
{
	NSMutableDictionary* x = tableCellContent[1][0];
	return x[@"value"];
} // allFields

- (void)setState1:(NSString*)term
{
	NSMutableDictionary* x = tableCellContent[1][0];
	x[@"value"] = term;
} // setAllFields

- (NSString*) state1
{
	NSMutableDictionary* x = tableCellContent[1][0];
	return x[@"value"];
} // allFields

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		activeTextField = nil;
		shouldSearch = NO;
		busyEditing = NO;
		
		searchButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Search",@"")
														style:UIBarButtonItemStylePlain
													   target:self
													   action:@selector(doSearch:)];
		
        tableHeaders = @[@"History", @"Fill in any or all of the fields below", @"Targeted Search", @"Locations", @"Additional Criteria"];

		tableCellContent = [NSMutableArray arrayWithObjects:
						   [NSMutableArray arrayWithObjects:
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Search Terms", @"label", @"", @"value", @"term", @"name", @YES, @"edit", nil],
							
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Recruitment", @"label", @0, @"value", @"recr", @"name",
							 [NSMutableArray arrayWithObjects:@"All Studies",@"Open Studies",@"Closed Studies", nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"Open", @"Closed", nil], @"values",
							 nil],
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Study Result", @"label", @0, @"value", @"rslt", @"name",
							 [NSMutableArray arrayWithObjects:@"All Studies",@"Studies With Results",@"Studies Without Results", nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"With", @"Without", nil], @"values",
							 nil],
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Study Type", @"label", @0, @"value", @"type", @"name",
							 [NSMutableArray arrayWithObjects:@"All Studies",@"Interventional Studies",@"Observational Studies", @"Expanded Access Studies", nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"Intr", @"Obsr", @"Expn", nil], @"values",
							 nil],
							nil],
							
							[NSMutableArray arrayWithObjects:
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Conditions", @"label", @"", @"value", @"cond", @"name", @YES, @"edit",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Interventions", @"label", @"", @"value", @"intr", @"name", @YES, @"edit",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Outcome Measures", @"label", @"", @"value", @"outc", @"name", @YES, @"edit",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Lead Sponsors", @"label", @"", @"value", @"lead", @"name", @YES, @"edit",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Sponsors", @"label", @"", @"value", @"spons", @"name", @YES, @"edit",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Study Ids", @"label", @"", @"value", @"id", @"name", @YES, @"edit",nil],
							 nil],
							
							[NSMutableArray arrayWithObjects:
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"State 1", @"label", @0, @"value", @"state1", @"name",
							  [NSMutableArray arrayWithObjects:@"Optional", @"United States, Alabama", @"United States, Alaska", @"United States, Arizona", @"United States, Arkansas", @"United States, California", @"United States, Colorado", @"United States, Connecticut", @"United States, Delaware", @"United States, District of Columbia", @"United States, Florida", @"United States, Georgia", @"United States, Hawaii", @"United States, Idaho", @"United States, Illinois", @"United States, Indiana",
							   @"United States, Iowa", @"United States, Kansas", @"United States, Kentucky", @"United States, Louisiana", @"United States, Maine", @"United States, Maryland", @"United States, Massachusetts", @"United States, Michigan", @"United States, Minnesota", @"United States, Mississippi", @"United States, Missouri", @"United States, Montana", @"United States, Nebraska", @"United States, Nevada", @"United States, New Hampshire",
							   @"United States, New Jersey", @"United States, New Mexico", @"United States, New York", @"United States, North Carolina", @"United States, North Dakota", @"United States, Ohio", @"United States, Oklahoma", @"United States, Oregon", @"United States, Pennsylvania", @"United States, Rhode Island", @"United States, South Carolina", @"United States, South Dakota", @"United States, Tennessee", @"United States, Texas", @"United States, Utah",
							   @"United States, Vermont", @"United States, Virginia", @"United States, Washington", @"United States, West Virginia", @"United States, Wisconsin", @"United States, Wyoming", @"Canada, Alberta", @"Canada, British Columbia", @"Canada, Manitoba", @"Canada, New Brunswick", @"Canada, Newfoundland and Labrador", @"Canada, Nova Scotia", @"Canada, Ontario", @"Canada, Prince Edward Island", @"Canada, Quebec", 
							   @"Canada, Saskatchewan", @"Australia, Australian Capital Territory", @"Australia, New South Wales", @"Australia, Northern Territory", @"Australia, Queensland", @"Australia, South Australia", @"Australia, Tasmania", @"Australia, Victoria", @"Australia, Western Australia",nil], @"labels",
							  [NSMutableArray arrayWithObjects:@"", @"NA:US:AL", @"NA:US:AK", @"NA:US:AZ", @"NA:US:AR", @"NA:US:CA", @"NA:US:CO", @"NA:US:CT", @"NA:US:DE", @"NA:US:DC", @"NA:US:FL", @"NA:US:GA", @"NA:US:HI", @"NA:US:ID", @"NA:US:IL", @"NA:US:IN",
							   @"NA:US:IA", @"NA:US:KS", @"NA:US:KY", @"NA:US:LA", @"NA:US:ME", @"NA:US:MD", @"NA:US:MA", @"NA:US:MI", @"NA:US:MN", @"NA:US:MS", @"NA:US:MO", @"NA:US:MT", @"NA:US:NE", @"NA:US:NV", @"NA:US:NH",
							   @"NA:US:NJ", @"NA:US:NM", @"NA:US:NY", @"NA:US:NC", @"NA:US:ND", @"NA:US:OH", @"NA:US:OK", @"NA:US:OR", @"NA:US:PA", @"NA:US:RI", @"NA:US:SC", @"NA:US:SD", @"NA:US:TN", @"NA:US:TX", @"NA:US:UT",
							   @"NA:US:VT", @"NA:US:VA", @"NA:US:WA", @"NA:US:WV", @"NA:US:WI", @"NA:US:WY", @"NA:CA:AB", @"NA:CA:BC", @"NA:CA:MB", @"NA:CA:NB", @"NA:CA:NF", @"NA:CA:NS", @"NA:CA:ON", @"NA:CA:PE", @"NA:CA:QC", 
							   @"NA:CA:SK", @"PA:AU:AC", @"PA:AU:SW", @"PA:AU:NT", @"PA:AU:QL", @"PA:AU:SA", @"PA:AU:TA", @"PA:AU:VC", @"PA:AU:WA",nil], @"values",
							  nil],

							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Country 1", @"label", @0, @"value", @"cntry1", @"name",
							 [NSMutableArray arrayWithObjects:@"Optional", @"United States", @"Afghanistan", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Argentina", @"Armenia", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize",
							  @"Benin", @"Bermuda", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Bulgaria", @"Burkina Faso", @"Cambodia", @"Cameroon", @"Canada", @"Central African Republic", @"Chile", @"China", @"Colombia", @"Congo", @"Congo, The Democratic Republic of the", @"Costa Rica", @"Croatia", @"Cuba",
							  @"Cyprus", @"Czech Republic", @"Côte D'Ivoire", @"Denmark", @"Dominican Republic", @"Ecuador", @"Egypt", @"El Salvador", @"Estonia", @"Ethiopia", @"Fiji", @"Finland", @"Former Yugoslavia", @"France", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Greece",
							  @"Guadeloupe", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Haiti", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran, Islamic Republic of", @"Iraq", @"Ireland", @"Israel", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan",
							  @"Kenya", @"Korea, Democratic People's Republic of", @"Korea, Republic of", @"Kuwait", @"Kyrgyzstan", @"Lao People's Democratic Republic", @"Latvia", @"Lebanon", @"Liberia", @"Libyan Arab Jamahiriya", @"Lithuania", @"Luxembourg", @"Macedonia, The Former Yugoslav Republic of", @"Madagascar", @"Malawi", @"Malaysia", @"Mali", @"Malta", @"Martinique", @"Mauritania",
							  @"Mauritius", @"Mexico", @"Moldova, Republic of", @"Monaco", @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique", @"Myanmar", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Northern Mariana Islands", @"Norway",
							  @"Oman", @"Pakistan", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Romania", @"Russian Federation", @"Rwanda", @"Réunion", @"Saint Kitts and Nevis", @"Saudi Arabia", @"Senegal", @"Serbia", @"Serbia and Montenegro",
							  @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"South Africa", @"Spain", @"Sri Lanka", @"Sudan", @"Swaziland", @"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan", @"Tanzania", @"Thailand", @"Togo", @"Trinidad and Tobago", @"Tunisia",
							  @"Turkey", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Venezuela", @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe",
							  nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"NA:US", @"SS:AF", @"EU:AL", @"AF:DZ", @"PA:AS", @"EU:AD", @"AF:AO", @"SA:AR", @"NS:AM", @"PA:AU", @"EU:AT", @"NS:AZ", @"CA:BS", @"ME:BH", @"SS:BD", @"CA:BB", @"NS:BY", @"EU:BE", @"CA:BZ",
							  @"AF:BJ", @"CA:BM", @"SA:BO", @"EU:BA", @"AF:BW", @"SA:BR", @"EU:BG", @"AF:BF", @"SE:KH", @"AF:CM", @"NA:CA", @"AF:CF", @"SA:CL", @"ES:CN", @"SA:CO", @"AF:CG", @"AF:CD", @"CA:CR", @"EU:HR", @"CA:CU",
							  @"ME:CY", @"EU:CZ", @"AF:CI", @"EU:DK", @"CA:DO", @"SA:EC", @"AF:EG", @"CA:SV", @"EU:EE", @"AF:ET", @"PA:FJ", @"EU:FI", @"EU:YU", @"EU:FR", @"AF:GA", @"AF:GM", @"NS:GE", @"EU:DE", @"AF:GH", @"EU:GR",
							  @"CA:GP", @"CA:GT", @"AF:GN", @"AF:GW", @"CA:HT", @"CA:HN", @"ES:HK", @"EU:HU", @"EU:IS", @"SS:IN", @"SE:ID", @"ME:IR", @"ME:IQ", @"EU:IE", @"ME:IL", @"EU:IT", @"CA:JM", @"ES:JP", @"ME:JO", @"NS:KZ",
							  @"AF:KE", @"ES:KP", @"ES:KR", @"ME:KW", @"NS:KG", @"SE:LA", @"EU:LV", @"ME:LB", @"AF:LR", @"AF:LY", @"EU:LT", @"EU:LU", @"EU:MK", @"AF:MG", @"AF:MW", @"SE:MY", @"AF:ML", @"EU:MT", @"CA:MQ", @"AF:MR",
							  @"AF:MU", @"NA:MX", @"NS:MD", @"EU:MC", @"ES:MN", @"EU:ME", @"AF:MA", @"AF:MZ", @"SE:MM", @"PA:NR", @"SS:NP", @"EU:NL", @"EU:AN", @"PA:NC", @"PA:NZ", @"CA:NI", @"AF:NE", @"AF:NG", @"PA:MP", @"EU:NO",
							  @"ME:OM", @"SS:PK", @"CA:PA", @"PA:PG", @"SA:PY", @"SA:PE", @"SE:PH", @"EU:PL", @"EU:PT", @"CA:PR", @"ME:QA", @"EU:RO", @"NS:RU", @"AF:RW", @"AF:RE", @"CA:KN", @"ME:SA", @"AF:SN", @"EU:RS", @"EU:CS",
							  @"AF:SC", @"AF:SL", @"SE:SG", @"EU:SK", @"EU:SI", @"PA:SB", @"AF:ZA", @"EU:ES", @"SS:LK", @"AF:SD", @"AF:SZ", @"EU:SE", @"EU:CH", @"ME:SY", @"ES:TW", @"AF:TZ", @"SE:TH", @"AF:TG", @"CA:TT", @"AF:TN",
							  @"ME:TR", @"AF:UG", @"NS:UA", @"ME:AE", @"EU:GB", @"NA:US", @"SA:UY", @"SA:VE", @"SE:VN", @"ME:YE", @"AF:ZM", @"AF:ZW",
							  nil], @"values",
							 nil],
							
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"State 2", @"label", @0, @"value", @"state2", @"name",
							  [NSMutableArray arrayWithObjects:@"Optional", @"United States, Alabama", @"United States, Alaska", @"United States, Arizona", @"United States, Arkansas", @"United States, California", @"United States, Colorado", @"United States, Connecticut", @"United States, Delaware", @"United States, District of Columbia", @"United States, Florida", @"United States, Georgia", @"United States, Hawaii", @"United States, Idaho", @"United States, Illinois", @"United States, Indiana",
							   @"United States, Iowa", @"United States, Kansas", @"United States, Kentucky", @"United States, Louisiana", @"United States, Maine", @"United States, Maryland", @"United States, Massachusetts", @"United States, Michigan", @"United States, Minnesota", @"United States, Mississippi", @"United States, Missouri", @"United States, Montana", @"United States, Nebraska", @"United States, Nevada", @"United States, New Hampshire",
							   @"United States, New Jersey", @"United States, New Mexico", @"United States, New York", @"United States, North Carolina", @"United States, North Dakota", @"United States, Ohio", @"United States, Oklahoma", @"United States, Oregon", @"United States, Pennsylvania", @"United States, Rhode Island", @"United States, South Carolina", @"United States, South Dakota", @"United States, Tennessee", @"United States, Texas", @"United States, Utah",
							   @"United States, Vermont", @"United States, Virginia", @"United States, Washington", @"United States, West Virginia", @"United States, Wisconsin", @"United States, Wyoming", @"Canada, Alberta", @"Canada, British Columbia", @"Canada, Manitoba", @"Canada, New Brunswick", @"Canada, Newfoundland and Labrador", @"Canada, Nova Scotia", @"Canada, Ontario", @"Canada, Prince Edward Island", @"Canada, Quebec", 
							   @"Canada, Saskatchewan", @"Australia, Australian Capital Territory", @"Australia, New South Wales", @"Australia, Northern Territory", @"Australia, Queensland", @"Australia, South Australia", @"Australia, Tasmania", @"Australia, Victoria", @"Australia, Western Australia",nil], @"labels",
							  [NSMutableArray arrayWithObjects:@"", @"NA:US:AL", @"NA:US:AK", @"NA:US:AZ", @"NA:US:AR", @"NA:US:CA", @"NA:US:CO", @"NA:US:CT", @"NA:US:DE", @"NA:US:DC", @"NA:US:FL", @"NA:US:GA", @"NA:US:HI", @"NA:US:ID", @"NA:US:IL", @"NA:US:IN",
							   @"NA:US:IA", @"NA:US:KS", @"NA:US:KY", @"NA:US:LA", @"NA:US:ME", @"NA:US:MD", @"NA:US:MA", @"NA:US:MI", @"NA:US:MN", @"NA:US:MS", @"NA:US:MO", @"NA:US:MT", @"NA:US:NE", @"NA:US:NV", @"NA:US:NH",
							   @"NA:US:NJ", @"NA:US:NM", @"NA:US:NY", @"NA:US:NC", @"NA:US:ND", @"NA:US:OH", @"NA:US:OK", @"NA:US:OR", @"NA:US:PA", @"NA:US:RI", @"NA:US:SC", @"NA:US:SD", @"NA:US:TN", @"NA:US:TX", @"NA:US:UT",
							   @"NA:US:VT", @"NA:US:VA", @"NA:US:WA", @"NA:US:WV", @"NA:US:WI", @"NA:US:WY", @"NA:CA:AB", @"NA:CA:BC", @"NA:CA:MB", @"NA:CA:NB", @"NA:CA:NF", @"NA:CA:NS", @"NA:CA:ON", @"NA:CA:PE", @"NA:CA:QC", 
							   @"NA:CA:SK", @"PA:AU:AC", @"PA:AU:SW", @"PA:AU:NT", @"PA:AU:QL", @"PA:AU:SA", @"PA:AU:TA", @"PA:AU:VC", @"PA:AU:WA",nil], @"values",
							  nil],
							
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Country 2", @"label", @0, @"value", @"cntry2", @"name",
							 [NSMutableArray arrayWithObjects:@"Optional", @"United States", @"Afghanistan", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Argentina", @"Armenia", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize",
							  @"Benin", @"Bermuda", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Bulgaria", @"Burkina Faso", @"Cambodia", @"Cameroon", @"Canada", @"Central African Republic", @"Chile", @"China", @"Colombia", @"Congo", @"Congo, The Democratic Republic of the", @"Costa Rica", @"Croatia", @"Cuba",
							  @"Cyprus", @"Czech Republic", @"Côte D'Ivoire", @"Denmark", @"Dominican Republic", @"Ecuador", @"Egypt", @"El Salvador", @"Estonia", @"Ethiopia", @"Fiji", @"Finland", @"Former Yugoslavia", @"France", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Greece",
							  @"Guadeloupe", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Haiti", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran, Islamic Republic of", @"Iraq", @"Ireland", @"Israel", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan",
							  @"Kenya", @"Korea, Democratic People's Republic of", @"Korea, Republic of", @"Kuwait", @"Kyrgyzstan", @"Lao People's Democratic Republic", @"Latvia", @"Lebanon", @"Liberia", @"Libyan Arab Jamahiriya", @"Lithuania", @"Luxembourg", @"Macedonia, The Former Yugoslav Republic of", @"Madagascar", @"Malawi", @"Malaysia", @"Mali", @"Malta", @"Martinique", @"Mauritania",
							  @"Mauritius", @"Mexico", @"Moldova, Republic of", @"Monaco", @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique", @"Myanmar", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Northern Mariana Islands", @"Norway",
							  @"Oman", @"Pakistan", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Romania", @"Russian Federation", @"Rwanda", @"Réunion", @"Saint Kitts and Nevis", @"Saudi Arabia", @"Senegal", @"Serbia", @"Serbia and Montenegro",
							  @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"South Africa", @"Spain", @"Sri Lanka", @"Sudan", @"Swaziland", @"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan", @"Tanzania", @"Thailand", @"Togo", @"Trinidad and Tobago", @"Tunisia",
							  @"Turkey", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Venezuela", @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe",
							  nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"NA:US", @"SS:AF", @"EU:AL", @"AF:DZ", @"PA:AS", @"EU:AD", @"AF:AO", @"SA:AR", @"NS:AM", @"PA:AU", @"EU:AT", @"NS:AZ", @"CA:BS", @"ME:BH", @"SS:BD", @"CA:BB", @"NS:BY", @"EU:BE", @"CA:BZ",
							  @"AF:BJ", @"CA:BM", @"SA:BO", @"EU:BA", @"AF:BW", @"SA:BR", @"EU:BG", @"AF:BF", @"SE:KH", @"AF:CM", @"NA:CA", @"AF:CF", @"SA:CL", @"ES:CN", @"SA:CO", @"AF:CG", @"AF:CD", @"CA:CR", @"EU:HR", @"CA:CU",
							  @"ME:CY", @"EU:CZ", @"AF:CI", @"EU:DK", @"CA:DO", @"SA:EC", @"AF:EG", @"CA:SV", @"EU:EE", @"AF:ET", @"PA:FJ", @"EU:FI", @"EU:YU", @"EU:FR", @"AF:GA", @"AF:GM", @"NS:GE", @"EU:DE", @"AF:GH", @"EU:GR",
							  @"CA:GP", @"CA:GT", @"AF:GN", @"AF:GW", @"CA:HT", @"CA:HN", @"ES:HK", @"EU:HU", @"EU:IS", @"SS:IN", @"SE:ID", @"ME:IR", @"ME:IQ", @"EU:IE", @"ME:IL", @"EU:IT", @"CA:JM", @"ES:JP", @"ME:JO", @"NS:KZ",
							  @"AF:KE", @"ES:KP", @"ES:KR", @"ME:KW", @"NS:KG", @"SE:LA", @"EU:LV", @"ME:LB", @"AF:LR", @"AF:LY", @"EU:LT", @"EU:LU", @"EU:MK", @"AF:MG", @"AF:MW", @"SE:MY", @"AF:ML", @"EU:MT", @"CA:MQ", @"AF:MR",
							  @"AF:MU", @"NA:MX", @"NS:MD", @"EU:MC", @"ES:MN", @"EU:ME", @"AF:MA", @"AF:MZ", @"SE:MM", @"PA:NR", @"SS:NP", @"EU:NL", @"EU:AN", @"PA:NC", @"PA:NZ", @"CA:NI", @"AF:NE", @"AF:NG", @"PA:MP", @"EU:NO",
							  @"ME:OM", @"SS:PK", @"CA:PA", @"PA:PG", @"SA:PY", @"SA:PE", @"SE:PH", @"EU:PL", @"EU:PT", @"CA:PR", @"ME:QA", @"EU:RO", @"NS:RU", @"AF:RW", @"AF:RE", @"CA:KN", @"ME:SA", @"AF:SN", @"EU:RS", @"EU:CS",
							  @"AF:SC", @"AF:SL", @"SE:SG", @"EU:SK", @"EU:SI", @"PA:SB", @"AF:ZA", @"EU:ES", @"SS:LK", @"AF:SD", @"AF:SZ", @"EU:SE", @"EU:CH", @"ME:SY", @"ES:TW", @"AF:TZ", @"SE:TH", @"AF:TG", @"CA:TT", @"AF:TN",
							  @"ME:TR", @"AF:UG", @"NS:UA", @"ME:AE", @"EU:GB", @"NA:US", @"SA:UY", @"SA:VE", @"SE:VN", @"ME:YE", @"AF:ZM", @"AF:ZW",
							  nil], @"values",
							 nil],
							
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"State 3", @"label", @0, @"value", @"state3", @"name",
							  [NSMutableArray arrayWithObjects:@"Optional", @"United States, Alabama", @"United States, Alaska", @"United States, Arizona", @"United States, Arkansas", @"United States, California", @"United States, Colorado", @"United States, Connecticut", @"United States, Delaware", @"United States, District of Columbia", @"United States, Florida", @"United States, Georgia", @"United States, Hawaii", @"United States, Idaho", @"United States, Illinois", @"United States, Indiana",
							   @"United States, Iowa", @"United States, Kansas", @"United States, Kentucky", @"United States, Louisiana", @"United States, Maine", @"United States, Maryland", @"United States, Massachusetts", @"United States, Michigan", @"United States, Minnesota", @"United States, Mississippi", @"United States, Missouri", @"United States, Montana", @"United States, Nebraska", @"United States, Nevada", @"United States, New Hampshire",
							   @"United States, New Jersey", @"United States, New Mexico", @"United States, New York", @"United States, North Carolina", @"United States, North Dakota", @"United States, Ohio", @"United States, Oklahoma", @"United States, Oregon", @"United States, Pennsylvania", @"United States, Rhode Island", @"United States, South Carolina", @"United States, South Dakota", @"United States, Tennessee", @"United States, Texas", @"United States, Utah",
							   @"United States, Vermont", @"United States, Virginia", @"United States, Washington", @"United States, West Virginia", @"United States, Wisconsin", @"United States, Wyoming", @"Canada, Alberta", @"Canada, British Columbia", @"Canada, Manitoba", @"Canada, New Brunswick", @"Canada, Newfoundland and Labrador", @"Canada, Nova Scotia", @"Canada, Ontario", @"Canada, Prince Edward Island", @"Canada, Quebec", 
							   @"Canada, Saskatchewan", @"Australia, Australian Capital Territory", @"Australia, New South Wales", @"Australia, Northern Territory", @"Australia, Queensland", @"Australia, South Australia", @"Australia, Tasmania", @"Australia, Victoria", @"Australia, Western Australia",nil], @"labels",
							  [NSMutableArray arrayWithObjects:@"", @"NA:US:AL", @"NA:US:AK", @"NA:US:AZ", @"NA:US:AR", @"NA:US:CA", @"NA:US:CO", @"NA:US:CT", @"NA:US:DE", @"NA:US:DC", @"NA:US:FL", @"NA:US:GA", @"NA:US:HI", @"NA:US:ID", @"NA:US:IL", @"NA:US:IN",
							   @"NA:US:IA", @"NA:US:KS", @"NA:US:KY", @"NA:US:LA", @"NA:US:ME", @"NA:US:MD", @"NA:US:MA", @"NA:US:MI", @"NA:US:MN", @"NA:US:MS", @"NA:US:MO", @"NA:US:MT", @"NA:US:NE", @"NA:US:NV", @"NA:US:NH",
							   @"NA:US:NJ", @"NA:US:NM", @"NA:US:NY", @"NA:US:NC", @"NA:US:ND", @"NA:US:OH", @"NA:US:OK", @"NA:US:OR", @"NA:US:PA", @"NA:US:RI", @"NA:US:SC", @"NA:US:SD", @"NA:US:TN", @"NA:US:TX", @"NA:US:UT",
							   @"NA:US:VT", @"NA:US:VA", @"NA:US:WA", @"NA:US:WV", @"NA:US:WI", @"NA:US:WY", @"NA:CA:AB", @"NA:CA:BC", @"NA:CA:MB", @"NA:CA:NB", @"NA:CA:NF", @"NA:CA:NS", @"NA:CA:ON", @"NA:CA:PE", @"NA:CA:QC", 
							   @"NA:CA:SK", @"PA:AU:AC", @"PA:AU:SW", @"PA:AU:NT", @"PA:AU:QL", @"PA:AU:SA", @"PA:AU:TA", @"PA:AU:VC", @"PA:AU:WA",nil], @"values",
							  nil],
							
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Country 3", @"label", @0, @"value", @"cntry3", @"name",
							 [NSMutableArray arrayWithObjects:@"Optional", @"United States", @"Afghanistan", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Argentina", @"Armenia", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize",
							  @"Benin", @"Bermuda", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Bulgaria", @"Burkina Faso", @"Cambodia", @"Cameroon", @"Canada", @"Central African Republic", @"Chile", @"China", @"Colombia", @"Congo", @"Congo, The Democratic Republic of the", @"Costa Rica", @"Croatia", @"Cuba",
							  @"Cyprus", @"Czech Republic", @"Côte D'Ivoire", @"Denmark", @"Dominican Republic", @"Ecuador", @"Egypt", @"El Salvador", @"Estonia", @"Ethiopia", @"Fiji", @"Finland", @"Former Yugoslavia", @"France", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Greece",
							  @"Guadeloupe", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Haiti", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran, Islamic Republic of", @"Iraq", @"Ireland", @"Israel", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan",
							  @"Kenya", @"Korea, Democratic People's Republic of", @"Korea, Republic of", @"Kuwait", @"Kyrgyzstan", @"Lao People's Democratic Republic", @"Latvia", @"Lebanon", @"Liberia", @"Libyan Arab Jamahiriya", @"Lithuania", @"Luxembourg", @"Macedonia, The Former Yugoslav Republic of", @"Madagascar", @"Malawi", @"Malaysia", @"Mali", @"Malta", @"Martinique", @"Mauritania",
							  @"Mauritius", @"Mexico", @"Moldova, Republic of", @"Monaco", @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique", @"Myanmar", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Northern Mariana Islands", @"Norway",
							  @"Oman", @"Pakistan", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Romania", @"Russian Federation", @"Rwanda", @"Réunion", @"Saint Kitts and Nevis", @"Saudi Arabia", @"Senegal", @"Serbia", @"Serbia and Montenegro",
							  @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"South Africa", @"Spain", @"Sri Lanka", @"Sudan", @"Swaziland", @"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan", @"Tanzania", @"Thailand", @"Togo", @"Trinidad and Tobago", @"Tunisia",
							  @"Turkey", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Venezuela", @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe",
							  nil], @"labels",
							 [NSMutableArray arrayWithObjects:@"", @"NA:US", @"SS:AF", @"EU:AL", @"AF:DZ", @"PA:AS", @"EU:AD", @"AF:AO", @"SA:AR", @"NS:AM", @"PA:AU", @"EU:AT", @"NS:AZ", @"CA:BS", @"ME:BH", @"SS:BD", @"CA:BB", @"NS:BY", @"EU:BE", @"CA:BZ",
							  @"AF:BJ", @"CA:BM", @"SA:BO", @"EU:BA", @"AF:BW", @"SA:BR", @"EU:BG", @"AF:BF", @"SE:KH", @"AF:CM", @"NA:CA", @"AF:CF", @"SA:CL", @"ES:CN", @"SA:CO", @"AF:CG", @"AF:CD", @"CA:CR", @"EU:HR", @"CA:CU",
							  @"ME:CY", @"EU:CZ", @"AF:CI", @"EU:DK", @"CA:DO", @"SA:EC", @"AF:EG", @"CA:SV", @"EU:EE", @"AF:ET", @"PA:FJ", @"EU:FI", @"EU:YU", @"EU:FR", @"AF:GA", @"AF:GM", @"NS:GE", @"EU:DE", @"AF:GH", @"EU:GR",
							  @"CA:GP", @"CA:GT", @"AF:GN", @"AF:GW", @"CA:HT", @"CA:HN", @"ES:HK", @"EU:HU", @"EU:IS", @"SS:IN", @"SE:ID", @"ME:IR", @"ME:IQ", @"EU:IE", @"ME:IL", @"EU:IT", @"CA:JM", @"ES:JP", @"ME:JO", @"NS:KZ",
							  @"AF:KE", @"ES:KP", @"ES:KR", @"ME:KW", @"NS:KG", @"SE:LA", @"EU:LV", @"ME:LB", @"AF:LR", @"AF:LY", @"EU:LT", @"EU:LU", @"EU:MK", @"AF:MG", @"AF:MW", @"SE:MY", @"AF:ML", @"EU:MT", @"CA:MQ", @"AF:MR",
							  @"AF:MU", @"NA:MX", @"NS:MD", @"EU:MC", @"ES:MN", @"EU:ME", @"AF:MA", @"AF:MZ", @"SE:MM", @"PA:NR", @"SS:NP", @"EU:NL", @"EU:AN", @"PA:NC", @"PA:NZ", @"CA:NI", @"AF:NE", @"AF:NG", @"PA:MP", @"EU:NO",
							  @"ME:OM", @"SS:PK", @"CA:PA", @"PA:PG", @"SA:PY", @"SA:PE", @"SE:PH", @"EU:PL", @"EU:PT", @"CA:PR", @"ME:QA", @"EU:RO", @"NS:RU", @"AF:RW", @"AF:RE", @"CA:KN", @"ME:SA", @"AF:SN", @"EU:RS", @"EU:CS",
							  @"AF:SC", @"AF:SL", @"SE:SG", @"EU:SK", @"EU:SI", @"PA:SB", @"AF:ZA", @"EU:ES", @"SS:LK", @"AF:SD", @"AF:SZ", @"EU:SE", @"EU:CH", @"ME:SY", @"ES:TW", @"AF:TZ", @"SE:TH", @"AF:TG", @"CA:TT", @"AF:TN",
							  @"ME:TR", @"AF:UG", @"NS:UA", @"ME:AE", @"EU:GB", @"NA:US", @"SA:UY", @"SA:VE", @"SE:VN", @"ME:YE", @"AF:ZM", @"AF:ZW",
							  nil], @"values",
							 nil],
							
							[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Location Terms", @"label", @"", @"value", @"locn", @"name", @YES, @"edit",nil],
						
							nil],
							
							[NSMutableArray arrayWithObjects:
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Gender", @"label", @0, @"value", @"gndr", @"name",
							  [NSMutableArray arrayWithObjects:@"All Studies", @"Studies with Female Participants", @"Studies with Male Participants", nil], @"labels", 
							  [NSMutableArray arrayWithObjects:@"", @"Female", @"Male", nil], @"values", 
							  nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Age Group", @"label", @"age", @"name", @YES, @"multi",
							  [NSMutableArray arrayWithObjects:@"Child (birth-17)", @"Adult (18-65)", @"Senior (66+)", nil], @"labels", 
							  [NSMutableArray arrayWithObjects:@NO, @NO, @NO, nil], @"values", 
							  nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Phase", @"label", @"phase", @"name", @YES, @"multi",
							  [NSMutableArray arrayWithObjects:@"Phase I", @"Phase II", @"Phase III", @"Phase IV", nil], @"labels", 
							  [NSMutableArray arrayWithObjects:@NO, @NO, @NO, @NO, nil], @"values", 
							  nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Funded By", @"label", @"fund", @"name", @YES, @"multi",
							  [NSMutableArray arrayWithObjects:@"NIH", @"Other U.S. Federal Agency", @"Industry", @"University/Organization", nil], @"labels", 
							  [NSMutableArray arrayWithObjects:@NO, @NO, @NO, @NO, nil], @"values", 
							  nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Outcome safety issue", @"label", @0, @"value", @"safe", @"name",
							  [NSMutableArray arrayWithObjects:@"No", @"Yes", nil], @"labels",
							  [NSMutableArray arrayWithObjects:@"No", @"Yes", nil], @"values",
							  nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"First Received", @"label", [NSMutableArray arrayWithObjects:@"",@"", nil], @"values", [NSMutableArray arrayWithObjects:@"rcv_s",@"rcv_e", nil], @"name", @YES, @"dateRange",nil],
							 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Last Updated", @"label", [NSMutableArray arrayWithObjects:@"",@"", nil], @"values", [NSMutableArray arrayWithObjects:@"lup_s",@"lup_e", nil], @"name", @YES, @"dateRange",nil],

							 nil],
							
							nil];
		
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self hidePicker:NO];
	
	myTable.hidden = NO;
	self.navigationItem.rightBarButtonItem = searchButton;
    
    // Make sure the pickers are subviews of our main view
    [self.view addSubview:masterPickerContainer];
    [self.view addSubview:datePickerContainer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textCellChanged:) name:@"ADVANCED_EDIT_CELL_CHANGED" object:nil];
	
} // viewDidLoad

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Advanced Search Open"];
#endif
}

- (NSMutableDictionary*) locateParameterWithName:(NSString*)name
{
	for(NSMutableArray* arrays in tableCellContent)
	{
		for(NSMutableDictionary*d in arrays)
		{
			NS_DURING
			id	xName = d[@"name"];
			if([xName isKindOfClass:[NSString class]])
			{
				NSString*	sName = (NSString*) xName;
				if([sName isEqualToString:name])
					return d;
			}
			else if([xName isKindOfClass:[NSArray class]])
			{
				for(NSString* sName in xName)
				{
					if([sName isEqualToString:name])
						return d;
				} // for
			} // else
			NS_HANDLER
			NSLog(@"%@", d);
			NS_ENDHANDLER
		}
	} // for arrays
	
	return nil;
} // locateParameterWithName

- (NSNumber*) findParameter:(NSMutableDictionary*)dict forValue:(NSString*)value
{
	NSArray*	a = dict[@"values"];
	if(a == nil)
		return nil;
	int i;
	for(i=0;i<[a count];i++)
	{
		if([value isEqualToString:a[i]])
			return @(i);
	}
	return @0;
} // findParameter:forValue

- (void) mapSearchURLtoRefinedSearch:(NSString*)oldURL
{
	NSRange		r = [oldURL rangeOfString:@"?"];
	NSString*	uri;
	if(r.location != NSNotFound)
		uri = [oldURL substringFromIndex:r.location+1];
	else
		uri = oldURL;

	NSArray*	urlParts = [uri componentsSeparatedByString:@"&"];
	for(NSString*part in urlParts)
	{
		NSArray*	paramParts = [part componentsSeparatedByString:@"="];
		if([paramParts count] < 2)
			continue;
		
		NSString*	param = paramParts[0];
		NSString*	newValue = paramParts[1];
		if([param isEqualToString:@"displayxml"])
			continue;
		
		NSMutableDictionary*	d = [self locateParameterWithName:param];
		if(d == nil)
			continue;
		BOOL			isMulti = [d[@"multi"] boolValue];
		BOOL			isDateRange = [d[@"dateRange"] boolValue];
		NSMutableArray*	values = d[@"values"];
//		id			value = [d objectForKey:@"value"];
		if(isMulti)
		{
			if(values)
			{
				int index = [newValue intValue];
				values[index] = @YES;
			}
			else
				d[@"value"] = [self findParameter:d forValue:newValue];
		} // multi
		else if(isDateRange)
		{
			NSArray*	names = d[@"name"];
			int			i;
			for(i=0;i<[names count];i++)
			{
				if([names[i] isEqualToString:param])
				{
					values[i] = newValue;
					break;
				}
			} // for i
		}
		else
		{
			if(values)
			{
				d[@"value"] = [self findParameter:d forValue:newValue];
			}
			else
			{
				d[@"value"] = newValue;
			}
				
		} // not multi
	} //  for urlparts
} // mapSearchURLtoRefinedSearch


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
} // viewDidUnload


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	busyEditing = YES;
	activeTextField = textField;
	activeTextField.borderStyle = UITextBorderStyleBezel;

	AdvancedCell*	cell = (AdvancedCell*) textField.superview;
	NSIndexPath*	tableIndex = cell.tableIndex;
	[myTable scrollToRowAtIndexPath:tableIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
	myTable.scrollEnabled = NO;
	searchButton.enabled = NO;
} // textFieldDidBeginEditing

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	shouldSearch = YES;
	activeTextField.borderStyle = UITextBorderStyleNone;
	[theTextField resignFirstResponder];
	
	activeTextField = nil;
	return YES;
} // textFieldShouldReturn

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	busyEditing = NO;
	searchButton.enabled = YES;
	myTable.scrollEnabled = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ADVANCED_EDIT_CELL_CHANGED" object:activeTextField];
} // textFieldDidEndEditing

- (IBAction) cancelEnditing:(id)sender
{
	activeTextField.borderStyle = UITextBorderStyleNone;
	[activeTextField resignFirstResponder];
	activeTextField = nil;
	shouldSearch = NO;
	busyEditing = NO;
	searchButton.enabled = YES;
} // cancelEnditing

- (IBAction) doSearch:(id)sender
{
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"doAdvancedSearch"];
#endif
	NSArray*	searchTerms = @[];
	for(NSArray*section in tableCellContent)
	{
		for(NSDictionary*info in section)
		{
			id			value  = info[@"value"];
			NSArray*	labels = info[@"labels"];
			NSArray*	values = info[@"values"];
			NSString*	name   = info[@"name"];
			if(labels)
			{
				if(![info[@"multi"] boolValue])
				{
					searchTerms = [searchTerms arrayByAddingObject:
								   [NSString stringWithFormat:@"%@=%@", name,values[[value intValue]]]];
				}
				else
				{
					int			i;
					for(i=0; i<[values count]; i++)
					{
						if([values[i] intValue])
							searchTerms = [searchTerms arrayByAddingObject:
										   [NSString stringWithFormat:@"%@=%d", name, i]];
					}
				}
			} // labels
			else if([info[@"dateRange"] boolValue])
			{
				NSArray*	nameArray = (NSArray*) name;
				searchTerms = [searchTerms arrayByAddingObject:
							   [NSString stringWithFormat:@"%@=%@", nameArray[0], values[0]]];
				searchTerms = [searchTerms arrayByAddingObject:
							   [NSString stringWithFormat:@"%@=%@", nameArray[1], values[1]]];
			} // dateRange
			else 
			{
				value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				searchTerms = [searchTerms arrayByAddingObject:
							   [NSString stringWithFormat:@"%@=%@", name, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
			}
		} // for info
	} // for section
	
	NSString*	term = [searchTerms componentsJoinedByString:@"&"];
#ifdef __DEBUG_OUTPUT__	
	NSLog(term);
#endif
	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	controller.searchTerms = term;
	controller.advancedSearchFields = tableCellContent;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller searchAddingToHistory:YES];
	
} // doSearch

- (void) textCellChanged:(NSNotification*)notifcation
{
	UITextField*	theField = [notifcation object];
	AdvancedCell*	cell = (AdvancedCell*) theField.superview;
	NSString*		key = (cell.info)[@"name"];
	NSString*		newCellText = theField.text;
	NSIndexPath*	tableIndex = cell.tableIndex;
	
#ifdef __DEBUG_OUTPUT__
	NSLog(@"Cell (%@) changed: %@", key, newCellText);
#endif
	NSMutableDictionary*	targetField = tableCellContent[tableIndex.section - 1][tableIndex.row];
	targetField[@"value"] = newCellText;
} // textCellChanged

- (IBAction) cancelPicker:(id)sender
{
	[self hidePicker:YES];
} // cancelPicker

- (IBAction) setPicker:(id)sender
{
	int index = [masterPicker selectedRowInComponent:0];
	pickerDict[@"value"] = @(index);
	[myTable reloadData];
	[self hidePicker:YES];
} // setPicker

- (void)showPicker:(BOOL)animated
{
	CGRect	r = masterPickerContainer.frame;
	r.origin.y = 0;
	if(animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		masterPickerContainer.frame = r;
		[UIView commitAnimations];
	}
	else
	{
		masterPickerContainer.frame = r;
	}
	searchButton.enabled = NO;

} // showPicker

- (void) hidePicker:(BOOL)animated
{
	CGRect	r = masterPickerContainer.frame;
	r.origin.y = [UIScreen mainScreen].bounds.size.height;
	if(animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		masterPickerContainer.frame = r;
		[UIView commitAnimations];
	}
	else
	{
		masterPickerContainer.frame = r;
	}
	searchButton.enabled = YES;
} // hidePicker

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [tableCellContent count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
		return 1;
	
	return [tableCellContent[section - 1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return tableHeaders[section];
} // titleForHeaderInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
	{
		NSString *CellIdentifier = @"HistoryCell";
		UITableViewCell *cell;
		cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		if([searchHistory count])
			cell.textLabel.text = @"History";
		else
			cell.textLabel.text = @"No History";
			
		return cell;
	}
	
    
    NSString *CellIdentifier = @"AdvancedCell";
	AdvancedCell *cell;
	cell = (AdvancedCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[AdvancedCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.contentEdit.delegate = self;
	}
	
	cell.info = tableCellContent[indexPath.section - 1][indexPath.row];
	if((cell.info)[@"multi"])
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
    
     
	cell.tableIndex = indexPath;
	
	return cell;
} // cellForRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if(busyEditing)
		return;
	
	if(indexPath.section == 0)
	{
		if([searchHistory count])
			[self doHistory:self];
		return;
	}
	
	NSMutableDictionary*	d = tableCellContent[indexPath.section - 1][indexPath.row];
	NSArray*				labels = d[@"labels"];
	BOOL					multi = [d[@"multi"] boolValue];

	if(labels && [labels count])
	{
		pickerDict = d;
		pickerItems = labels;
		if(multi)
		{
			NSMutableArray*	values = d[@"values"];
			WhateverListController*	nc = [[WhateverListController alloc] initWithTitle:d[@"label"]
														  list:labels
														   key:nil
											  initialSelections:values
														sender:self];
			[self.navigationController pushViewController:nc animated:YES];
		}
		else
		{
			int index = [d[@"value"] intValue];
			[masterPicker reloadAllComponents];
			[masterPicker selectRow:index inComponent:0 animated:YES];
			[self showPicker:YES];
		}
	}
	else if([d[@"dateRange"] boolValue])
	{
		dateRangeHandler.dates = d;
		dateRangeHandler.whichtype = indexPath.row; // So much hardcoding...
		[dateRangeHandler showDatePicker:YES];
	}
	else
	{
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		for(UIView* x in [cell subviews])
		{
			if([x isKindOfClass:[UITextField class]])
			{
				[x becomeFirstResponder];
				break;
			}
		}
	}
	
} // didSelectRowAtIndexPath

-(void) changeSelection:(NSArray*)newSelection forHeading:(NSString*)heading
{
	pickerDict[@"values"] = newSelection;
	[myTable reloadData];
} // changeSelection

#pragma mark Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
} // numberOfComponentsInPickerView

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerItems count];
} // numberOfRowsInComponent

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return pickerItems[row];
} // titleForRow

@end
