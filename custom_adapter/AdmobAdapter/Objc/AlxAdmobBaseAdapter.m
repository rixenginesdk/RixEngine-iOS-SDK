//
//  AlxAdmobBaseAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobBaseAdapter.h"
#import <AlxAds/AlxAds-Swift.h>
#import "AlxAdmobMetaInfo.h"
#import "AlxAdmobNetworkExtras.h"

static NSString *const TAG = @"AlxAdmobBaseAdapter";
static NSString *const PARAMETER = @"parameter";

static BOOL _isInitialized = NO;

@implementation AlxAdmobBaseAdapter

#pragma mark - GADMediationAdapter

+ (GADVersionNumber)adapterVersion {
    NSArray<NSString *> *versionComponents = [AlxAdmobMetaInfo.ADAPTER_VERSION componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count >= 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)adSDKVersion {
    NSArray<NSString *> *versionComponents = [[AlxSdk getSDKVersion] componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count >= 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [AlxAdmobNetworkExtras class];
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    NSLog(@"%@: setUp", TAG);
    
    // This is where you will initialize the SDK that this custom event is built for.
    // Upon finishing the SDK initialization, call the completion handler with success.
    
    if (AlxAdmobBaseAdapter.isInitialized) {
        NSString *errorStr = @"The alx sdk has been initialized";
        NSLog(@"%@: %@", TAG, errorStr);
        completionHandler([NSError errorWithDomain:errorStr code:-100 userInfo:nil]);
        return;
    }
    
    for (GADMediationCredentials * credential in configuration.credentials) {
        NSDictionary<NSString *, id> *result = [AlxAdmobBaseAdapter initSdkFor:credential.settings];
        if ([result[@"success"] boolValue]) {
            completionHandler(nil);
            return;
        }
    }
    completionHandler(nil);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"%@: init", TAG);
    }
    return self;
}

#pragma mark - Parse Parameter

+ (nullable NSDictionary<NSString *, id> *)parseAdparameterFor:(GADMediationCredentials *)parameters {
    NSString *params = parameters.settings[PARAMETER];
    if (!params) {
        NSString *errorStr = @"The parameter field is not found in the adConfiguration object";
        NSLog(@"%@: %@", TAG, errorStr);
        return nil;
    }
    
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        NSLog(@"%@: parameter: Data obj is nil", TAG);
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@: parameter parse error: %@", TAG, error.localizedDescription);
        return nil;
    }
    
    return json;
}

#pragma mark - SDK Init

+ (NSDictionary<NSString *, id> *)initSdkFor:(nullable NSDictionary<NSString *, id> *)parameters {
    NSLog(@"%@: alx-sdk-version:%@", TAG, [AlxSdk getSDKVersion]);
    NSLog(@"%@: admob-sdk-version:%@", TAG, [self stringForVersionNumber:GADMobileAds.sharedInstance.versionNumber]);
    NSLog(@"%@: admob-adapter-version:%@", TAG, AlxAdmobMetaInfo.ADAPTER_VERSION);
    
    if (!parameters) {
        NSString *errorStr = @"initialize alx params is empty";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return @{@"success": @NO, @"error": errorStr};
    }
    
    // 从 parameters 中获取参数字符串
    NSString *paramsStr = parameters[@"parameter"];
    if (![paramsStr isKindOfClass:[NSString class]] || paramsStr.length == 0) {
        NSString *errorStr = @"parameter string is missing or not a string";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return @{@"success": @NO, @"error": errorStr};
    }
    
    // 将 JSON 字符串转换为 Data
    NSData *admobJSONData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    if (!admobJSONData) {
        NSString *errorStr = @"failed to convert parameter string to data";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return @{@"success": @NO, @"error": errorStr};
    }
    
    // 将 Data 转为 JSON 字典
    NSError *jsonError = nil;
    NSDictionary<NSString *, id> *paramsDict = [NSJSONSerialization JSONObjectWithData:admobJSONData options:0 error:&jsonError];
    if (![paramsDict isKindOfClass:[NSDictionary class]]) {
        NSString *errorStr = @"failed to parse parameter JSON";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return @{@"success": @NO, @"error": errorStr};
    }
    
    NSString *appid = paramsDict[@"appid"];
    NSString *sid = paramsDict[@"sid"];
    NSString *token = paramsDict[@"token"];
    NSString *debug = paramsDict[@"isdebug"];
    
    if (!appid || !sid || !token) {
        NSString *errorStr = @"initialize alx params: appid or sid or token is empty";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return @{@"success": @NO, @"error": errorStr};
    }
    
    NSLog(@"%@: token=%@; appid=%@; sid=%@", TAG, token, appid, sid);
    [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
    _isInitialized = YES;
    [self sdkInfo];
    
    if (debug && debug.length > 0) {
        if ([debug.lowercaseString isEqualToString:@"true"]) {
            [AlxSdk setDebug:YES];
        } else if ([debug.lowercaseString isEqualToString:@"false"]) {
            [AlxSdk setDebug:NO];
        }
    }
    
    // User Privacy
    // MARK: - GDPR Consent Handling
    NSInteger gdprFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"IABTCF_gdprApplies"];
    NSString *gdprConsent = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_TCString"];
    
    // tcf v2 consent
    if (gdprFlag == 1) {
        [AlxSdk setGDPRConsent:YES];
    } else {
        [AlxSdk setGDPRConsent:NO];
    }
    [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
    
    return @{@"success": @YES, @"error": @"ok"};
}

+ (void)sdkInfo {
    NSDictionary *data = @{
        @"sdk_name": @"Admob",
        @"sdk_version": [self stringForVersionNumber:GADMobileAds.sharedInstance.versionNumber],
        @"adapter_version": AlxAdmobMetaInfo.ADAPTER_VERSION
    };
    [AlxSdk addExtraParametersWithKey:@"alx_adapter" value:data];
}

+ (NSString *)stringForVersionNumber:(GADVersionNumber)version {
    return [NSString stringWithFormat:@"%ld.%ld.%ld",
            (long)version.majorVersion,
            (long)version.minorVersion,
            (long)version.patchVersion];
}

- (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg {
    return [NSError errorWithDomain:TAG
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: msg}];
}

#pragma mark - Property

+ (BOOL)isInitialized {
    return _isInitialized;
}

+ (void)setIsInitialized:(BOOL)isInitialized {
    _isInitialized = isInitialized;
}

@end
