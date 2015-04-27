//
//  SPApplovinAdapter.h
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRewardedVideoNetworkAdapter.h"

/**
 Implementation of AppLovin network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.3.0
 - Fyber SDK version: 7.0.3
 - AppLovin SDK version: 2.5.4
 
 */

@class SPAppLovinNetwork;

@interface SPAppLovinRewardedVideoAdapter : NSObject <SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPAppLovinNetwork *network;

@end
