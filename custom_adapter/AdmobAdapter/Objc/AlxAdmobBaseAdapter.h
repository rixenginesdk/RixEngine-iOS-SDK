//
//  AlxAdmobBaseAdapter.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxAdmobBaseAdapter : NSObject <GADMediationAdapter>

@property (class, nonatomic, assign) BOOL isInitialized;

/**
 * 解析广告参数
 */
+ (nullable NSDictionary<NSString *, id> *)parseAdparameterFor:(GADMediationCredentials *)parameters;

/**
 * 初始化SDK
 */
+ (NSDictionary<NSString *, id> *)initSdkFor:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 * 创建错误对象
 */
- (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
