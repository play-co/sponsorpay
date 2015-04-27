//
//  SPUnityAdsRewardedVideoAdapter.m
//
//  Created on 10/1/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsRewardedVideoAdapter.h"
#import "SPUnityAdsNetwork.h"
#import "SPLogger.h"

static NSString *const SPUnityAdsRewardedVideoZoneId = @"SPUnityAdsRewardedVideoZoneId";
static NSString *const SPUnityAdsErrorDomain = @"SPUnityAdsErrorDomain";
static NSInteger const SPUnityAdsWrongZoneIdErrorCode = -1;

@interface SPUnityAdsRewardedVideoAdapter ()

@property (nonatomic, assign) BOOL videoFullyWatched;
@property (nonatomic, strong) NSMutableDictionary *showOptions;
@property (nonatomic, copy) NSString *zoneId;

@end

@implementation SPUnityAdsRewardedVideoAdapter

@synthesize delegate = _delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    self.zoneId = dict[SPUnityAdsRewardedVideoZoneId];
    
    if (!self.zoneId.length) {
        SPLogError(@"Could not start %@ rewarded video Provider. %@ empty or missing.", self.networkName, SPUnityAdsRewardedVideoZoneId);
        return NO;
    }
    
    // The `kUnityAdsOptionNoOfferscreenKey` parameter should always be passed with the `@YES` value
    self.showOptions = [[NSMutableDictionary alloc] initWithDictionary:@{
        kUnityAdsOptionVideoUsesDeviceOrientation: @YES,
        kUnityAdsOptionNoOfferscreenKey: @YES
    }];
    
    return YES;
}

- (void)checkAvailability
{
    BOOL isZoneIdCorrect = YES;
    if (self.zoneId.length) {
        isZoneIdCorrect = [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    
    BOOL canShow = [[UnityAds sharedInstance] canShow];
    BOOL canShowAds = [[UnityAds sharedInstance] canShowAds];
    
    if (canShow && !isZoneIdCorrect) {
        NSString *errorMessage = [NSString stringWithFormat:@"UnityAds - Cannot set %@: %@",SPUnityAdsRewardedVideoZoneId, self.zoneId];
        SPLogError(errorMessage);
        NSError *error = [NSError errorWithDomain:SPUnityAdsErrorDomain
                                             code:SPUnityAdsWrongZoneIdErrorCode
                                         userInfo:@{ NSLocalizedDescriptionKey: errorMessage }];
        [self.delegate adapter:self didFailWithError:error];
        return;
    }

    [self.delegate adapter:self didReportVideoAvailable:(canShow && canShowAds)];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    [[UnityAds sharedInstance] setViewController:parentVC];
    if (self.zoneId.length) {
        [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    [UnityAds sharedInstance].delegate = self;
    
    BOOL success = [[UnityAds sharedInstance] show:self.showOptions];
    SPLogDebug(@"%@", success ? @"Showing Unity Rewarded Video" : @"Error showing Unity Rewarded Video");
    if (!success) {
        // TODO provide error with the description
        [self.delegate adapter:self didFailWithError:nil];
    }
}

#pragma mark - UnityAdsDelegate selectors

- (void)unityAdsFetchCompleted
{
    SPLogInfo(@"UnityAds campaigns available");
}

- (void)unityAdsFetchFailed
{
    [self.delegate adapter:self didFailWithError:nil]; // TODO provide a meaningful error
}

- (void)unityAdsVideoStarted
{
    [self.delegate adapterVideoDidStart:self];
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    if (skipped) {
        [self.delegate adapterVideoDidAbort:self];
        return;
    }

    self.videoFullyWatched = YES;
    [self.delegate adapterVideoDidFinish:self];
}

- (void)unityAdsDidHide
{
    if (self.videoFullyWatched) {
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
    self.videoFullyWatched = NO;
}

@end
