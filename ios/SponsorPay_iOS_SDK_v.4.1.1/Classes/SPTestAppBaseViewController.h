//
//  SPTestAppBaseViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SponsorPaySDK.h"

#define ADVERTISER_BASE_STAGING_URL		@""
#define INTERSTITIAL_BASE_STAGING_URL   @""
#define OFFERWALL_BASE_STAGING_URL		@""
#define VCS_BASE_STAGING_URL            @""
#define kSPMBEJSCoreURL_Staging         @""

@interface SPTestAppBaseViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) NSString *lastCredentialsToken;

- (void)showSDKException:(NSException *)exception;
- (void)showActivityIndication;
- (void)stopActivityIndication;
- (void)setBackgroundTextureWithName:(NSString *)imageFileName;
- (void)flashView:(UIView *)view;

@end
