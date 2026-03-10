//
//  AlxTopOnNativeEvent.h
//  AlxAdsOCDemo
//

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AlxAds/AlxAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnNativeEvent : ATNativeADCustomEvent <AlxNativeAdLoaderDelegate, AlxNativeAdDelegate>

@property (nonatomic, strong) NSDictionary *assetDict;

- (NSDictionary *)createAssetWithNativeAd:(AlxNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
