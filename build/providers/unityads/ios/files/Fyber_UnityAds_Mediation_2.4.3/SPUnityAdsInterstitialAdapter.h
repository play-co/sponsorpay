//
//  SPUnityAdsInterstitialAdapter.m
//
//  Created on 10/10/14.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsNetwork.h"
#import <UnityAds/UnityAds.h>

/**
 Implementation of Unity Ads network for Interstitial demand

 ## Version compatibility

 - Adapter version: 2.4.3

 */


@class SPUnityAdsInterstitialAdapter;

@interface SPUnityAdsInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter, UnityAdsDelegate>

@property (weak, nonatomic) SPApplifierNetwork *network;

@end
