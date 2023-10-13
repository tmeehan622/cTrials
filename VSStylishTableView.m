
//
//  VSStylishTableView.m
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/16/16.
//
//

#import "VSStylishTableView.h"

@implementation VSStylishTableView

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self styleMe];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self styleMe];
    }
    return self;
}

-(void)styleMe
{
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
