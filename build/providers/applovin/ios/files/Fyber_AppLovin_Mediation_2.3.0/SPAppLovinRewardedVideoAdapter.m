//
//  SPApplovinAdapter.m
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPAppLovinNetwork.h"
#import "SPAppLovinRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "SPConstants.h"
#import "ALSdk.h"
#import "ALIncentivizedInterstitialAd.h"
#import "ALAdLoadDelegate.h"
#import "ALAdDisplayDelegate.h"
#import "ALAdVideoPlaybackDelegate.h"
#import "ALAdRewardDelegate.h"
#import "SPTPNMediationTypes.h"

@interface SPAppLovinRewardedVideoAdapter ()<ALAdVideoPlaybackDelegate, ALAdRewardDelegate, ALAdDisplayDelegate>

@property (nonatomic, strong) ALIncentivizedInterstitialAd *videoAd;
@property (nonatomic, assign) BOOL rewardValidationSucceeded;
@property (nonatomic, assign) dispatch_once_t playDispatchOnceToken;
@property (nonatomic, assign, getter=isFullyWatched) BOOL fullyWatched;

@end

@implementation SPAppLovinRewardedVideoAdapter

@synthesize delegate;

#pragma mark - SPRewardedVideoNetworkAdapter

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    [self.videoAd preloadAndNotify:nil];
    return YES;
}

- (void)checkAvailability
{
    [self.delegate adapter:self didReportVideoAvailable:self.videoAd.isReadyForDisplay];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    self.videoAd.adVideoPlaybackDelegate    = self;
    self.videoAd.adDisplayDelegate          = self;
    self.rewardValidationSucceeded          = NO;
    self.playDispatchOnceToken              = 0;
    
    [self.videoAd showOver:[[UIApplication sharedApplication] keyWindow] andNotify:self];
}

#pragma mark - AlAdVideoPlaybackDelegate
- (void)videoPlaybackBeganInAd:(ALAd *)ad
{
    SPLogDebug(@"AppLovin video started playing");
    
    // When the app resigns active and comes back from the background, this
    // method will be called again. We want to send it just once.
    dispatch_once(&_playDispatchOnceToken, ^{
        [self.delegate adapterVideoDidStart:self];
    });
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched
{
    self.fullyWatched = wasFullyWatched;
    SPLogDebug(@"AppLovin video stopped playing at %@ and %@ fully watched", percentPlayed, wasFullyWatched ? @"was" : @"was not");
}

#pragma mark - ALAdDisplayDelegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    // <# code #>
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    // <# code #>
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    [self.videoAd preloadAndNotify:nil];
    
    if (self.rewardValidationSucceeded && self.isFullyWatched) {
        [self.delegate adapterVideoDidFinish:self];
        [self.delegate adapterVideoDidClose:self];
        return;
    }
    
    [self.delegate adapterVideoDidAbort:self];
}

#pragma mark - ALAdRewardDelegate
- (void)userDeclinedToViewAd:(ALAd *)ad
{
    [self.delegate adapterVideoDidAbort:self];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response
{
    SPLogInfo(@"AppLovin reward successful");
    self.rewardValidationSucceeded = YES;
}

- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response
{
    SPLogError(@"AppLovin reward was rejected with data %@", response);
    self.rewardValidationSucceeded = NO;
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didExceedQuotaWithResponse:(NSDictionary *)response
{
    SPLogError(@"AppLovin reward has exceeded quota %@", response);
    self.rewardValidationSucceeded = NO;
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode
{
    SPLogError(@"AppLovin reward failed with error %d", responseCode);
    self.rewardValidationSucceeded = NO;
}

#pragma mark - Accessors

-(ALIncentivizedInterstitialAd *)videoAd
{
    if (!_videoAd) {
        ALSdk *appLovinSDKInstance = [ALSdk sharedWithKey:self.network.apiKey settings:self.network.alSDKSettings];
        _videoAd = [[ALIncentivizedInterstitialAd alloc] initWithSdk:appLovinSDKInstance];
    }
    return _videoAd;
}

@end
