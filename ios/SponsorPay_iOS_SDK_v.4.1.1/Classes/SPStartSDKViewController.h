//
//  SPStartSDKViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTestAppBaseViewController.h"

@interface SPStartSDKViewController : SPTestAppBaseViewController <UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITextField *appIdField;
@property (retain, nonatomic) IBOutlet UITextField *userIdField;
@property (retain, nonatomic) IBOutlet UITextField *vcsKeyField;
@property (retain, nonatomic) IBOutlet UITextField *currencyNameField;
@property (retain, nonatomic) IBOutlet UISwitch *showCoinsNotificationSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *stagingSwitch;
@property (retain, nonatomic) IBOutlet UIView *startSDKGroup;
@property (retain, nonatomic) IBOutlet UIView *credentialsSettingsGroup;
@property (retain, nonatomic) IBOutlet UIView *stagingSettingsGroup;

- (IBAction)startSDK;
- (IBAction)userDidEnterCurrencyName:(UITextField *)sender;
- (IBAction)showCoinsNotificationValueChanged:(UISwitch *)sender;
- (IBAction)stagingSwitchValueChanged:(UISwitch *)sender;
- (IBAction)clearPersistedSDKData;

@end
