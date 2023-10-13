//
//  WorldCountries.m
//  ClinicalTrials
//
//  Created by Matthew Mashyna on 11/28/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "WorldCountries.h"
#import "ResultsViewController.h"


@implementation WorldCountries
@synthesize region;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	NSArray* worldLabels = @[@"Afghanistan", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Argentina", @"Armenia", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize",
							@"Benin", @"Bermuda", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Bulgaria", @"Burkina Faso", @"Cambodia", @"Cameroon", @"Canada", @"Central African Republic", @"Chile", @"China", @"Colombia", @"Congo", @"Congo, The Democratic Republic of the", @"Costa Rica", @"Croatia", @"Cuba",
							@"Cyprus", @"Czech Republic", @"Côte D'Ivoire", @"Denmark", @"Dominican Republic", @"Ecuador", @"Egypt", @"El Salvador", @"Estonia", @"Ethiopia", @"Fiji", @"Finland", @"Former Yugoslavia", @"France", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Greece",
							@"Guadeloupe", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Haiti", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran, Islamic Republic of", @"Iraq", @"Ireland", @"Israel", @"Italy", @"Jamaica", @"Japan", @"Jordan", @"Kazakhstan",
							@"Kenya", @"Korea, Democratic People's Republic of", @"Korea, Republic of", @"Kuwait", @"Kyrgyzstan", @"Lao People's Democratic Republic", @"Latvia", @"Lebanon", @"Liberia", @"Libyan Arab Jamahiriya", @"Lithuania", @"Luxembourg", @"Macedonia, The Former Yugoslav Republic of", @"Madagascar", @"Malawi", @"Malaysia", @"Mali", @"Malta", @"Martinique", @"Mauritania",
							@"Mauritius", @"Mexico", @"Moldova, Republic of", @"Monaco", @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique", @"Myanmar", @"Nauru", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Northern Mariana Islands", @"Norway",
							@"Oman", @"Pakistan", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Romania", @"Russian Federation", @"Rwanda", @"Réunion", @"Saint Kitts and Nevis", @"Saudi Arabia", @"Senegal", @"Serbia", @"Serbia and Montenegro",
							@"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"South Africa", @"Spain", @"Sri Lanka", @"Sudan", @"Swaziland", @"Sweden", @"Switzerland", @"Syrian Arab Republic", @"Taiwan", @"Tanzania", @"Thailand", @"Togo", @"Trinidad and Tobago", @"Tunisia",
							@"Turkey", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Venezuela", @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe"];
	
	NSArray* worldCodes = @[@"SS:AF", @"EU:AL", @"AF:DZ", @"PA:AS", @"EU:AD", @"AF:AO", @"SA:AR", @"NS:AM", @"PA:AU", @"EU:AT", @"NS:AZ", @"CA:BS", @"ME:BH", @"SS:BD", @"CA:BB", @"NS:BY", @"EU:BE", @"CA:BZ",
						   @"AF:BJ", @"CA:BM", @"SA:BO", @"EU:BA", @"AF:BW", @"SA:BR", @"EU:BG", @"AF:BF", @"SE:KH", @"AF:CM", @"NA:CA", @"AF:CF", @"SA:CL", @"ES:CN", @"SA:CO", @"AF:CG", @"AF:CD", @"CA:CR", @"EU:HR", @"CA:CU",
						   @"ME:CY", @"EU:CZ", @"AF:CI", @"EU:DK", @"CA:DO", @"SA:EC", @"AF:EG", @"CA:SV", @"EU:EE", @"AF:ET", @"PA:FJ", @"EU:FI", @"EU:YU", @"EU:FR", @"AF:GA", @"AF:GM", @"NS:GE", @"EU:DE", @"AF:GH", @"EU:GR",
						   @"CA:GP", @"CA:GT", @"AF:GN", @"AF:GW", @"CA:HT", @"CA:HN", @"ES:HK", @"EU:HU", @"EU:IS", @"SS:IN", @"SE:ID", @"ME:IR", @"ME:IQ", @"EU:IE", @"ME:IL", @"EU:IT", @"CA:JM", @"ES:JP", @"ME:JO", @"NS:KZ",
						   @"AF:KE", @"ES:KP", @"ES:KR", @"ME:KW", @"NS:KG", @"SE:LA", @"EU:LV", @"ME:LB", @"AF:LR", @"AF:LY", @"EU:LT", @"EU:LU", @"EU:MK", @"AF:MG", @"AF:MW", @"SE:MY", @"AF:ML", @"EU:MT", @"CA:MQ", @"AF:MR",
						   @"AF:MU", @"NA:MX", @"NS:MD", @"EU:MC", @"ES:MN", @"EU:ME", @"AF:MA", @"AF:MZ", @"SE:MM", @"PA:NR", @"SS:NP", @"EU:NL", @"EU:AN", @"PA:NC", @"PA:NZ", @"CA:NI", @"AF:NE", @"AF:NG", @"PA:MP", @"EU:NO",
						   @"ME:OM", @"SS:PK", @"CA:PA", @"PA:PG", @"SA:PY", @"SA:PE", @"SE:PH", @"EU:PL", @"EU:PT", @"CA:PR", @"ME:QA", @"EU:RO", @"NS:RU", @"AF:RW", @"AF:RE", @"CA:KN", @"ME:SA", @"AF:SN", @"EU:RS", @"EU:CS",
						   @"AF:SC", @"AF:SL", @"SE:SG", @"EU:SK", @"EU:SI", @"PA:SB", @"AF:ZA", @"EU:ES", @"SS:LK", @"AF:SD", @"AF:SZ", @"EU:SE", @"EU:CH", @"ME:SY", @"ES:TW", @"AF:TZ", @"SE:TH", @"AF:TG", @"CA:TT", @"AF:TN",
						   @"ME:TR", @"AF:UG", @"NS:UA", @"ME:AE", @"EU:GB", @"NA:US", @"SA:UY", @"SA:VE", @"SE:VN", @"ME:YE", @"AF:ZM", @"AF:ZW"];
