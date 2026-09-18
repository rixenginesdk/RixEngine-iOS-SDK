//
//  AlxAdmobSplashAdapter.h
//  AlxAdsOCDemo
//

#import "AlxAdmobBaseAdapter.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

/// Admob 开屏 (App Open) 广告适配器
@interface AlxAdmobSplashAdapter : AlxAdmobBaseAdapter <GADMediationAppOpenAd>

@end

NS_ASSUME_NONNULL_END
