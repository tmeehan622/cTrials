//
//  QueryAgent.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 6/22/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "QueryAgent.h"

#define USE_DELEGATE 1
@implementation QueryAgent

@synthesize retstart, retmax, delegate, resultDict, parseStack, currentElementValue, currentAttributes;


+(NSString*)esearchURL
{
	NSString*	finalString = @"http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=%@&term=%@&datetype=edat&retstart=%d&retmax=%d&usehistory=y";

	NSUserDefaults*	ud = [NSUserDefaults standardUserDefaults];
	if([ud boolForKey:@"proxyOnOff"])
	{
		NSString*	ezProxyURL = [ud stringForKey:@"ezProxyURL"];
		if(ezProxyURL && [ezProxyURL length])
			finalString = [NSString stringWithFormat:@"%@%@", ezProxyURL, finalString];
	}
	
	return finalString;
} // esearchURL

+(NSString*)efetchURL
{
	NSString*	finalString = @"http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=%@&id=%@&retmode=xml";
	
	NSUserDefaults*	ud = [NSUserDefaults standardUserDefaults];
	if([ud boolForKey:@"proxyOnOff"])
	{
		NSString*	ezProxyURL = [ud stringForKey:@"ezProxyURL"];
		if(ezProxyURL && [ezProxyURL length])
			finalString = [NSString stringWithFormat:@"%@%@", ezProxyURL, finalString];
	}
	
	return finalString;
} // efetchURL

+(NSString*)eLinkURL
{
	NSString*	finalString = @"http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=%@&db=%@&id=%@&retmode=xml";
	
	NSUserDefaults*	ud = [NSUserDefaults standardUserDefaults];
	if([ud boolForKey:@"proxyOnOff"])
	{
		NSString*	ezProxyURL = [ud stringForKey:@"ezProxyURL"];
		if(ezProxyURL && [ezProxyURL length])
			finalString = [NSString stringWithFormat:@"%@%@", ezProxyURL, finalString];
	}
	
	return finalString;
} // efetchURL

-(instancetype)initForDB:(NSString*)db 
{
	if(self = [super init])
	{
		retstart = 0;
		int	index = [[NSUserDefaults standardUserDefaults] integerForKey:@"itemsPerPage"];
		switch (index) {
			case 0:
				retmax = 10;
				break;
			case 1:
				retmax = 25;
				break;
			case 2:
				retmax = 50;
				break;
			case 3:
				retmax = 75;
				break;
			case 4:
				retmax = 100;
				break;
			default:
				retmax = 25;
				break;
		}
		self.delegate = nil;
		self.resultDict = nil;
		self.parseStack = [NSMutableArray array];
		dbName = [db copy];
	}
	
	return self;
	
} // init

 // dealloc

