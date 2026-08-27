//
//  ISAlxCustomAdapter.h
//  AlxAdsOCDemo
//
//  LevelPlay (Unity IronSource) 自定义网络基础适配器 / LevelPlay (Unity IronSource) custom network base adapter
//  文档参考 / Documentation reference: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * AlxAds (RixEngine) LevelPlay 基础适配器。
 * AlxAds (RixEngine) LevelPlay base adapter.
 * 负责 SDK 初始化、版本信息提供。
 * Responsible for SDK initialization and providing version information.
 */
@interface ISAlxCustomAdapter : ISBaseNetworkAdapter

/**
 * SDK 是否已初始化。
 * Whether the SDK has been initialized.
 */
@property (class, nonatomic, assign) BOOL isInitialized;

/**
 * 从 adData 中初始化 AlxAds SDK（幂等，仅首次生效）。
 * Initialize AlxAds SDK from adData (idempotent, only takes effect on first call).
 */
+ (void)initSdkWithAdData:(ISAdData *)adData;

@end

NS_ASSUME_NONNULL_END
