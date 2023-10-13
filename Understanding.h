//
//  Understanding.h
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/1/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

//@interface Understanding : UIViewController<ADBannerViewDelegate> {
@interface Understanding : UIViewController {
	IBOutlet	UIWebView*	mainWebView;
//	CGRect							ContFrameLand;
//	CGRect							ContFramePort;
//	CGPoint							BannerOriginLand;
//	CGPoint							BannerOriginPort;
//	CGFloat							BannerHeightLand;
//	CGFloat							BannerHeightPort;
	CGFloat							VShiftLandscape;
	CGFloat							VShiftPortrait;
    BOOL _adBannerViewIsVisible;
    id _adBannerView;
}

@property (nonatomic, assign) BOOL adBannerViewIsVisible;
@property (nonatomic, strong) id adBannerView;

@property ( unsafe_unretained, nonatomic) IBOutlet	UIView	*contentView;

@end
