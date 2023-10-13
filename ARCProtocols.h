//
//  ARCProtocols.h
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/11/16.
//
//

// This app has a bunch of places where delegates and senders are "id" type. As a stopgap, I'm just putting protocols for these objects in this file

#import <Foundation/Foundation.h>

@protocol BookmarkUpdating <NSObject>
-(void)updateBookmarkInfo:(NSString*)notes;
@end

@interface ARCProtocols : NSObject
@end
