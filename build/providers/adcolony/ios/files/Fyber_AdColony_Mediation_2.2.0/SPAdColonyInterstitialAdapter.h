//
//  SPAdColonyInterstitialAdapter.m
//
//  Created on 30.06.2014.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPAdColonyNetwork.h"
#import <AdColony/AdColony.h>

@class SPAdColonyInterstitialAdapter;

/**
 Implementation of AdColony network for interstitial demand
 
 ## Version compatibility
 
 - Adapter version: 2.2.0
 
 */

@interface SPAdColonyInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter, AdColonyAdDelegate>

@property (nonatomic, weak) SPAdColonyNetwork *network;

@end
