//
//  SPBrandEngageViewController.h
//  SponsorPay Mobile Brand Engage SDK
//
//  Copyright (c) 2012 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSPDelayForFadingWebViewIn (NSTimeInterval)1.5
#define kSPDurationForFadeWebViewInAnimation (NSTimeInterval)1.0

@class SPWebView;
@protocol SPBrandEngageWebViewDelegate;

@interface SPBrandEngageViewController : UIViewController

@property (nonatomic, weak) id<SPBrandEngageWebViewDelegate> brandEngageDelegate;

- (id)initWithWebView:(SPWebView *)webView;


- (void)fadeWebViewIn;

- (void)playVideoFromNetwork:(NSString *)network
                       video:(NSString *)video
                   showAlert:(BOOL)showAlert
                alertMessage:(NSString *)alertMessage
             clickThroughURL:(NSURL *)clickThroughURL;

- (void)showCloseButton;
- (void)hideCloseButton;

@end
