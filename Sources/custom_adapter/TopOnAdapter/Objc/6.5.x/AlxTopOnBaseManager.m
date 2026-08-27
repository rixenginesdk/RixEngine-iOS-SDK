//
//  AlxTopOnBaseManager.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBaseManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AlxAds/AlxAds.h>
#import "AlxTopOnMetaInfo.h"

static NSString *const TAG = @"AlxTopOnBaseManager";
static BOOL _isInitialized = NO;

@implementation AlxTopOnBaseManager

+ (void)setIsInitialized:(BOOL)isInitialized {
    _isInitialized = isInitialized;
}

+ (BOOL)isInitialized {
    return _isInitialized;
}

+ (NSString *)unitID {
    return @"slot_id";
}

+ (NSString *)initSDKWithServerInfo:(NSDictionary *)serverInfo {
    NSLog(@"%@: alx-sdk-version:%@", TAG, [AlxSdk getSDKVersion]);
    NSLog(@"%@: topon-sdk-version:%@", TAG, [[ATAPI sharedInstance] version]);
    NSLog(@"%@: topon-adapter-version:%@", TAG, [AlxTopOnMetaInfo ADAPTER_VERSION]);
    
    NSString *appid = serverInfo[@"appid"];
    NSString *sid = serverInfo[@"sid"];
    NSString *token = serverInfo[@"token"];
    NSString *debug = serverInfo[@"isdebug"];
    
    NSLog(@"%@: token=%@; appid=%@; sid=%@", TAG, token ?: @"", appid ?: @"", sid ?: @"");
    
    if (!appid || !sid || !token) {
        NSString *errorStr = @"initialize alx params: appid or sid or token is empty";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return errorStr;
    }
    
    [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
    [self setIsInitialized:YES];
    [self sdkInfo];
    
    if (debug.length > 0) {
        if ([debug.lowercaseString isEqualToString:@"true"]) {
            [AlxSdk setDebug:YES];
        } else if ([debug.lowercaseString isEqualToString:@"false"]) {
            [AlxSdk setDebug:NO];
        }
    }
    
    // User Privacy - GDPR Consent Handling
    NSInteger gdprFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"IABTCF_gdprApplies"];
    NSString *gdprConsent = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_TCString"];
    
    if (gdprFlag == 1) {
        [AlxSdk setGDPRConsent:YES];
    } else {
        [AlxSdk setGDPRConsent:NO];
    }
    [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
    
    return nil;
}

+ (void)sdkInfo {
    NSDictionary *data = @{
        @"sdk_name": @"TopOn",
        @"sdk_version": [[ATAPI sharedInstance] version],
        @"adapter_version": [AlxTopOnMetaInfo ADAPTER_VERSION]
    };
    [AlxSdk addExtraParametersWithKey:@"alx_adapter" value:data];
}

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:@"AlxTopOnAdapter"
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
