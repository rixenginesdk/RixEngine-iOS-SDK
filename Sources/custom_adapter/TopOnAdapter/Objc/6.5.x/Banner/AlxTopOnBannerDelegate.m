//
//  AlxTopOnBannerDelegate.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBannerDelegate.h"

static NSString *const TAG = @"AlxTopOnBannerDelegate";

@implementation AlxTopOnBannerDelegate

/**
   平台广告准备就绪，可以进行展示
 */
- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdLoad", TAG);
    
    // 获取价格（用于 C2S Bidding）
    double price = [bannerView getPrice];
    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
    
    // 如果有价格，添加到 extra 中
    if (price > 0) {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        adExtra[ATAdSendC2SBidPriceKey] = priceStr;
        adExtra[ATAdSendC2SCurrencyTypeKey] = @(ATBiddingCurrencyTypeUS); // 根据实际情况选择货币类型
        NSLog(@"%@: bannerViewAdLoad: price = %@", TAG, priceStr);
    }
    
    // 将我们的广告 AlxSDK 回调中附带的横幅广告对象传递给TopOn SDK
    [self.adStatusBridge atOnBannerAdLoadedWithView:bannerView adExtra:adExtra];
}

/**
 *  banner条点击回调
 */
- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClick", TAG);
    [self.adStatusBridge atOnAdClick:@{}];
}

/**
   banner 广告关闭
 */
- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClose", TAG);
    [self.adStatusBridge atOnAdClosed:@{}];
}

/**
 banner 广告展示
 */
- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdImpression", TAG);
    [self.adStatusBridge atOnAdShow:@{}];
}

/**
 * 请求广告失败后调用
 */
- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSLog(@"%@: bannerViewAdFailToLoad: %@", TAG, error.localizedDescription);
    // 通知 TopOn 加载失败
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
}

@end
