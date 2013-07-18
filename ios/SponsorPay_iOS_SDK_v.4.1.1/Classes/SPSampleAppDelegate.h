//
//  SPPublishAppDelegate.h
//  SponsorPay iOS Test App
//
//  Copyright 2011 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSampleViewController;

@interface SPSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *viewController;

@property (nonatomic, retain) NSString *lastCredentialsToken;

- (void)showSDKException:(NSException *)exception;

@end

