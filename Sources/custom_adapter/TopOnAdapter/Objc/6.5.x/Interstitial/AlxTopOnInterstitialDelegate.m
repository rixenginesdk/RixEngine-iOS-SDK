//
//  AlxTopOnInterstitialDelegate.m
//  AlxAdsOCDemo
//

#import "AlxTopOnInterstitialDelegate.h"

static NSString *const TAG = @"AlxTopOnInterstitialDelegate";

@implementation AlxTopOnInterstitialDelegate

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdLoad", TAG);
    
    // 保存广告对象引用
    self.interstitialAd = ad;
    
    // 获取价格（用于 C2S Bidding）
    double price = [ad getPrice];
    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
    
    if (price > 0) {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        adExtra[ATAdSendC2SBidPriceKey] = priceStr;
        adExtra[ATAdSendC2SCurrencyTypeKey] = @(ATBiddingCurrencyTypeUS);
        NSLog(@"%@: interstitialAdLoad: price = %@", TAG, priceStr);
    }
    
    // ⚠️ 关键：将广告对象传给 TopOn SDK
    adExtra[kATAdAssetsCustomObjectKey] = ad;
    
    // Interstitial 应该调用的方法
    [self.adStatusBridge atOnInterstitialAdLoadedExtra:adExtra];
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToLoad: %@", TAG, error.localizedDescription);
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdImpression", TAG);
    [self.adStatusBridge atOnAdShow:@{}];
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClick", TAG);
    [self.adStatusBridge atOnAdClick:@{}];
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClose", TAG);
    [self.adStatusBridge atOnAdClosed:@{}];
}

- (void)interstitialAdRenderFail:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdRenderFail: %@", TAG, error.localizedDescription);
    [self.adStatusBridge atOnAdShowFailed:error extra:@{}];
}

- (void)interstitialAdVideoStart:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoStart", TAG);
    [self.adStatusBridge atOnAdVideoStart:@{}];
}

- (void)interstitialAdVideoEnd:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoEnd", TAG);
    [self.adStatusBridge atOnAdVideoEnd:@{}];
}

@end
