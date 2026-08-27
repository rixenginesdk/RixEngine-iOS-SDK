//
//  AlxAdmobBannerAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobBannerAdapter.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"AlxAdmobBannerAdapter";

@interface AlxAdmobBannerAdapter () <AlxBannerViewAdDelegate>

@property (nonatomic, strong, nullable) AlxBannerAdView *bannerAd;
@property (nonatomic, weak, nullable) id<GADMediationBannerAdEventDelegate> delegate;
@property (nonatomic, copy, nullable) GADMediationBannerLoadCompletionHandler completionHandler;

@end

@implementation AlxAdmobBannerAdapter

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    NSLog(@"%@: loadBanner", TAG);
    
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
    
    NSLog(@"%@: loadBanner unitid=%@", TAG, adId);
    self.completionHandler = completionHandler;
    
    // Load ad
    CGSize adSize = adConfiguration.adSize.size;
    self.bannerAd = [[AlxBannerAdView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    self.bannerAd.delegate = self;
    self.bannerAd.refreshInterval = 0;
    self.bannerAd.rootViewController = adConfiguration.topViewController;
    [self.bannerAd loadAdWithAdUnitId:adId];
}

#pragma mark - GADMediationBannerAd

- (UIView *)view {
    return self.bannerAd ?: [[UIView alloc] init];
}

#pragma mark - AlxBannerViewAdDelegate

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(self, nil);
    }
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSLog(@"%@: bannerViewAdFailToLoad: %@", TAG, error.localizedDescription);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(self, error);
    }
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdImpression", TAG);
    [self.delegate reportImpression];
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClick", TAG);
    [self.delegate reportClick];
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClose", TAG);
    [self.delegate didDismissFullScreenView];
}

@end
