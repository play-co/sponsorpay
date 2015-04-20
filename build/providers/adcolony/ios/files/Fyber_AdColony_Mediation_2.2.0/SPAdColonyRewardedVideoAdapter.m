//
//  SPAdColonyRewardedVideoAdapter.m
//
//  Created on 07/05/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPAdColonyRewardedVideoAdapter.h"
#import "SPAdColonyNetwork.h"
#import "SPLogger.h"
#import "SPReachability.h"

#ifndef LogInvocation
#define LogInvocation SPLogDebug(@"%s", __PRETTY_FUNCTION__)
#endif

static NSString *const SPAdColonyV4VCRewardSupportErrorDescription = @"The following `ZoneId`: %@ for the %@ V4VC adapter should support virtual currency reward. Please check the settings of the rewarded video adapter.";

typedef NS_ENUM(NSInteger, SPAdColonyRewardState) {
    SPAdColonyRewardUnknown,
    SPAdColonyRewardSuccessful,
    SPAdColonyRewardFailed
};

@interface SPAdColonyRewardedVideoAdapter ()

@property (nonatomic, copy) NSString *zoneId;

@property (nonatomic, assign) BOOL videoAvailable;
@property (nonatomic, assign) BOOL videoClosed;
@property (nonatomic, assign) SPAdColonyRewardState userRewarded;

@end

@implementation SPAdColonyRewardedVideoAdapter

@synthesize delegate = _delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)data
{
    id zoneIdParam = data[SPAdColonyV4VCZoneId];
    self.zoneId = [zoneIdParam isKindOfClass:[NSString class]] ? zoneIdParam : nil;
    if (!self.zoneId.length) {
        SPLogError(@"ZoneId for %@ V4VC missing or empty", self.networkName);
        return NO;
    }
    return YES;
}

- (void)checkAvailability
{
    if (self.videoAvailable && ![AdColony isVirtualCurrencyRewardAvailableForZone:self.zoneId]) {
        NSString *description = [NSString stringWithFormat:SPAdColonyV4VCRewardSupportErrorDescription, self.zoneId, self.networkName];
        SPLogError(@"%@", description);
        NSError *error = [NSError errorWithDomain:@"com.sponsorpay.rewardedVideoError"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey:description}];
        [self.delegate adapter:self didFailWithError:error];
        return;
    }
    
    [self.delegate adapter:self didReportVideoAvailable:self.videoAvailable];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    self.userRewarded = SPAdColonyRewardUnknown;
    self.videoClosed = NO;

    [AdColony playVideoAdForZone:self.zoneId withDelegate:self];
}

#pragma mark - AdColonyDelegate methods

- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString *)zoneID
{
    LogInvocation;

    if (![zoneID isEqualToString:self.zoneId]) {
        SPLogWarn(@"zoneId received is different than the one requested by the ad");
        return;
    }
    
    if (available && ![AdColony isVirtualCurrencyRewardAvailableForZone:self.zoneId]) {
        SPLogError(SPAdColonyV4VCRewardSupportErrorDescription, self.zoneId, self.networkName);
    }
    
    self.videoAvailable = available;
}

- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString *)currencyName currencyAmount:(int)amount inZone:(NSString *)zoneID
{
    SPLogDebug(@"%s Rewarded: %@", __PRETTY_FUNCTION__, success ? @"YES" : @"NO");

    if (![zoneID isEqualToString:self.zoneId]) {
        SPLogWarn(@"zoneId received is different than the one requested by the ad");
        return;
    }

    self.userRewarded = success ? SPAdColonyRewardSuccessful : SPAdColonyRewardFailed;
    [self notifyWebView];
}

#pragma mark - AdColonyAdDelegate methods

- (void)onAdColonyAdStartedInZone:(NSString *)zoneID
{
    LogInvocation;

    if (![zoneID isEqualToString:self.zoneId]) {
        SPLogWarn(@"zoneId received is different than the one requested by the ad");
        return;
    }

    [self.delegate adapterVideoDidStart:self];
}

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    LogInvocation;

    if (![zoneID isEqualToString:self.zoneId]) {
        SPLogWarn(@"zoneId received is different than the one requested by the ad");
        return;
    }

    if (shown) {
        self.videoClosed = YES;
        [self notifyWebView];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
}

#pragma mark - Private methods

// Should only be called when the reward has been set and video has closed.
- (void)notifyWebView
{
    // Validations
    SPLogDebug(@"%s - User Rewarded %d video closed: %@", __PRETTY_FUNCTION__, self.userRewarded, self.videoClosed ? @"YES" : @"NO");
    if (self.userRewarded == SPAdColonyRewardUnknown) {
        return;
    }
    if (!self.videoClosed) {
        return;
    }

    // In case when the application loses connectivity in the middle of the video, the user
    // can't be rewarded. Given our current offer implementation, we return CLOSE_FINISHED in
    // this case
    SPReachability *reachability = [SPReachability reachabilityForInternetConnection];
    BOOL isInternetReachable = [reachability currentReachabilityStatus] != SPNotReachable;

    if (!isInternetReachable) {
        SPLogDebug(@"AdColony - Internet not reachable");
        //TODO refactor error domain, code, etc.
        NSError *error = [NSError errorWithDomain:@"com.sponsorpay.rewardedVideoError" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Internet not reachable"}];
        [self.delegate adapter:self didFailWithError:error];
        return;
    }

    switch (self.userRewarded) {
        case SPAdColonyRewardSuccessful: {
            [self.delegate adapterVideoDidFinish:self];
            [self.delegate adapterVideoDidClose:self];
        }

        break;
        case SPAdColonyRewardFailed: {
            [self.delegate adapterVideoDidAbort:self];
        }
        default:
            break;
    }
}

@end
