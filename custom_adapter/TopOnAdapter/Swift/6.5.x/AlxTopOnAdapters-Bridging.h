//
//  AlxTopOnAdapters-Bridging.h
//  AlxAdsDemo
//
//  Swift 适配器的 OC 桥接头文件 / OC bridging header for Swift adapters
//

#import <Foundation/Foundation.h>

// 此文件用于将 Swift 适配器暴露给 Objective-C 运行时 / This file is used to expose Swift adapters to the Objective-C runtime
// TopOn SDK 通过类名字符串反射实例化适配器时需要这些声明 / TopOn SDK requires these declarations when instantiating adapters via class name string reflection

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