#if 0	
	NSArray* naLabels = [NSArray arrayWithObjects:@"United States, Alabama", @"United States, Alaska", @"United States, Arizona", @"United States, Arkansas", @"United States, California", @"United States, Colorado", @"United States, Connecticut", @"United States, Delaware", @"United States, District of Columbia", @"United States, Florida", @"United States, Georgia", @"United States, Hawaii", @"United States, Idaho", @"United States, Illinois", @"United States, Indiana",
						 @"United States, Iowa", @"United States, Kansas", @"United States, Kentucky", @"United States, Louisiana", @"United States, Maine", @"United States, Maryland", @"United States, Massachusetts", @"United States, Michigan", @"United States, Minnesota", @"United States, Mississippi", @"United States, Missouri", @"United States, Montana", @"United States, Nebraska", @"United States, Nevada", @"United States, New Hampshire",
						 @"United States, New Jersey", @"United States, New Mexico", @"United States, New York", @"United States, North Carolina", @"United States, North Dakota", @"United States, Ohio", @"United States, Oklahoma", @"United States, Oregon", @"United States, Pennsylvania", @"United States, Rhode Island", @"United States, South Carolina", @"United States, South Dakota", @"United States, Tennessee", @"United States, Texas", @"United States, Utah",
						 @"United States, Vermont", @"United States, Virginia", @"United States, Washington", @"United States, West Virginia", @"United States, Wisconsin", @"United States, Wyoming", @"Canada, Alberta", @"Canada, British Columbia", @"Canada, Manitoba", @"Canada, New Brunswick", @"Canada, Newfoundland and Labrador", @"Canada, Nova Scotia", @"Canada, Ontario", @"Canada, Prince Edward Island", @"Canada, Quebec", 
						 @"Canada, Saskatchewan", nil];
	
	NSArray* naCodes  = [NSArray arrayWithObjects:@"NA:US:AL", @"NA:US:AK", @"NA:US:AZ", @"NA:US:AR", @"NA:US:CA", @"NA:US:CO", @"NA:US:CT", @"NA:US:DE", @"NA:US:DC", @"NA:US:FL", @"NA:US:GA", @"NA:US:HI", @"NA:US:ID", @"NA:US:IL", @"NA:US:IN",
						 @"NA:US:IA", @"NA:US:KS", @"NA:US:KY", @"NA:US:LA", @"NA:US:ME", @"NA:US:MD", @"NA:US:MA", @"NA:US:MI", @"NA:US:MN", @"NA:US:MS", @"NA:US:MO", @"NA:US:MT", @"NA:US:NE", @"NA:US:NV", @"NA:US:NH",
						 @"NA:US:NJ", @"NA:US:NM", @"NA:US:NY", @"NA:US:NC", @"NA:US:ND", @"NA:US:OH", @"NA:US:OK", @"NA:US:OR", @"NA:US:PA", @"NA:US:RI", @"NA:US:SC", @"NA:US:SD", @"NA:US:TN", @"NA:US:TX", @"NA:US:UT",
						 @"NA:US:VT", @"NA:US:VA", @"NA:US:WA", @"NA:US:WV", @"NA:US:WI", @"NA:US:WY", @"NA:CA:AB", @"NA:CA:BC", @"NA:CA:MB", @"NA:CA:NB", @"NA:CA:NF", @"NA:CA:NS", @"NA:CA:ON", @"NA:CA:PE", @"NA:CA:QC", 
						 @"NA:CA:SK", nil];	
	
	
	NSArray* australiaLabels = [NSArray arrayWithObjects:@"Australia, Australian Capital Territory", @"Australia, New South Wales", @"Australia, Northern Territory", @"Australia, Queensland", @"Australia, South Australia", @"Australia, Tasmania", @"Australia, Victoria", @"Australia, Western Australia", nil];
	
	NSArray* australiaCodes = [NSArray arrayWithObjects:@"PA:AU:AC", @"PA:AU:SW", @"PA:AU:NT", @"PA:AU:QL", @"PA:AU:SA", @"PA:AU:TA", @"PA:AU:VC", @"PA:AU:WA", nil];
