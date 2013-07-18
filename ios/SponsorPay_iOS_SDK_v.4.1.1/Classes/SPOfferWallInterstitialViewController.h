//
//  OfferWallInterstitialViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTestAppBaseViewController.h"

@interface SPOfferWallInterstitialViewController : SPTestAppBaseViewController <SPOfferWallViewControllerDelegate, SPInterstitialViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *backgroundURLField;
@property (retain, nonatomic) IBOutlet UITextField *skinNameField;
@property (retain, nonatomic) IBOutlet UISwitch *closeOnFinishSwitch;
@property (retain, nonatomic) IBOutlet UIView *parametersGroup;
@property (retain, nonatomic) IBOutlet UIButton *launchOfferWallButton;
@property (retain, nonatomic) IBOutlet UIView *interstitialGroup;

- (IBAction)launchOfferWall;
- (IBAction)launchInterstitial;
- (IBAction)showCustomParamsController;

@end
