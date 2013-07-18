//
//  SPMBEViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPMBEViewController : SPTestAppBaseViewController <SPBrandEngageClientDelegate>

@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UISwitch *engagementCompletedNotificationSwitch;
@property (retain, nonatomic) IBOutlet UIView *mainGroup;

- (IBAction)requestOffers;
- (IBAction)start;

@end
