//
//  VSStylishButton.m
//  ClinicalTrials
//
//  Created by Joseph Falcone on 12/9/16.
//
//

#import "VSStylishButton.h"

@implementation VSStylishButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        [self initMyStuff];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super initWithCoder:aDecoder])
    {
        [self initMyStuff];
    }
    return self;
}

-(void)prepareForInterfaceBuilder
{
    [self initMyStuff];
}

-(void)initMyStuff
{
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithRed:0.58 green:0.00 blue:0.00 alpha:1.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
