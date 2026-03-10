//
//  AlxTopOnRewardVideoDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnRewardVideoDelegate : NSObject <AlxRewardVideoAdDelegate>

@property (nonatomic, strong) ATRewardedAdStatusBridge *adStatusBridge;
@property (nonatomic, weak) AlxRewardVideoAd *rewardedAd;  // 保存广告对象引用

@end

NS_ASSUME_NONNULL_END
