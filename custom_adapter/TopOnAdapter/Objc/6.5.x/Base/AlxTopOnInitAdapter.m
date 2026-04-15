//
//  AlxTopOnInitAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnInitAdapter.h"
#import <AdSupport/AdSupport.h>
#import "AdConfig.h"

@implementation AlxTopOnInitAdapter

/// Init Ad SDK
/// - Parameter adInitArgument: server info
- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument {
    NSLog(@"AlxTopOnInitAdapter: initWithInitArgument");
    
    // 从adInitArgument对象中拿取后台配置的信息
    // Retrieve server-configured info from the adInitArgument object
    NSString *appid = adInitArgument.serverContentDic[@"appid"];
    NSString *sid = adInitArgument.serverContentDic[@"sid"];
    NSString *token = adInitArgument.serverContentDic[@"token"];
    NSString *debug = adInitArgument.serverContentDic[@"isdebug"];
    
    NSLog(@"AlxTopOnInitAdapter: appid = %@, sid = %@, token = %@, debug = %@", appid, sid, token, debug);
    
    // 参数检查 / Parameter validation
    if (!appid || !sid || !token) {
        NSString *errorStr = @"initialize alx params: appid or sid or token is empty";
        NSLog(@"AlxTopOnInitAdapter: error: %@", errorStr);
        NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: errorStr}];
        // 通知 TopOn SDK 初始化失败 / Notify TopOn SDK that initialization failed
        [self notificationNetworkInitFail:error];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 初始化 Alx SDK / Initialize Alx SDK
        [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
        
        // 设置调试模式 / Set debug mode
        if (debug.length > 0) {
            if ([debug.lowercaseString isEqualToString:@"true"]) {
                [AlxSdk setDebug:YES];
            } else if ([debug.lowercaseString isEqualToString:@"false"]) {
                [AlxSdk setDebug:NO];
            }
        }
        
        // 设置隐私合规 / Set privacy compliance
        NSInteger gdprFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"IABTCF_gdprApplies"];
        NSString *gdprConsent = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_TCString"];
        
        if (gdprFlag == 1) {
            [AlxSdk setGDPRConsent:YES];
        } else {
            [AlxSdk setGDPRConsent:NO];
        }
        [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
        
        // 记录SDK信息 / Record SDK info
        NSDictionary *data = @{
            @"sdk_name": @"TopOn",
            @"sdk_version": [[ATAPI sharedInstance] version] ?: @"",
            @"adapter_version": [self adapterVersion] ?: @""
        };
        [AlxSdk addExtraParametersWithKey:@"alx_adapter" value:data];
        
        NSLog(@"AlxTopOnInitAdapter: init success");
        // ⚠️ 注意：通知 TopOn SDK 初始化成功
        // ⚠️ Note: Notify TopOn SDK that initialization succeeded
        [self notificationNetworkInitSuccess];
    });
}

/**
 * 返回广告平台SDK的版本号。
 * Return the ad platform SDK version.
 */
- (nullable NSString *)sdkVersion {
    // 例如 / For example
    return AlxSdk.getSDKVersion;
}

/**
 * 返回适配器版本号。
 * Return the adapter version.
 */
- (nullable NSString *)adapterVersion {
    return @"1.3.0";
}


@end
