//
//  SPVCSViewController.h
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPVCSViewController : SPTestAppBaseViewController <SPVirtualCurrencyConnectionDelegate>

@property (retain, nonatomic) IBOutlet UIView *sendRequestGroup;
@property (retain, nonatomic) IBOutlet UIView *transactionIDsGroup;
@property (retain, nonatomic) IBOutlet UIView *deltaOfCoinsGroup;
@property (retain, nonatomic) IBOutlet UITextView *requestLTIDView;
@property (retain, nonatomic) IBOutlet UITextView *responseLTIDView;
@property (retain, nonatomic) IBOutlet UITextView *responseDeltaOfCoinsView;

- (IBAction)sendDeltaOfCoinsRequest;

@end
