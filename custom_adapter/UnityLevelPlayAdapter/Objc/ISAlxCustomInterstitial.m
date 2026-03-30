//
//  ISAlxCustomInterstitial.m
//  AlxAdsOCDemo
//
//  LevelPlay Interstitial 广告适配器
//

#import "ISAlxCustomInterstitial.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"ISAlxCustomInterstitial";

@interface ISAlxCustomInterstitial () <AlxInterstitialAdDelegate>
@property (nonatomic, strong, nullable) AlxInterstitialAd *interstitialAd;
@property (nonatomic, weak, nullable) id<ISInterstitialAdDelegate> adDelegate;
@end

@implementation ISAlxCustomInterstitial

#pragma mark - ISBaseInterstitial

/// LevelPlay 请求加载插屏广告
- (void)loadAdWithAdData:(ISAdData *)adData delegate:(id<ISInterstitialAdDelegate>)delegate {
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

    self.interstitialAd = [[AlxInterstitialAd alloc] init];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdWithAdUnitId:unitId];
}

/// LevelPlay 检查广告是否就绪
- (BOOL)isAdAvailableWithAdData:(ISAdData *)adData {
    BOOL ready = self.interstitialAd != nil && [self.interstitialAd isReady];
    NSLog(@"%@: isAdAvailable = %@", TAG, ready ? @"YES" : @"NO");
    return ready;
}

/// LevelPlay 展示插屏广告
- (void)showAdWithViewController:(UIViewController *)viewController
                          adData:(ISAdData *)adData
                        delegate:(id<ISInterstitialAdDelegate>)delegate {
    NSLog(@"%@: showAd", TAG);
    self.adDelegate = delegate;

    if (![self isAdAvailableWithAdData:adData]) {
        NSString *msg = @"ad is not ready";
        NSLog(@"%@: error: %@", TAG, msg);
        [delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:msg];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.interstitialAd showAdWithPresent:viewController];
    });
}

#pragma mark - AlxInterstitialAdDelegate

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdLoad", TAG);
    [self.adDelegate adDidLoad];
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToLoad: %@", TAG, error.localizedDescription);
    [self.adDelegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                        errorCode:error.code
                                     errorMessage:error.localizedDescription];
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdImpression", TAG);
    [self.adDelegate adDidOpen];
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClick", TAG);
    [self.adDelegate adDidClick];
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClose", TAG);
    [self.adDelegate adDidClose];
    self.interstitialAd = nil;
}

- (void)interstitialAdFailToShow:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToShow: %@", TAG, error.localizedDescription);
    [self.adDelegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal
                                     errorMessage:error.localizedDescription];
}

@end
