//
//  ISAlxCustomRewardedVideo.m
//  AlxAdsOCDemo
//
//  LevelPlay RewardedVideo 广告适配器 / LevelPlay RewardedVideo ad adapter
//

#import "ISAlxCustomRewardedVideo.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"ISAlxCustomRewardedVideo";

@interface ISAlxCustomRewardedVideo () <AlxRewardVideoAdDelegate>
@property (nonatomic, strong, nullable) AlxRewardVideoAd *rewardedAd;
@property (nonatomic, weak, nullable) id<ISRewardedVideoAdDelegate> adDelegate;
@end

@implementation ISAlxCustomRewardedVideo

#pragma mark - ISBaseRewardedVideo

/**
 * LevelPlay 请求加载激励视频广告。
 * LevelPlay requests to load rewarded video ad.
 */
- (void)loadAdWithAdData:(ISAdData *)adData delegate:(id<ISRewardedVideoAdDelegate>)delegate {
    NSLog(@"%@: loadAd", TAG);
    self.adDelegate = delegate;

    [ISAlxCustomAdapter initSdkWithAdData:adData];

    NSString *unitId = adData.configuration[@"unitid"];
    if (!unitId || unitId.length == 0) {
        NSString *msg = @"unitid is empty";
        NSLog(@"%@: error: %@", TAG, msg);
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorMissingParams
                                  errorMessage:msg];
        return;
    }

    NSLog(@"%@: loadAd unitid=%@", TAG, unitId);

    self.rewardedAd = [[AlxRewardVideoAd alloc] init];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAdWithAdUnitId:unitId];
}

/**
 * LevelPlay 检查广告是否就绪。
 * LevelPlay checks if the ad is ready.
 */
- (BOOL)isAdAvailableWithAdData:(ISAdData *)adData {
    BOOL ready = self.rewardedAd != nil && [self.rewardedAd isReady];
    NSLog(@"%@: isAdAvailable = %@", TAG, ready ? @"YES" : @"NO");
    return ready;
}

/**
 * LevelPlay 展示激励视频广告。
 * LevelPlay shows rewarded video ad.
 */
- (void)showAdWithViewController:(UIViewController *)viewController
                          adData:(ISAdData *)adData
                        delegate:(id<ISRewardedVideoAdDelegate>)delegate {
    NSLog(@"%@: showAd", TAG);
    self.adDelegate = delegate;

    if (![self isAdAvailableWithAdData:adData]) {
        NSString *msg = @"ad is not ready";
        NSLog(@"%@: error: %@", TAG, msg);
        [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:msg];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rewardedAd showAdWithPresent:viewController];
    });
}

#pragma mark - AlxRewardVideoAdDelegate

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    [self.adDelegate adDidLoad];
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdFailToLoad: %@", TAG, error.localizedDescription);
    [self.adDelegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                        errorCode:error.code
                                     errorMessage:error.localizedDescription];
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdImpression", TAG);
    [self.adDelegate adDidOpen];
    [self.adDelegate adDidBecomeVisible];
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClick", TAG);
    [self.adDelegate adDidClick];
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClose", TAG);
    [self.adDelegate adDidClose];
    self.rewardedAd = nil;
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayStart", TAG);
    [self.adDelegate adDidStart];
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayEnd", TAG);
    [self.adDelegate adDidEnd];
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdReward", TAG);
    [self.adDelegate adRewarded];
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdPlayFail: %@", TAG, error.localizedDescription);
    [self.adDelegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal
                                     errorMessage:error.localizedDescription];
}

@end
