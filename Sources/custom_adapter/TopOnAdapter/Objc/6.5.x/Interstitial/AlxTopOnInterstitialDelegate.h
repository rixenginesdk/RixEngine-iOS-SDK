//
//  AlxTopOnInterstitialDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnInterstitialDelegate : NSObject <AlxInterstitialAdDelegate>

@property (nonatomic, strong) ATInterstitialAdStatusBridge *adStatusBridge;
@property (nonatomic, weak) AlxInterstitialAd *interstitialAd;  // 保存广告对象引用

@end

NS_ASSUME_NONNULL_END
