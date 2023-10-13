//
//  ExtendedWebBrowser.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import <objc/runtime.h>
#import "ExtendedWebBrowser.h"
#import "InAppWebBrowser.h"

@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@interface ExtendedWebBrowser (Private)
- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@implementation UIView (__TapHook)

- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
	
	ExtendedWebBrowser* webView = (ExtendedWebBrowser*) [[self superview] superview];
	if (touches.count > 1) {
		if ([webView respondsToSelector:@selector(fireZoomingEndedWithTouches:event:)]) {
			[webView fireZoomingEndedWithTouches:touches event:event];
		}
	}
	else {
        if([webView.delegate isKindOfClass:[InAppWebBrowser class]])
        {
            InAppWebBrowser *b = (InAppWebBrowser *)webView.delegate;
            UITouch*	touch = [touches anyObject];
            if(touch && [touch tapCount] == 1)
            {
                [b showControls];
                return;
            }
        }
        /*
		if(webView.delegate)
		{
			UITouch*	touch = [touches anyObject];
			if(touch && [touch tapCount] == 1)
			{
				if ([webView.delegate respondsToSelector:@selector(showControls)])
				{
					[webView.delegate showControls];
					return;
				}
			}
			
		}*/
		if ([webView respondsToSelector:@selector(fireTappedWithTouch:event:)]) {
			[webView fireTappedWithTouch:[touches anyObject] event:event];
		}
	}
}

@end

static BOOL hookInstalled = NO;

static void installHook()
{
	return;
	if (hookInstalled) return;
	
	hookInstalled = YES;
	
	Class klass = objc_getClass("UIWebDocumentView");
	Method targetMethod = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method newMethod = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	method_exchangeImplementations(targetMethod, newMethod);
}


@implementation ExtendedWebBrowser

- (instancetype)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		installHook();
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	//return; // Why is this here???
    if (self = [super initWithFrame:frame]) {
		installHook();
    }
    return self;
}

- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:zoomingEndedWithTouches:event:)]) {
		[(NSObject*)self.delegate webView:self zoomingEndedWithTouches:touches event:event];
	}
}

- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:touch event:event];
	}
}


@end
