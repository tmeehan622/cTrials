//
//  InAppWebBrowser.m
//  Pubmed Experiment
//
//  Created by Matthew Mashyna on 10/13/09.
//  Copyright 2009 The Frodis Co. All rights reserved.
//

#import "InAppWebBrowser.h"

#define wTimeOut 6.0

@implementation InAppWebBrowser

@synthesize destination,vTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    mainWebView.delegate = self;
    
    NSURLRequest *rqst = [NSURLRequest requestWithURL:[NSURL URLWithString:destination]];
    [mainWebView loadRequest:rqst];

#if 1
	UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Alert"
													message:@"When you are done, touch the 'Back to cTrials' button."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
#endif
	
}

- (IBAction) done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
} // done

- (IBAction) back:(id)sender
{
	[mainWebView goBack];
} // back

- (IBAction) next:(id)sender
{
	[mainWebView goForward];
} // next

- (IBAction) refresh:(id)sender
{
	[mainWebView reload];
} // refresh

- (void) retryPageLoad {
    NSURLRequest *rqst = [NSURLRequest requestWithURL:[NSURL URLWithString:destination]];
    [mainWebView loadRequest:rqst];
}

- (void) errorAlert {
    [self stopTimer];
    
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"Page Load Error"
                                                                     message:@"Unable to load the page you requested. "
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction   *RetryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self retryPageLoad];
                                                       }];
    UIAlertAction   *OKAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self dismissModalViewControllerAnimated:YES];
                                                          }];
    
    [alert addAction:OKAction];
    [alert addAction:RetryAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void) timeOutErrorAlert {
    [self stopTimer];
    
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"Page Load Error"
                                                                     message:@"The page request has timed out. "
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction   *RetryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self retryPageLoad];
                                                          }];
    UIAlertAction   *OKAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self dismissModalViewControllerAnimated:YES];
                                                       }];
    
    [alert addAction:OKAction];
    [alert addAction:RetryAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopTimer];

	busy.hidden = YES;
	mainWebView.alpha = 1;
	backButton.enabled = [mainWebView canGoBack];
	forwardButton.enabled = [mainWebView canGoForward];
	refreshButton.enabled = YES;
} // webViewDidFinishLoad

-(void) startTimer {
    if (self.vTimer != nil){
        [self.vTimer invalidate];
    }
    
    self.vTimer = nil;
    self.vTimer = [NSTimer scheduledTimerWithTimeInterval:wTimeOut target:self selector:@selector(fireTimer:) userInfo:nil repeats:NO];
}

-(void) stopTimer{
    [self.vTimer invalidate];
    self.vTimer = nil;
}

-(void)fireTimer:(NSTimer *)timer{
    [self stopTimer];
    [self timeOutErrorAlert];
}

- (void)webViewDidStartLoad:(UIWebView *)webView; {
	busy.hidden = NO;
	mainWebView.alpha = 0.25;
	backButton.enabled = [mainWebView canGoBack];
	forwardButton.enabled = [mainWebView canGoForward];
	refreshButton.enabled = NO;
    [self startTimer];
} // webViewDidStartLoad

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
#ifdef __DEBUG_OUTPUT__
	NSLog([[request URL] description]);
#endif
    toolBar.hidden = YES;
	return YES;
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
#ifndef __DEBUG_OUTPUT__
	[Flurry logEvent:@"Internal Browser Open"];
#endif
}


- (void)viewWillDisappear:(BOOL)animated {
    [mainWebView stopLoading];
    mainWebView.delegate = nil;
    [super viewWillDisappear:animated];
} // viewWillDisappear


-(void) showControls {
	[UIView beginAnimations:nil context:@"toolbar"];
	toolBar.alpha = !toolBar.hidden;
	toolBar.hidden = !toolBar.hidden;
	
	[UIView setAnimationDuration:0.3];
	toolBar.alpha = !toolBar.hidden;
	[UIView commitAnimations];
} // showControls

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self errorAlert];
}

@end
