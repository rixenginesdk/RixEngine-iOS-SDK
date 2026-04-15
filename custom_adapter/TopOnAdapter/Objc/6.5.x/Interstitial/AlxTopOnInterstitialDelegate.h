//
//  AlxTopOnInterstitialDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnInterstitialDelegate : NSObject <AlxInterstitialAdDelegate>

@property (nonatomic, strong) ATInterstitialAdStatusBridge *adStatusBridge;
/**
 * 保存广告对象引用。
 * Save ad object reference.
 */
@property (nonatomic, weak) AlxInterstitialAd *interstitialAd;

@end

NS_ASSUME_NONNULL_END