#else
	NSArray* usaLabels = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana",
						 @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire",
						 @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah",
						 @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
	
	NSArray* usaCodes  = @[@"NA:US:AL", @"NA:US:AK", @"NA:US:AZ", @"NA:US:AR", @"NA:US:CA", @"NA:US:CO", @"NA:US:CT", @"NA:US:DE", @"NA:US:DC", @"NA:US:FL", @"NA:US:GA", @"NA:US:HI", @"NA:US:ID", @"NA:US:IL", @"NA:US:IN",
						 @"NA:US:IA", @"NA:US:KS", @"NA:US:KY", @"NA:US:LA", @"NA:US:ME", @"NA:US:MD", @"NA:US:MA", @"NA:US:MI", @"NA:US:MN", @"NA:US:MS", @"NA:US:MO", @"NA:US:MT", @"NA:US:NE", @"NA:US:NV", @"NA:US:NH",
						 @"NA:US:NJ", @"NA:US:NM", @"NA:US:NY", @"NA:US:NC", @"NA:US:ND", @"NA:US:OH", @"NA:US:OK", @"NA:US:OR", @"NA:US:PA", @"NA:US:RI", @"NA:US:SC", @"NA:US:SD", @"NA:US:TN", @"NA:US:TX", @"NA:US:UT",
						 @"NA:US:VT", @"NA:US:VA", @"NA:US:WA", @"NA:US:WV", @"NA:US:WI", @"NA:US:WY"];	
	
	NSArray* cdnLabels = @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick", @"Newfoundland and Labrador", 
						  @"Nova Scotia", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan"];
	
	NSArray* cdnCodes = @[@"NA:CA:AB", @"NA:CA:BC", @"NA:CA:MB", @"NA:CA:NB", @"NA:CA:NF", @"NA:CA:NS", @"NA:CA:ON", @"NA:CA:PE", @"NA:CA:QC", @"NA:CA:SK"];
	
	NSArray* australiaLabels = @[@"Australian Capital Territory", @"New South Wales", @"Northern Territory", @"Queensland", @"South Australia", @"Tasmania", @"Victoria", @"Western Australia"];
	
	NSArray* australiaCodes = @[@"PA:AU:AC", @"PA:AU:SW", @"PA:AU:NT", @"PA:AU:QL", @"PA:AU:SA", @"PA:AU:TA", @"PA:AU:VC", @"PA:AU:WA"];
