//
//  ISAlxCustomAdapter.h
//  AlxAdsOCDemo
//
//  LevelPlay (Unity IronSource) 自定义网络基础适配器
//  文档参考: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

/// AlxAds (RixEngine) LevelPlay 基础适配器
/// 负责 SDK 初始化、版本信息提供
@interface ISAlxCustomAdapter : ISBaseNetworkAdapter

/// SDK 是否已初始化
@property (class, nonatomic, assign) BOOL isInitialized;

/// 从 adData 中初始化 AlxAds SDK（幂等，仅首次生效）
+ (void)initSdkWithAdData:(ISAdData *)adData;

@end

NS_ASSUME_NONNULL_END
