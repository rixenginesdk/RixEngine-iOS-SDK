//
//  AlxTopOnNativeDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

@class AlxTopOnNativeEvent;

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnNativeDelegate : NSObject <AlxNativeAdLoaderDelegate, AlxNativeAdDelegate>

@property (nonatomic, strong) ATNativeAdStatusBridge *adStatusBridge;
/**
 * 用于传递给 TopOn SDK。
 * For passing to TopOn SDK.
 */
@property (nonatomic, weak) AlxTopOnNativeEvent *nativeEvent;

@end

NS_ASSUME_NONNULL_END
