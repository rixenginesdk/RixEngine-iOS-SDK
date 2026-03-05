//
//  AlxTopOnAdapters-Bridging.h
//  AlxAdsDemo
//
//  Swift 适配器的 OC 桥接头文件
//

#import <Foundation/Foundation.h>

// 此文件用于将 Swift 适配器暴露给 Objective-C 运行时
// TopOn SDK 通过类名字符串反射实例化适配器时需要这些声明

@interface AlxTopOnBannerAdapter : NSObject
@end

@interface AlxTopOnInterstitialAdapter : NSObject
@end

@interface AlxTopOnRewardVideoAdapter : NSObject
@end

@interface AlxTopOnNativeAdapter : NSObject
@end

@interface AlxTopOnBaseAdapter : NSObject
@end

@interface AlxTopOnInitAdapter : NSObject
@end