#endif
	
	
	NSArray*	labels = nil;
	NSArray*	codes = nil;
	
	switch (region) {
#if 0
		case kNorthAmerica:
			labels = naLabels;
			codes = naCodes;
			self.navigationItem.title = @"Select State";
			break;
			
#else
		case kAmerica:
			labels = usaLabels;
			codes = usaCodes;
			self.navigationItem.title = @"Select State";
			break;
			
		case kCanada:
			labels = cdnLabels;
			codes = cdnCodes;
			self.navigationItem.title = @"Select Province";
			break;
			
#endif
		case kAustralia:
			labels = australiaLabels;
			codes = australiaCodes;
			self.navigationItem.title = @"Select State";
			break;
			
		default:
			labels = worldLabels;
			codes = worldCodes;
			self.navigationItem.title = @"Select Country";
			break;
	}
	
	NSString*	lastInitial = [labels[0] substringToIndex:1];
	NSArray*	tempList = @[];
	masterList = @[];
	indexArray = @[[labels[0] substringToIndex:1]];
	
	int i;

	for(i=0;i<[labels count];i++)
	{
		NSString*	name = labels[i];
		NSString*	value = codes[i];
		NSString*	initial = [name substringToIndex:1];
		if(![lastInitial isEqualToString:initial])
		{
			indexArray = [indexArray arrayByAddingObject:initial];
			if([tempList count])
			{
				masterList = [masterList arrayByAddingObject:tempList];
				tempList = @[];
			}
			lastInitial  = initial;
		}
		tempList = [tempList arrayByAddingObject:@{@"name": name, @"value": value}];
		
	}
	if(![tempList isEqualToArray:[masterList lastObject]])
		masterList = [masterList arrayByAddingObject:tempList];
	
}

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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [indexArray count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [masterList[section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WorldCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
	
    // Set up the cell...
	cell.textLabel.text = masterList[indexPath.section][indexPath.row][@"name"];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if([indexArray count] == 1)
		return nil;
	
	return indexArray[section];
		
} // titleForHeaderInSection

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if([indexArray count] == 1)
		return nil;
	
	return indexArray;
} // sectionIndexTitlesForTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString*	location = masterList[indexPath.section][indexPath.row][@"name"];
	if([location isEqualToString:@"United States"])
	{
		WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
		controller.region = kAmerica;
		[self.navigationController pushViewController:controller animated:YES];
		return;
	}
	else if([location isEqualToString:@"Canada"])
	{
		WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
		controller.region = kCanada;
		[self.navigationController pushViewController:controller animated:YES];
		return;
	}
	else if([location isEqualToString:@"Australia"])
	{
		WorldCountries	*controller = [[WorldCountries alloc] initWithNibName:@"WorldCountries" bundle:nil];
		controller.region = kAustralia;
		[self.navigationController pushViewController:controller animated:YES];
		return;
	}
	
	   
	ResultsViewController	*controller = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	if(region)
		controller.searchTerms = [NSString stringWithFormat:@"state1=%@",masterList[indexPath.section][indexPath.row][@"value"]];
	else
		controller.searchTerms = [NSString stringWithFormat:@"cntry1=%@",masterList[indexPath.section][indexPath.row][@"value"]];
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller searchAddingToHistory:YES];
}

@end
