//
//  SPStartSDKViewController.m
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SPStartSDKViewController.h"
#import "SPAdvertiserManager.h" // Needed to set staging

static NSString *const SPPersistedAppIdKey = @"SPPersistedAppIdKey";
static NSString *const SPPersistedUserIdKey = @"SPPersistedUserIdKey";
static NSString *const SPPersistedSecurityTokenKey = @"SPPersistedSecurityTokenKey";
static NSString *const SPPersistedStagingStatusKey = @"SPPersistedStagingStatusKey";

@interface SPStartSDKViewController ()

@end

@implementation SPStartSDKViewController {
    CGRect _startSDKGroupOriginalFrame;
    CGRect _credentialsSettingsGroupOriginalFrame;
    CGRect _stagingSettingsGroupOriginalFrame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _startSDKGroupOriginalFrame = self.startSDKGroup.frame;
    _credentialsSettingsGroupOriginalFrame = self.credentialsSettingsGroup.frame;
    _stagingSettingsGroupOriginalFrame = self.stagingSettingsGroup.frame;
    [self restorePersistedUserEnteredValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustUIToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self persistUserEnteredValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startSDK
{
    @try {
        NSString *credentialsToken =
        [SponsorPaySDK startForAppId:self.appIdField.text
                              userId:self.userIdField.text
                       securityToken:self.vcsKeyField.text];
        
        self.currencyNameField.text =
        [SponsorPaySDK currencyNameForCredentials:credentialsToken];
        self.showCoinsNotificationSwitch.on =
        [SponsorPaySDK shouldShowPayoffNotificationOnVirtualCoinsReceivedForCredentials:credentialsToken];
        
        self.lastCredentialsToken = credentialsToken;
        
        [self displaySDKStartedFeedback];
    }
    @catch (NSException *exception) {
        [self showSDKException:exception];
    }
}

- (void)displaySDKStartedFeedback
{
    [self flashView:self.startSDKGroup];
}

- (IBAction)userDidEnterCurrencyName:(UITextField *)sender
{
    @try {
        [SponsorPaySDK setCurrencyName:sender.text
                        forCredentials:self.lastCredentialsToken];
        [self flashView:self.credentialsSettingsGroup];
    }
    @catch (NSException *exception) {
        [self showSDKException:exception];
        sender.text = @"";
    }
}

- (IBAction)showCoinsNotificationValueChanged:(UISwitch *)sender
{
    @try {
        [SponsorPaySDK setShowPayoffNotificationOnVirtualCoinsReceived:sender.on
                                                        forCredentials:self.lastCredentialsToken];
        [self flashView:self.credentialsSettingsGroup];
    }
    @catch (NSException *exception) {
        [self showSDKException:exception];
        sender.on = YES;
    }
}

- (IBAction)stagingSwitchValueChanged:(UISwitch *)sender
{
    [self shouldUseStagingURLs:sender.on];
}

- (IBAction)clearPersistedSDKData
{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"Clear SDK Data"
                               message:@"Clear persisted SDK data?\n"
                                        "This includes the state of the Advertiser "
                                        "and Action callbacks and the last "
                                        "Transaction ID from the VCS."
                              delegate:self
                     cancelButtonTitle:@"Don't clear"
                     otherButtonTitles:@"Clear", nil];

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { 
        [SPPersistence resetAllSDKValues];
        [[SponsorPaySDK instance] performSelector:@selector(clearCredentials)];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Done"
                                   message:@"Persisted SDK data cleared.\n"
                                           "Tap on the \"Start SDK\" button to continue testing."
                                  delegate:self cancelButtonTitle:@"Thanks!"
                         otherButtonTitles:nil];

        [alert show];
    }
}

