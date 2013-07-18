//
//  SPMBEViewController.m
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPMBEViewController.h"

@interface SPMBEViewController ()

@property (retain) SPBrandEngageClient *brandEngageClient;

@end

@implementation SPMBEViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)requestOffers
{
    @try {
        self.brandEngageClient =
        [SponsorPaySDK brandEngageClientForCredentials:self.lastCredentialsToken];
        self.brandEngageClient.delegate = self;
        [self.brandEngageClient requestOffers];
        [self showActivityIndication];
        [SPLogger log:@"Requesting offers..."];
        [self flashView:self.mainGroup];
    } @catch (NSException *exception) {
        [self showSDKException:exception];
    }
}

- (IBAction)start
{
    @try {
        self.brandEngageClient.shouldShowRewardNotificationOnEngagementCompleted =
        self.engagementCompletedNotificationSwitch.on;
        [self.brandEngageClient startWithParentViewController:self];
    } @catch (NSException *exception) {
        [self showSDKException:exception];
    }
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
         didReceiveOffers:(BOOL)areOffersAvailable
{
    self.startButton.enabled = areOffersAvailable;
    [self stopActivityIndication];
    [SPLogger log:areOffersAvailable ? @"Offers are available" : @"No offers available"];
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
          didChangeStatus:(SPBrandEngageClientStatus)newStatus
{
    self.startButton.enabled = NO;
    [self stopActivityIndication];
    
    NSString *statusName;
    
    switch (newStatus) {
        case STARTED: statusName = @"STARTED"; break;
        case CLOSE_FINISHED: statusName = @"CLOSE_FINISHED"; break;
        case CLOSE_ABORTED: statusName = @"CLOSE_ABORTED"; break;
        case ERROR: statusName = @"ERROR"; break;
    }
    [SPLogger log:@"Brand engage client changed status to: %@", statusName];
}

- (void)dealloc {
    [_startButton release];
    [_engagementCompletedNotificationSwitch release];
    [_mainGroup release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setStartButton:nil];
    [self setEngagementCompletedNotificationSwitch:nil];
    [self setMainGroup:nil];
    [super viewDidUnload];
}
@end
