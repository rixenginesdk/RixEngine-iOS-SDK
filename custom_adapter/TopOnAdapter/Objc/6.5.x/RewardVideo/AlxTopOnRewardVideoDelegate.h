//
//  AlxTopOnRewardVideoDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnRewardVideoDelegate : NSObject <AlxRewardVideoAdDelegate>

@property (nonatomic, strong) ATRewardedAdStatusBridge *adStatusBridge;
/**
 * 保存广告对象引用。
 * Save ad object reference.
 */
@property (nonatomic, weak) AlxRewardVideoAd *rewardedAd;

@end

NS_ASSUME_NONNULL_END
