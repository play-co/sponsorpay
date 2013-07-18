//
//  CPEActionsViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPCPEActionsViewController : SPTestAppBaseViewController

@property (retain, nonatomic) IBOutlet UITextField *actionIdField;
@property (retain, nonatomic) IBOutlet UIView *mainGroup;

- (IBAction)reportActionCompleted;

@end
