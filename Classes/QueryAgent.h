//
//  QueryAgent.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 6/22/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericParser.h"

@interface QueryAgent : NSObject {
	NSTimer*					searchTimer;
	id							delegate;
	
	NSMutableDictionary*		resultDict;
	NSMutableArray*				parseStack;
	NSDictionary*				currentAttributes;
	
	NSString*					dbName;
	NSString*					currentElementValue;
	BOOL						workSilently;
	int							retstart;
	int							retmax;
}
@property (nonatomic, strong) 	id<GenericParserClient>	delegate;
@property (nonatomic, strong) 	NSMutableDictionary*	resultDict;
@property (nonatomic, strong) 	NSMutableArray*			parseStack;
@property (nonatomic, strong) 	NSDictionary*			currentAttributes;
@property (nonatomic, strong) 	NSString*				currentElementValue;
@property int retstart;
@property int retmax;

+(NSString*)esearchURL;
+(NSString*)efetchURL;
+(NSString*)eLinkURL;
-(instancetype)initForDB:(NSString*)db NS_DESIGNATED_INITIALIZER;
-(void) searchFor:(NSString*)term usingDelegate:(id)aDelegate;
-(void) searchThread:(NSString*)searchString;
-(void) searchTimeout:(NSTimer*)timer;

-(void) fetchIDs:(NSArray*)pubIDs usingDelegate:(id)aDelegate;
-(void) fetchThread:(NSString*)fetchString;

-(void) getFullTextFor:(NSString*)pmid usingDelegate:(id)aDelegate;
-(void) fullTextThread:(NSString*)pmid;

-(void) fetchRelated:(NSArray*)pubIDs usingDelegate:(id)aDelegate;
-(void) relatedThread:(NSString*)fetchString;

@end
