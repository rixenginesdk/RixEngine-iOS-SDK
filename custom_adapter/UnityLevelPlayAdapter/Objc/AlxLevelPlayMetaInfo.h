//
//  AlxLevelPlayMetaInfo.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// LevelPlay (IronSource) 适配器元信息
@interface AlxLevelPlayMetaInfo : NSObject

/// 适配器版本号
@property (class, nonatomic, copy, readonly) NSString *ADAPTER_VERSION;

/// 网络名称（与 LevelPlay 平台注册时的名称一致）
@property (class, nonatomic, copy, readonly) NSString *NETWORK_NAME;

@end

NS_ASSUME_NONNULL_END
