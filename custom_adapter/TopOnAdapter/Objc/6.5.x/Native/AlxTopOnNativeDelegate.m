//
//  AlxTopOnNativeDelegate.m
//  AlxAdsOCDemo
//

#import "AlxTopOnNativeDelegate.h"
#import "AlxTopOnNativeEvent.h"
#import "AlxTopOnNativeObject.h"

static NSString *const TAG = @"AlxTopOnNativeDelegate";

@implementation AlxTopOnNativeDelegate

#pragma mark - AlxNativeAdLoaderDelegate

// 正确的 Objective-C 函数（对应Swift 的 nativeAdLoaded(didReceive:)）
- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> *)ads {
    NSLog(@"%@: nativeAdLoadedWithDidReceive", TAG);
    
    AlxNativeAd *nativeAd = ads.firstObject;
    if (!nativeAd) {
        NSString *errorStr = @"native ad data is empty";
        NSLog(@"%@: %@", TAG, errorStr);
        NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: errorStr}];
        [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
        return;
    }
    
    // ⚠️ 正确的使用方式：创建 AlxTopOnNativeObject 对象
    // TopOn SDK 会通过 getter 方法获取数据，而不是直接访问属性
    AlxTopOnNativeObject *nativeObject = [[AlxTopOnNativeObject alloc] init];
    nativeObject.nativeAd = nativeAd;
    nativeObject.nativeEvent = self.nativeEvent;
    
    // ✅ 关键：设置 nativeAd 的 delegate，以便接收展示、点击、关闭回调
    nativeAd.delegate = self;
    
    // 获取价格（用于 C2S Bidding）
    double price = [nativeAd getPrice];
    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
    
    if (price > 0) {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        adExtra[ATAdSendC2SBidPriceKey] = priceStr;
        adExtra[ATAdSendC2SCurrencyTypeKey] = @(ATBiddingCurrencyTypeUS);
        NSLog(@"%@: nativeAdLoaded: price = %@", TAG, priceStr);
    }
    
    // ⚠️ 传递对象数组（TopOn SDK 会调用对象的方法获取数据）
    [self.adStatusBridge atOnNativeAdLoadedArray:@[nativeObject] adExtra:adExtra];
}

// 正确的 Objective-C 函数（Swift 的 nativeAdFailToLoad(didFailWithError:)）
- (void)nativeAdFailToLoadWithDidFailWithError:(NSError *)error {
    NSLog(@"%@: nativeAdFailToLoadWithDidFailWithError: %@", TAG, error.localizedDescription);
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
}

#pragma mark - AlxNativeAdDelegate

- (void)nativeAdImpression:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdImpression", TAG);
    [self.adStatusBridge atOnAdShow:@{}];
}

- (void)nativeAdClick:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClick", TAG);
    [self.adStatusBridge atOnAdClick:@{}];
}

- (void)nativeAdClose:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClose", TAG);
    [self.adStatusBridge atOnAdClosed:@{}];
}

@end
