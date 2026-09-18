//
//  AlxMaxMediationAdapter.h
//  AlxAdsOCDemo
//

#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

/// AlxAds Max 聚合适配器，支持 Banner、激励视频、插屏、原生、开屏广告
/// AlxAds Max mediation adapter supporting Banner, Rewarded, Interstitial, Native and App Open ads.
@interface AlxMaxMediationAdapter : ALMediationAdapter <MAAdViewAdapter, MARewardedAdapter, MAInterstitialAdapter, MANativeAdAdapter, MAAppOpenAdapter>

@end

NS_ASSUME_NONNULL_END
