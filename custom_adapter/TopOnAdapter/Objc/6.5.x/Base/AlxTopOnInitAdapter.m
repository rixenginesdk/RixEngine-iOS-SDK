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
    NSString *appid = adInitArgument.serverContentDic[@"appid"];
    NSString *sid = adInitArgument.serverContentDic[@"sid"];
    NSString *token = adInitArgument.serverContentDic[@"token"];
    NSString *debug = adInitArgument.serverContentDic[@"isdebug"];
    
    NSLog(@"AlxTopOnInitAdapter: appid = %@, sid = %@, token = %@, debug = %@", appid, sid, token, debug);
    
    // 参数检查
    if (!appid || !sid || !token) {
        NSString *errorStr = @"initialize alx params: appid or sid or token is empty";
        NSLog(@"AlxTopOnInitAdapter: error: %@", errorStr);
        NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: errorStr}];
        // 通知 TopOn SDK 初始化失败
        [self notificationNetworkInitFail:error];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 初始化 Alx SDK
        [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
        
        // 设置调试模式
        if (debug.length > 0) {
            if ([debug.lowercaseString isEqualToString:@"true"]) {
                [AlxSdk setDebug:YES];
            } else if ([debug.lowercaseString isEqualToString:@"false"]) {
                [AlxSdk setDebug:NO];
            }
        }
        
        // 设置隐私合规
        NSInteger gdprFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"IABTCF_gdprApplies"];
        NSString *gdprConsent = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_TCString"];
        
        if (gdprFlag == 1) {
            [AlxSdk setGDPRConsent:YES];
        } else {
            [AlxSdk setGDPRConsent:NO];
        }
        [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
        
        // 记录SDK信息
        NSDictionary *data = @{
            @"sdk_name": @"TopOn",
            @"sdk_version": [[ATAPI sharedInstance] version] ?: @"",
            @"adapter_version": [self adapterVersion] ?: @""
        };
        [AlxSdk addExtraParametersWithKey:@"alx_adapter" value:data];
        
        NSLog(@"AlxTopOnInitAdapter: init success");
        // ⚠️ 注意：通知 TopOn SDK 初始化成功
        [self notificationNetworkInitSuccess];
    });
}

/// 返回广告平台SDK 的版本号
- (nullable NSString *)sdkVersion {
    //例如
    return AlxSdk.getSDKVersion;
}

/// 返回适配器版本号
- (nullable NSString *)adapterVersion {
    return @"1.3.0";
}


@end
