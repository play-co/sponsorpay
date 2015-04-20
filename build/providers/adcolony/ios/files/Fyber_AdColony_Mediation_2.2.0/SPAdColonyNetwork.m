//
//  SPAdColonyNetwork.m
//
//  Created on 07/05/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPAdColonyNetwork.h"
#import "SPTPNGenericAdapter.h"
#import "SPInterstitialNetworkAdapter.h"
#import "SPRewardedVideoNetworkAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"
#import <AdColony/AdColony.h>

static const NSInteger SPAdColonyVersionMajor = 2;
static const NSInteger SPAdColonyVersionMinor = 2;
static const NSInteger SPAdColonyVersionPatch = 0;

static NSString *const SPAdColonyAppId = @"SPAdColonyAppId";
NSString *const SPAdColonyV4VCZoneId = @"SPAdColonyV4VCZoneId";
NSString *const SPAdColonyInterstitialZoneId = @"SPAdColonyInterstitialZoneId";

static NSString *const SPInterstitialAdapterClassName = @"SPAdColonyInterstitialAdapter";
static NSString *const SPRewardedVideoAdapterClassName = @"SPAdColonyRewardedVideoAdapter";

@interface SPAdColonyNetwork()

@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;
@property (nonatomic, weak) id<SPRewardedVideoNetworkAdapter, AdColonyDelegate> rewardedVideoNetworkAdapter;
@property (nonatomic, strong) id<SPInterstitialNetworkAdapter> interstitialAdapter;

@end

@implementation SPAdColonyNetwork

@synthesize rewardedVideoAdapter;
@synthesize rewardedVideoNetworkAdapter;
@synthesize interstitialAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAdColonyVersionMajor
                                         minor:SPAdColonyVersionMinor
                                         patch:SPAdColonyVersionPatch];
}


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
        if (RewardedVideoAdapterClass) {
            id<SPRewardedVideoNetworkAdapter, AdColonyDelegate> adColonyRewardedVideoNetworkAdapter = [[RewardedVideoAdapterClass alloc] init];
            self.rewardedVideoNetworkAdapter = adColonyRewardedVideoNetworkAdapter;
            
            self.rewardedVideoAdapter = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:adColonyRewardedVideoNetworkAdapter];
            adColonyRewardedVideoNetworkAdapter.delegate = self.rewardedVideoAdapter;
        }
        
        Class InterstitialAdapterClass = NSClassFromString(SPInterstitialAdapterClassName);
        if (InterstitialAdapterClass) {
            self.interstitialAdapter = [[InterstitialAdapterClass alloc] init];
        }
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    id appIdParam = data[SPAdColonyAppId];
    id V4VCZoneIdParam = data[SPAdColonyV4VCZoneId];
    id interstitialZoneIdParam = data[SPAdColonyInterstitialZoneId];
    NSString *appId = [appIdParam isKindOfClass:[NSString class]] ? appIdParam : nil;
    NSString *V4VCZoneId = [V4VCZoneIdParam isKindOfClass:[NSString class]] ? V4VCZoneIdParam : nil;
    NSString *interstitialZoneId = [interstitialZoneIdParam isKindOfClass:[NSString class]] ? interstitialZoneIdParam : nil;
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        SPLogError(@"AdColony only supports iOS 6 or later");
        return NO;
    }
    
    if (!appId.length) {
        SPLogError(@"%@ Appid missing or empty", self.name);
        return NO;
    }
    
    if (!V4VCZoneId.length && !interstitialZoneId.length) {
        SPLogError(@"ZoneId for %@ V4VC/interstitial missing or empty", self.name);
        return NO;
    }
    
    if ([V4VCZoneId isEqualToString:interstitialZoneId]) {
        SPLogError(@"ZoneId for %@ V4VC and interstitial should not have the same values", self.name);
        return NO;
    }
    
    NSMutableArray *zoneIDs = [NSMutableArray array];
    if (V4VCZoneId) {
        [zoneIDs addObject:V4VCZoneId];
    }
    if (interstitialZoneId) {
        [zoneIDs addObject:interstitialZoneId];
    }
    
    [AdColony configureWithAppID:appId zoneIDs:zoneIDs delegate:self.rewardedVideoNetworkAdapter logging:YES];
    return YES;
}

@end
