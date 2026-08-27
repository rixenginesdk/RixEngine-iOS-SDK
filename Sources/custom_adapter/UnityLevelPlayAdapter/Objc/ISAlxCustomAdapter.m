//
//  ISAlxCustomAdapter.m
//  AlxAdsOCDemo
//
//  LevelPlay (Unity IronSource) 自定义网络基础适配器 / LevelPlay (Unity IronSource) custom network base adapter
//  文档参考 / Documentation reference: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

#import "ISAlxCustomAdapter.h"
#import "AlxLevelPlayMetaInfo.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"ISAlxCustomAdapter";

@implementation ISAlxCustomAdapter

static BOOL _isInitialized = NO;

+ (BOOL)isInitialized {
    return _isInitialized;
}

+ (void)setIsInitialized:(BOOL)value {
    _isInitialized = value;
}

#pragma mark - ISBaseNetworkAdapter

/**
 * LevelPlay 会在初始化流程中调用此方法（可能被多次调用）。
 * LevelPlay calls this method during initialization flow (may be called multiple times).
 *
 * adData.configuration 包含 LevelPlay 平台配置的 app 级参数:
 * adData.configuration contains app-level parameters configured on the LevelPlay platform:
 *   appid / sid / token
 */
- (void)init:(ISAdData *)adData delegate:(id<ISNetworkInitializationDelegate>)delegate {
    NSLog(@"%@: init", TAG);

    NSString *appid = adData.configuration[@"appid"];
    NSString *sid   = adData.configuration[@"sid"];
    NSString *token = adData.configuration[@"token"];

    if (!appid || !sid || !token) {
        NSString *msg = @"init failed: appid / sid / token is empty";
        NSLog(@"%@: %@", TAG, msg);
        [delegate onInitDidFailWithErrorCode:ISAdapterErrorMissingParams
                               errorMessage:msg];
        return;
    }

    if (_isInitialized) {
        NSLog(@"%@: already initialized", TAG);
        [delegate onInitDidSucceed];
        return;
    }

    // 主线程初始化 AlxAds SDK / Initialize AlxAds SDK on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@: initializeSDK token=%@ sid=%@ appid=%@", TAG, token, sid, appid);
        [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
        _isInitialized = YES;
        NSLog(@"%@: initializeSDK success", TAG);
        [delegate onInitDidSucceed];
    });
}

#pragma mark - SDK & Adapter Versions

- (NSString *)networkSDKVersion {
    return [AlxSdk getSDKVersion];
}

- (NSString *)adapterVersion {
    return AlxLevelPlayMetaInfo.ADAPTER_VERSION;
}

#pragma mark - Shared Init Helper

+ (void)initSdkWithAdData:(ISAdData *)adData {
    if (_isInitialized) {
        return;
    }
    NSString *appid = adData.configuration[@"appid"];
    NSString *sid   = adData.configuration[@"sid"];
    NSString *token = adData.configuration[@"token"];
    if (!appid || !sid || !token) {
        NSLog(@"%@: initSdkWithAdData failed: missing params", TAG);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
        _isInitialized = YES;
        NSLog(@"%@: initSdkWithAdData success", TAG);
    });
}

@end
