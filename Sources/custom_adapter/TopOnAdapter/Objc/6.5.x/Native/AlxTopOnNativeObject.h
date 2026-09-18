//
//  AlxTopOnNativeObject.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class AlxTopOnNativeEvent;

@interface AlxTopOnNativeObject : ATCustomNetworkNativeAd

@property (nonatomic, strong) AlxNativeAd *nativeAd;
@property (nonatomic, weak) AlxTopOnNativeEvent *nativeEvent;
// ⚠️ 缓存 mediaView 实例，避免 TopOn SDK 多次调用时返回不同对象导致渲染异常
@property (nonatomic, strong, nullable) AlxMediaView *cachedMediaView;

@end

NS_ASSUME_NONNULL_END