- (void)shouldUseStagingURLs:(BOOL)staging
{
    if (staging) {
        [SPAdvertiserManager overrideBaseURLWithURLString:ADVERTISER_BASE_STAGING_URL];
        [SPOfferWallViewController overrideBaseURLWithURLString:OFFERWALL_BASE_STAGING_URL];
        [SPInterstitialViewController overrideBaseURLWithURLString:INTERSTITIAL_BASE_STAGING_URL];
        [SPVirtualCurrencyServerConnector overrideVCSBaseURLWithURLString:VCS_BASE_STAGING_URL];
        [SPBrandEngageClient overrideMBEJSCoreURLWithURLString:kSPMBEJSCoreURL_Staging];
        [SPLogger log:@"Did set staging URLs"];
    } else {
        [SPAdvertiserManager restoreBaseURLToDefault];
        [SPOfferWallViewController restoreBaseURLToDefault];
        [SPInterstitialViewController restoreBaseURLToDefault];
        [SPVirtualCurrencyServerConnector restoreDefaultVCSBaseURL];
        [SPBrandEngageClient restoreDefaultMBEJSCoreURL];
        [SPLogger log:@"Did restore production URLs"];
    }
}

- (void)persistUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.appIdField.text forKey:SPPersistedAppIdKey];
    [defaults setValue:self.userIdField.text forKey:SPPersistedUserIdKey];
    [defaults setValue:self.vcsKeyField.text forKey:SPPersistedSecurityTokenKey];
    [defaults setBool:self.stagingSwitch.on forKey:SPPersistedStagingStatusKey];
    [defaults synchronize];
}

- (void)restorePersistedUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appIdField.text = [defaults valueForKey:SPPersistedAppIdKey];
    self.userIdField.text = [defaults valueForKey:SPPersistedUserIdKey];
    self.vcsKeyField.text = [defaults valueForKey:SPPersistedSecurityTokenKey];

    BOOL staging = [defaults boolForKey:SPPersistedStagingStatusKey];
    self.stagingSwitch.on = staging;
    [self shouldUseStagingURLs:staging];
}


- (void)adjustUIToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    static const CGFloat halfMargin = 2;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect leftBlock = self.startSDKGroup.frame;
        leftBlock.origin.x = halfMargin * 2;
        leftBlock.size.width = (self.view.frame.size.width / 2) - (3 * halfMargin);
        self.startSDKGroup.frame = leftBlock;
        
        CGRect rightBlock = self.credentialsSettingsGroup.frame;
        rightBlock.size.width = leftBlock.size.width;
        rightBlock.origin.y = leftBlock.origin.y;
        rightBlock.origin.x = leftBlock.origin.x + leftBlock.size.width + 2 * halfMargin;
        self.credentialsSettingsGroup.frame = rightBlock;
        
        CGRect stagingBlock = self.stagingSettingsGroup.frame;
        stagingBlock.origin.x = rightBlock.origin.x;
        stagingBlock.origin.y = rightBlock.origin.y + rightBlock.size.height + 2 * halfMargin;
        stagingBlock.size.width = rightBlock.size.width;
        self.stagingSettingsGroup.frame = stagingBlock;
    } else {
        self.startSDKGroup.frame = _startSDKGroupOriginalFrame;
        self.credentialsSettingsGroup.frame = _credentialsSettingsGroupOriginalFrame;
        self.stagingSettingsGroup.frame = _stagingSettingsGroupOriginalFrame;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustUIToInterfaceOrientation:toInterfaceOrientation];
}

- (void)dealloc {
    [_appIdField release];
    [_userIdField release];
    [_vcsKeyField release];
    [_currencyNameField release];
    [_showCoinsNotificationSwitch release];
    [_stagingSwitch release];
    [_startSDKGroup release];
    [_credentialsSettingsGroup release];
    [_stagingSettingsGroup release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAppIdField:nil];
    [self setUserIdField:nil];
    [self setVcsKeyField:nil];
    [self setCurrencyNameField:nil];
    [self setShowCoinsNotificationSwitch:nil];
    [self setStagingSwitch:nil];
    [self setStartSDKGroup:nil];
    [self setCredentialsSettingsGroup:nil];
    [self setStagingSettingsGroup:nil];
    [super viewDidUnload];
}
@end
