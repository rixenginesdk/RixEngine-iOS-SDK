//
//  AlxTopOnBaseAdapter.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxTopOnAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^AlxTopOnBindBiddingAdBlock)(id<AlxAdDelegate> ad);

/// AlxAds TopOn 基础适配器，负责初始化配置及 C2S 竞胜/竞败通知转发
@interface AlxTopOnBaseAdapter : ATBaseMediationAdapter

/// 开始新的竞价请求并重置竞价通知状态
- (AlxTopOnBindBiddingAdBlock)beginBiddingRequestWithArgument:(nullable ATAdMediationArgument *)argument;

/// 根据 TopOn 请求参数构建 AlxAdRequest（仅在传入底价时附带 bid_floor）
- (AlxAdRequest *)buildAdRequestWithArgument:(nullable ATAdMediationArgument *)argument;

@end

NS_ASSUME_NONNULL_END
