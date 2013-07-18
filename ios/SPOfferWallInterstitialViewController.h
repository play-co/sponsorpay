//
//  OfferWallInterstitialViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SponsorPaySDK.h"
#import "TeaLeafAppDelegate.h"

@interface SPOfferWallInterstitialViewController : UIViewController <SPOfferWallViewControllerDelegate, SPInterstitialViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *backgroundURLField;
@property (retain, nonatomic) IBOutlet UITextField *skinNameField;
@property (retain, nonatomic) IBOutlet UISwitch *closeOnFinishSwitch;
@property (retain, nonatomic) IBOutlet UIView *parametersGroup;
@property (retain, nonatomic) IBOutlet UIButton *launchOfferWallButton;
@property (retain, nonatomic) IBOutlet UIView *interstitialGroup;

@property (retain, nonatomic) IBOutlet NSString *lastCredentialsToken;
@property (nonatomic, retain) TeaLeafAppDelegate *appDelegate;

- (IBAction)launchOfferWall;
- (IBAction)launchInterstitial;

- offerWallViewController:(SPOfferWallViewController *)offerWallVC isFinishedWithStatus:(NSInteger)status;

@end