-(void) searchFor:(NSString*)term usingDelegate:(id)aDelegate
{
	self.delegate = aDelegate;
	searchTimer = [NSTimer scheduledTimerWithTimeInterval:60
												   target:self
												 selector:@selector(searchTimeout:)
												 userInfo:nil
												  repeats:NO];
	
	
	[NSThread detachNewThreadSelector:@selector(searchThread:)
							 toTarget:self
						   withObject:[term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
} // searchFor

-(void) searchThread:(NSString*)searchString
{
	@autoreleasepool {

		NSString*	urlString = [NSString stringWithFormat:[QueryAgent esearchURL], dbName, searchString, retstart, retmax];
#ifdef __DEBUG_OUTPUT__
#if 1
		NSLog(urlString);
#endif
#endif
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
			
		// Get ready for the response
		NSData *theData;
		NSURLResponse *response;
		NSError *error;
		
		// Make the request
		theData = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
		
		if(![searchTimer isValid])
		{
			self.delegate = nil;
			
			return;
		}

		[searchTimer invalidate];	// cancel the timer

		// parse the data
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData: theData];
#ifdef __DEBUG_OUTPUT__
#if 0
		NSString*	foo = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
		NSLog([foo autorelease]);
#endif
#endif
		[parser setDelegate: self];
		[parser setShouldProcessNamespaces: NO];
		[parser setShouldReportNamespacePrefixes: NO];
		[parser setShouldResolveExternalEntities: NO];
		[parser parse];
		
		NSString*	key = [resultDict allKeys][0];
#ifdef __DEBUG_OUTPUT__
		NSLog(@"The key is %@", key);
#endif
		
		if(delegate && [delegate respondsToSelector:@selector(_getSearchResults:)])
			[delegate performSelectorOnMainThread:@selector(_getSearchResults:) withObject:resultDict waitUntilDone:NO];
		self.delegate = nil;
	
	}
} // searchThread

-(void) searchTimeout:(NSTimer*)timer
{
	// send the error to the delegate
#if USE_DELEGATE
	if(delegate && [delegate respondsToSelector:@selector(parserTimeout)])
		[delegate parserTimeout];
#else
	[[NSNotificationCenter defaultCenter] postNotification:
	 [NSNotification notificationWithName:@"QUERY_ERROR" object:self userInfo:resultDict]];
#endif
	
	searchTimer = nil;
} // searchTimeout

-(void) fetchIDs:(NSArray*)pubIDs usingDelegate:(id)aDelegate
{
	self.delegate = aDelegate;
	searchTimer = [NSTimer scheduledTimerWithTimeInterval:60
												   target:self
												 selector:@selector(searchTimeout:)
												 userInfo:nil
												  repeats:NO];
	
	
	[NSThread detachNewThreadSelector:@selector(fetchThread:)
							 toTarget:self
						   withObject:[pubIDs componentsJoinedByString:@","]];
} // fetchIDs

-(void) fetchThread:(NSString*)fetchString
{
	@autoreleasepool {
	
		NSString*	urlString = [NSString stringWithFormat:[QueryAgent efetchURL], dbName, fetchString];
#ifdef __DEBUG_OUTPUT__
#if 1
		NSLog(urlString);
#endif
#endif
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		
		// Get ready for the response
		NSData *theData;
		NSURLResponse *response;
		NSError *error;
		
		// Make the request
		theData = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
		
		if(![searchTimer isValid])
		{
			self.delegate = nil;
			
			return;
		}
		
		[searchTimer invalidate];	// cancel the timer
		
		// parse the data
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData: theData];
#ifdef __DEBUG_OUTPUT__
#if 0
		NSString*	foo = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
		NSLog([foo autorelease]);
#endif
#endif
		[parser setDelegate: self];
		[parser setShouldProcessNamespaces: NO];
		[parser setShouldReportNamespacePrefixes: NO];
		[parser setShouldResolveExternalEntities: NO];
		[parser parse];
			
#if USE_DELEGATE
		if(delegate && [delegate respondsToSelector:@selector(_getFetchResults:)])
			[delegate performSelectorOnMainThread:@selector(_getFetchResults:) withObject:resultDict waitUntilDone:NO];
#else
		[[NSNotificationCenter defaultCenter] postNotification:
		 [NSNotification notificationWithName:@"PUBMED_FETCH_COMPLETE" object:self userInfo:resultDict]];
#endif
		
		self.delegate = nil;
	
	}
} // fetchThread


-(void) fetchRelated:(NSArray*)pubIDs usingDelegate:(id)aDelegate
{
	self.delegate = aDelegate;
	searchTimer = [NSTimer scheduledTimerWithTimeInterval:60
													target:self
												  selector:@selector(searchTimeout:)
												  userInfo:nil
												   repeats:NO];
	
	
	[NSThread detachNewThreadSelector:@selector(relatedThread:)
							 toTarget:self
						   withObject:[pubIDs componentsJoinedByString:@","]];
} // fetchRelated

-(void) relatedThread:(NSString*)fetchString
{
	@autoreleasepool {
	
		NSString*	urlString = [NSString stringWithFormat:[QueryAgent eLinkURL], dbName, dbName, fetchString];
#ifdef __DEBUG_OUTPUT__
#if 1
		NSLog(urlString);
#endif
#endif
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		
		// Get ready for the response
		NSData *theData;
		NSURLResponse *response;
		NSError *error;
		
		// Make the request
		theData = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
		
		if(![searchTimer isValid])
		{
			self.delegate = nil;
			
			return;
		}
		
		[searchTimer invalidate];	// cancel the timer
		
		// parse the data
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData: theData];
#ifdef __DEBUG_OUTPUT__
#if 0
		NSString*	foo = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
		NSLog([foo autorelease]);
#endif
#endif
		[parser setDelegate: self];
		[parser setShouldProcessNamespaces: NO];
		[parser setShouldReportNamespacePrefixes: NO];
		[parser setShouldResolveExternalEntities: NO];
		[parser parse];
			
#if USE_DELEGATE
		if(delegate && [delegate respondsToSelector:@selector(_getRelatedResults:)])
			[delegate performSelectorOnMainThread:@selector(_getRelatedResults:) withObject:resultDict waitUntilDone:NO];
#else
		[[NSNotificationCenter defaultCenter] postNotification:
		 [NSNotification notificationWithName:@"PUBMED_RELATED_COMPLETE" object:self userInfo:resultDict]];
#endif
		self.delegate = nil;
	
	}
} // relatedThread


