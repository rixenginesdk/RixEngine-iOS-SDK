//
//  AlxAdmobInterstitialAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobInterstitialAdapter.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"AlxAdmobInterstitialAdapter";

@interface AlxAdmobInterstitialAdapter () <AlxInterstitialAdDelegate>

@property (nonatomic, strong, nullable) AlxInterstitialAd *interstitialAd;
@property (nonatomic, weak, nullable) id<GADMediationInterstitialAdEventDelegate> delegate;
@property (nonatomic, copy, nullable) GADMediationInterstitialLoadCompletionHandler completionHandler;

@end

@implementation AlxAdmobInterstitialAdapter

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    NSLog(@"%@: loadInterstitial", TAG);
    
    NSDictionary *params = [AlxAdmobBaseAdapter parseAdparameterFor:adConfiguration.credentials];
    if (!params) {
        NSString *errorStr = @"The parameter field is not found in the adConfiguration object";
        NSLog(@"%@: config params is empty", TAG);
        self.delegate = completionHandler(nil, [self errorWithCode:-100 msg:errorStr]);
        return;
    }
    
    if (!AlxAdmobBaseAdapter.isInitialized) {
        [AlxAdmobBaseAdapter initSdkFor:params];
    }
    
    NSString *adId = params[@"unitid"];
    if (!adId || adId.length == 0) {
        NSString *errorStr = @"unitid is empty in the parameter configuration";
        NSLog(@"%@: error: %@", TAG, errorStr);
        self.delegate = completionHandler(nil, [self errorWithCode:-100 msg:errorStr]);
        return;
    }
    
    NSLog(@"%@: loadInterstitial unitid=%@", TAG, adId);
    self.completionHandler = completionHandler;
    
    // Load ad
    self.interstitialAd = [[AlxInterstitialAd alloc] init];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdWithAdUnitId:adId];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    NSLog(@"%@: present", TAG);
    if (self.interstitialAd && [self.interstitialAd isReady]) {
        [self.interstitialAd showAdWithPresent:viewController];
    }
}

#pragma mark - AlxInterstitialAdDelegate

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(self, nil);
    }
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToLoad: %@", TAG, error.localizedDescription);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(nil, error);
    }
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdImpression", TAG);
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClick", TAG);
    [self.delegate reportClick];
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClose", TAG);
    [self.delegate didDismissFullScreenView];
}

- (void)interstitialAdRenderFail:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdRenderFail", TAG);
}

- (void)interstitialAdVideoStart:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoStart", TAG);
}

- (void)interstitialAdVideoEnd:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoEnd", TAG);
}

@end
