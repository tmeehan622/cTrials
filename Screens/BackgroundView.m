//
//  BackgroundView.m
//  ClinicalTrials
//
//  Created by Joseph Falcone on 11/23/16.
//
//

#import "BackgroundView.h"

@interface BackgroundView()
{
    BOOL setupComplete;
}
@end

@implementation BackgroundView

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
    //    if(setupComplete)
    //        return;
    //    setupComplete = YES;
    
    self.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    
    /*
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG_Watermark"]];
    [self insertSubview:iv atIndex:0];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [iv.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
    [iv.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    */
}

@end
