//
//  SPUnityAdsInterstitialAdapter.m
//
//  Created on 10/10/14.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsInterstitialAdapter.h"
#import "SPUnityAdsNetwork.h"
#import "SPLogger.h"
#import "SPInterstitialClient.h"

static NSString *const SPUnityAdsInterstitialZoneId = @"SPUnityAdsInterstitialZoneId";

@interface SPUnityAdsInterstitialAdapter ()

@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, assign) BOOL userClickedAd;
@property (nonatomic, strong) NSMutableDictionary *showOptions;
@property (nonatomic, copy) NSString *zoneId;
@end

@implementation SPUnityAdsInterstitialAdapter

@synthesize offerData;

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    self.zoneId = dict[SPUnityAdsInterstitialZoneId];
    
    if (!self.zoneId.length) {
        SPLogError(@"Could not start %@ interstitial Provider. %@ empty or missing.", self.networkName, SPUnityAdsInterstitialZoneId);
        return NO;
    }
    // The `kUnityAdsOptionNoOfferscreenKey` parameter should always be passed with the `@YES` value
    self.showOptions = [[NSMutableDictionary alloc] initWithDictionary:@{
        kUnityAdsOptionVideoUsesDeviceOrientation: @YES,
        kUnityAdsOptionNoOfferscreenKey: @YES
    }];
    
    return YES;
}

#pragma mark - SPInterstitialNetworkAdapter protocol
- (BOOL)canShowInterstitial
{
    BOOL isZoneIdCorrect = YES;
    if (self.zoneId.length) {
        isZoneIdCorrect = [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    
    BOOL canShow = [[UnityAds sharedInstance] canShow];
    BOOL canShowAds = [[UnityAds sharedInstance] canShowAds];
    
    if (canShow && canShowAds && !isZoneIdCorrect) {
        NSString *errorMessage = [NSString stringWithFormat:@"UnityAds - Cannot set %@: %@",SPUnityAdsInterstitialZoneId, self.zoneId];
        SPLogError(errorMessage);
        NSError *error = [NSError errorWithDomain:SPInterstitialClientErrorDomain
                                             code:SPInterstitialClientCannotInstantiateAdapterErrorCode
                                         userInfo:@{ SPInterstitialClientErrorLoggableDescriptionKey: errorMessage }];
        [self.delegate adapter:self didFailWithError:error];
    }
    return isZoneIdCorrect && canShow && canShowAds;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    [[UnityAds sharedInstance] setViewController:viewController];
    if (self.zoneId.length) {
        [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    [UnityAds sharedInstance].delegate = self;
    
    BOOL success = [[UnityAds sharedInstance] show:self.showOptions];
    SPLogDebug(@"%@", success ? @"Showing ad for UnityAds" : @"Error showing ad for UnityAds");
    if (!success) {
        // TODO provide error with the description
        [self.delegate adapter:self didFailWithError:nil];
    }
}

#pragma mark - UnityAdsDelegate protocol

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    SPLogDebug(@"Unity Video completed: %@", skipped ? @"skipped" : @"watched");
}

- (void)unityAdsDidShow
{
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)unityAdsWillLeaveApplication
{
    self.userClickedAd = YES;
}

- (void)unityAdsDidHide
{
    SPInterstitialDismissReason dismissReason = self.userClickedAd ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd;
    [self.delegate adapter:self didDismissInterstitialWithReason:dismissReason];
}

@end
