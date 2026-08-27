//
//  AlxTopOnRewardVideoDelegate.m
//  AlxAdsOCDemo
//

#import "AlxTopOnRewardVideoDelegate.h"

static NSString *const TAG = @"AlxTopOnRewardVideoDelegate";

@implementation AlxTopOnRewardVideoDelegate

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    
    // 保存广告对象引用 / Save ad object reference
    self.rewardedAd = ad;
    
    // 获取价格（用于 C2S Bidding）/ Get the price (for C2S Bidding)
    double price = [ad getPrice];
    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
    
    if (price > 0) {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        adExtra[ATAdSendC2SBidPriceKey] = priceStr;
        adExtra[ATAdSendC2SCurrencyTypeKey] = @(ATBiddingCurrencyTypeUS);
        NSLog(@"%@: rewardVideoAdLoad: price = %@", TAG, priceStr);
    }
    
    // ⚠️ 注意：将广告对象传给 TopOn SDK / Note: pass the ad object to TopOn SDK
    adExtra[kATAdAssetsCustomObjectKey] = ad;
    
    // 使用正确的 RewardVideo 加载完成方法 / Use the correct RewardVideo load completion method
    [self.adStatusBridge atOnRewardedAdLoadedExtra:adExtra];
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdFailToLoad: %@", TAG, error.localizedDescription);
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdImpression", TAG);
    [self.adStatusBridge atOnAdShow:@{}];
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClick", TAG);
    [self.adStatusBridge atOnAdClick:@{}];
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClose", TAG);
    [self.adStatusBridge atOnAdClosed:@{}];
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayStart", TAG);
    [self.adStatusBridge atOnAdVideoStart:@{}];
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayEnd", TAG);
    [self.adStatusBridge atOnAdVideoEnd:@{}];
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdReward", TAG);
    // ✅ 修复：使用正确的奖励回调方法 / Fix: use the correct reward callback method
    [self.adStatusBridge atOnRewardedVideoAdRewarded];
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdPlayFail: %@", TAG, error.localizedDescription);
    [self.adStatusBridge atOnAdShowFailed:error extra:@{}];
}

@end