- (void) getFullTextFor:(NSString*)pmid usingDelegate:(id)aDelegate
{
	self.delegate = aDelegate;
	searchTimer = [NSTimer scheduledTimerWithTimeInterval:60
												   target:self
												 selector:@selector(searchTimeout:)
												 userInfo:nil
												  repeats:NO];
	
	
	[NSThread detachNewThreadSelector:@selector(fullTextThread:)
							 toTarget:self
						   withObject:pmid];
} // getFullTextFor

-(void) fullTextThread:(NSString*)pmid
{
	@autoreleasepool {
	
		NSString*	urlString = [NSString stringWithFormat:[QueryAgent efetchURL], @"pmc", pmid];
#ifdef __DEBUG_OUTPUT__
		#if 1
			NSLog(urlString);
		#endif
#endif
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		
		// Get ready for the response
		NSData *theData;
		NSURLResponse *response;
		NSError *error;
		
		// Make the request
		theData = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
		
		if(![searchTimer isValid])
		{
			self.delegate = nil;
			
			return;
		}

		[searchTimer invalidate];	// cancel the timer

		NSString*	fullText = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
#ifdef __DEBUG_OUTPUT__
		#if 0
			NSLog(fullText);
		#endif
#endif

		
		if(delegate && [delegate respondsToSelector:@selector(setFullTextSource:)])
			[delegate performSelectorOnMainThread:@selector(setFullTextSource:) withObject:fullText waitUntilDone:NO];
		
		
		self.delegate = nil;
	
	}
	
} // fullTextThread

#pragma mark parser stuff

- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
	 attributes:(NSDictionary *)attributeDict
{
	self.currentElementValue = @"";
	[parseStack addObject:[NSMutableDictionary dictionary]];						// PUSH!
	if([parseStack count] == 1)
		self.resultDict = parseStack[0];
	
	self.currentAttributes = attributeDict;
} // parser:didStartElement

/*
 When we get to the end of an element we want to look at it and compare it to the element on the
 top of the stack. If it is the same type
 */

- (void) parser:(NSXMLParser *)parser 
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName;
{
	NSMutableDictionary*	currentDict = [parseStack lastObject];
	NSMutableDictionary*	parrentDict = nil;
	id						ealierItem = nil;
	
	if([parseStack count] > 1)
		parrentDict = parseStack[[parseStack count] -2];
	
	ealierItem = parrentDict[elementName];
	
	id	objectToAdd = nil;
	
#if 1
	if([elementName isEqualToString:@"ArticleId"])
	{
		if(currentAttributes)
		{
			NSString* IdType = currentAttributes[@"IdType"];
			if(IdType && [IdType length])
				objectToAdd = @{@"IdType": IdType, @"Id": currentElementValue};
		}
		else
			objectToAdd = currentElementValue;
	}
	else 
#endif
		if([currentDict count] == 0)					// flat item
		objectToAdd = currentElementValue;
	else
		objectToAdd = currentDict;					// complex item
		
	if(ealierItem == nil)	// no previous items like this one
	{
		// single element item
		parrentDict[elementName] = objectToAdd;
	}
	else
	{
		// ok, we have at least one already. We need to add it or make them into an array
		if([ealierItem isKindOfClass:[NSMutableArray class]])
			[ealierItem addObject:objectToAdd];
		else
		{
			NSMutableArray*	tarray = [NSMutableArray arrayWithObjects:ealierItem, objectToAdd, nil];
			parrentDict[elementName] = tarray;
		}
	} // ealierItem
	
	[parseStack removeLastObject];		// POP!
} // parser:didEndElement

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	self.currentElementValue = [currentElementValue stringByAppendingString:string]; 
} // parser:foundCharacters


@end
