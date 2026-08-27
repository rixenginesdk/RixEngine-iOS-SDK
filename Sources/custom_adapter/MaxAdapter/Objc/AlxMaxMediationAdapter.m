//
//  AlxMaxMediationAdapter.m
//  AlxAdsOCDemo
//

#import "AlxMaxMediationAdapter.h"
#import <AlxAds/AlxAds.h>

static NSString *const TAG = @"AlxMaxMediationAdapter";
static NSString *const ADAPTER_VERSION = @"1.5.0";

#pragma mark - MaxAlxNativeAd

@interface MaxAlxNativeAd : MANativeAd
@property (nonatomic, strong) AlxNativeAd *nativeAd;
- (instancetype)initWithNativeAd:(AlxNativeAd *)nativeAd;
@end

@implementation MaxAlxNativeAd

- (instancetype)initWithNativeAd:(AlxNativeAd *)nativeAd {
    self = [super initWithFormat:MAAdFormat.native builderBlock:^(MANativeAdBuilder * _Nonnull builder) {
        builder.title = nativeAd.title;
        builder.body = nativeAd.desc;
        builder.callToAction = nativeAd.callToAction;
        builder.advertiser = nativeAd.adSource;
        
        if (nativeAd.icon.url) {
            NSURL *iconUrl = [NSURL URLWithString:nativeAd.icon.url];
            if (iconUrl) {
                builder.icon = [[MANativeAdImage alloc] initWithURL:iconUrl];
            }
        }
        
        if (nativeAd.mediaContent) {
            AlxMediaView *mediaView = [[AlxMediaView alloc] init];
            [mediaView setMediaContent:nativeAd.mediaContent];
            builder.mediaView = mediaView;
        }
        
        AlxNativeAdImage *mainImage = nativeAd.images.firstObject;
        if (mainImage.url) {
            NSURL *imageUrl = [NSURL URLWithString:mainImage.url];
            if (imageUrl) {
                builder.mainImage = [[MANativeAdImage alloc] initWithURL:imageUrl];
            }
        }
    }];
    
    if (self) {
        self.nativeAd = nativeAd;
    }
    return self;
}

- (BOOL)prepareForInteractionClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container {
    [self.nativeAd registerViewWithContainer:container clickableViews:clickableViews];
    return [super prepareForInteractionClickableViews:clickableViews withContainer:container];
}

@end

#pragma mark - AlxMaxMediationAdapter

@interface AlxMaxMediationAdapter () <AlxBannerViewAdDelegate, AlxInterstitialAdDelegate, AlxRewardVideoAdDelegate, AlxNativeAdLoaderDelegate, AlxNativeAdDelegate>

@property (nonatomic, strong, nullable) AlxBannerAdView *bannerAd;
@property (nonatomic, weak, nullable) id<MAAdViewAdapterDelegate> bannerAdDelegate;

@property (nonatomic, strong, nullable) AlxInterstitialAd *interstitialAd;
@property (nonatomic, weak, nullable) id<MAInterstitialAdapterDelegate> interstitialAdDelegate;

@property (nonatomic, strong, nullable) AlxRewardVideoAd *rewardedAd;
@property (nonatomic, weak, nullable) id<MARewardedAdapterDelegate> rewardedAdDelegate;

@property (nonatomic, weak, nullable) id<MANativeAdAdapterDelegate> nativeAdDelegate;
@property (nonatomic, strong, nullable) AlxNativeAd *nativeAd;
@property (nonatomic, strong, nullable) id<MAAdapterResponseParameters> nativeParameters;

@end

@implementation AlxMaxMediationAdapter

static BOOL isInitialized = NO;

- (void)initializeWithParameters:(id<MAAdapterInitializationParameters>)parameters completionHandler:(void (^)(MAAdapterInitializationStatus, NSString * _Nullable))completionHandler {
    NSLog(@"%@: initialize", TAG);
    NSLog(@"%@: max-sdk-version:%@", TAG, ALSdk.version);
    NSLog(@"%@: alx-max-adapter-version:%@", TAG, ADAPTER_VERSION);
    
    if ([self initSdkFor:parameters]) {
        completionHandler(MAAdapterInitializationStatusInitializedSuccess, nil);
    } else {
        completionHandler(MAAdapterInitializationStatusDoesNotApply, nil);
    }
}

#pragma mark - MAAdViewAdapter (Banner)

- (void)loadAdViewAdForParameters:(id<MAAdapterResponseParameters>)parameters adFormat:(MAAdFormat *)adFormat andNotify:(id<MAAdViewAdapterDelegate>)delegate {
    NSLog(@"%@: loadAdViewAd", TAG);
    if (!isInitialized) {
        [self initSdkFor:parameters];
    }
    
    NSString *adId = parameters.thirdPartyAdPlacementIdentifier;
    UIViewController *viewController = parameters.presentingViewController ?: [ALUtils topViewControllerFromKeyWindow];
    
    self.bannerAdDelegate = delegate;
    
    CGSize adSize = CGSizeMake(adFormat.adaptiveSize.width, adFormat.adaptiveSize.height);
    self.bannerAd = [[AlxBannerAdView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    self.bannerAd.delegate = self;
    self.bannerAd.refreshInterval = 0;
    self.bannerAd.rootViewController = viewController;
    [self.bannerAd loadAdWithAdUnitId:adId];
}

#pragma mark - MARewardedAdapter

- (void)loadRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    NSLog(@"%@: loadRewardedAd", TAG);
    if (!isInitialized) {
        [self initSdkFor:parameters];
    }
    
    NSString *adId = parameters.thirdPartyAdPlacementIdentifier;
    self.rewardedAdDelegate = delegate;
    
    self.rewardedAd = [[AlxRewardVideoAd alloc] init];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAdWithAdUnitId:adId];
}

- (void)showRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    NSLog(@"%@: showRewardedAd", TAG);
    UIViewController *viewController = parameters.presentingViewController ?: [ALUtils topViewControllerFromKeyWindow];
    
    if (self.rewardedAd && [self.rewardedAd isReady]) {
        [self.rewardedAd showAdWithPresent:viewController];
    } else {
        NSLog(@"%@: show reward is empty", TAG);
    }
}

#pragma mark - MAInterstitialAdapter

- (void)loadInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    NSLog(@"%@: loadInterstitialAd", TAG);
    if (!isInitialized) {
        [self initSdkFor:parameters];
    }
    
    NSString *adId = parameters.thirdPartyAdPlacementIdentifier;
    self.interstitialAdDelegate = delegate;
    
    self.interstitialAd = [[AlxInterstitialAd alloc] init];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdWithAdUnitId:adId];
}

- (void)showInterstitialAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MAInterstitialAdapterDelegate>)delegate {
    NSLog(@"%@: showInterstitialAd", TAG);
    UIViewController *viewController = parameters.presentingViewController ?: [ALUtils topViewControllerFromKeyWindow];
    
    if (self.interstitialAd && [self.interstitialAd isReady]) {
        [self.interstitialAd showAdWithPresent:viewController];
    } else {
        NSLog(@"%@: show interstitial is empty", TAG);
    }
}

#pragma mark - MANativeAdAdapter

- (void)loadNativeAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MANativeAdAdapterDelegate>)delegate {
    NSLog(@"%@: loadNativeAd", TAG);
    if (!isInitialized) {
        [self initSdkFor:parameters];
    }
    
    NSString *adId = parameters.thirdPartyAdPlacementIdentifier;
    self.nativeParameters = parameters;
    self.nativeAdDelegate = delegate;
    
    AlxNativeAdLoader *loader = [[AlxNativeAdLoader alloc] initWithAdUnitID:adId];
    loader.delegate = self;
    [loader loadAd];
}

#pragma mark - Lifecycle

- (void)destroy {
    NSLog(@"%@: destroy", TAG);
    self.bannerAd = nil;
    self.bannerAdDelegate = nil;
    
    self.interstitialAd = nil;
    self.interstitialAdDelegate = nil;
    
    self.rewardedAd = nil;
    self.rewardedAdDelegate = nil;
    
    self.nativeAdDelegate = nil;
    self.nativeAd = nil;
    self.nativeParameters = nil;
    
    [super destroy];
}

- (NSString *)sdkVersion {
    NSLog(@"%@: sdkVersion", TAG);
    return [AlxSdk getSDKVersion];
}

- (NSString *)adapterVersion {
    NSLog(@"%@: adapterVersion", TAG);
    return ADAPTER_VERSION;
}

#pragma mark - Private Methods

- (void)sdkInfo {
    NSDictionary *data = @{
        @"sdk_name": @"Max",
        @"sdk_version": ALSdk.version,
        @"adapter_version": ADAPTER_VERSION
    };
    [AlxSdk addExtraParametersWithKey:@"alx_adapter" value:data];
}

- (BOOL)initSdkFor:(id<MAAdapterParameters>)parameters {
    NSDictionary *params = parameters.customParameters;
    NSString *appid = params[@"appid"];
    NSString *sid = params[@"sid"];
    NSString *token = params[@"token"];
    NSString *debug = params[@"isdebug"];
    
    if (!appid || !sid || !token) {
        NSString *errorStr = @"initialize alx params: appid or sid or token is empty";
        NSLog(@"%@: error: %@", TAG, errorStr);
        return NO;
    }
    
    NSLog(@"%@: token=%@; appid=%@; sid=%@", TAG, token, appid, sid);
    [AlxSdk initializeSDKWithToken:token sid:sid appId:appid];
    isInitialized = YES;
    [self sdkInfo];
    
    if (debug.length > 0) {
        if ([debug.lowercaseString isEqualToString:@"true"]) {
            [AlxSdk setDebug:YES];
        } else if ([debug.lowercaseString isEqualToString:@"false"]) {
            [AlxSdk setDebug:NO];
        }
    }
    
    // Set extra params
    NSDictionary *settings = ALSdk.shared.settings.extraParameters;
    for (NSString *key in settings) {
        id value = settings[key];
        NSLog(@"%@: max extra parameters: key= %@,value=%@", TAG, key, value);
        [AlxSdk addExtraParametersWithKey:key value:value];
    }
    
    // User Privacy - GDPR Consent Handling
    NSInteger gdprFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"IABTCF_gdprApplies"];
    NSString *gdprConsent = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_TCString"];
    
    if (gdprFlag == 1) {
        [AlxSdk setGDPRConsent:YES];
        [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
    } else {
        if ([ALPrivacySettings hasUserConsent]) {
            [AlxSdk setGDPRConsent:YES];
            if (parameters.consentString) {
                [AlxSdk setGDPRConsentMessage:parameters.consentString];
            } else if (gdprConsent) {
                [AlxSdk setGDPRConsentMessage:gdprConsent];
            }
        } else {
            [AlxSdk setGDPRConsent:NO];
            [AlxSdk setGDPRConsentMessage:gdprConsent ?: @""];
        }
    }
    
    // CCPA Handling (US Privacy)
    [AlxSdk setCCPA:[ALPrivacySettings isDoNotSell] ? @"1" : @"0"];
    
    return YES;
}

#pragma mark - AlxBannerViewAdDelegate

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdLoad", TAG);
    [self.bannerAdDelegate didLoadAdForAdView:bannerView];
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSLog(@"%@: bannerViewAdFailToLoad: %@", TAG, error.localizedDescription);
    MAAdapterError *adapterError = [MAAdapterError errorWithCode:error.code errorString:error.localizedDescription];
    [self.bannerAdDelegate didFailToLoadAdViewAdWithError:adapterError];
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdImpression", TAG);
    [self.bannerAdDelegate didDisplayAdViewAd];
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClick", TAG);
    [self.bannerAdDelegate didClickAdViewAd];
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClose", TAG);
    [self.bannerAdDelegate didHideAdViewAd];
}

#pragma mark - AlxInterstitialAdDelegate

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdLoad", TAG);
    [self.interstitialAdDelegate didLoadInterstitialAd];
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToLoad : %@", TAG, error.localizedDescription);
    MAAdapterError *adapterError = [MAAdapterError errorWithCode:error.code errorString:error.localizedDescription];
    [self.interstitialAdDelegate didFailToLoadInterstitialAdWithError:adapterError];
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdImpression", TAG);
    [self.interstitialAdDelegate didDisplayInterstitialAd];
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClick", TAG);
    [self.interstitialAdDelegate didClickInterstitialAd];
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClose", TAG);
    [self.interstitialAdDelegate didHideInterstitialAd];
}

- (void)interstitialAdRenderFail:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdRenderFail", TAG);
}

- (void)interstitialAdVideoStart:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoStart", TAG);
}

- (void)interstitialAdVideoEnd:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoEnd", TAG);
}

#pragma mark - AlxRewardVideoAdDelegate

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    [self.rewardedAdDelegate didLoadRewardedAd];
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdFailToLoad: %@", TAG, error.localizedDescription);
    MAAdapterError *adapterError = [MAAdapterError errorWithCode:error.code errorString:error.localizedDescription];
    [self.rewardedAdDelegate didFailToLoadRewardedAdWithError:adapterError];
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdImpression", TAG);
    [self.rewardedAdDelegate didDisplayRewardedAd];
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClick", TAG);
    [self.rewardedAdDelegate didClickRewardedAd];
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClose", TAG);
    [self.rewardedAdDelegate didHideRewardedAd];
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayStart", TAG);
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayEnd", TAG);
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdReward", TAG);
    [self.rewardedAdDelegate didRewardUserWithReward:[MAReward reward]];
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdPlayFail", TAG);
}

#pragma mark - AlxNativeAdLoaderDelegate

/**
 * Swift 协议 func nativeAdLoaded(didReceive:) 桥接到 OC 后 selector 为 nativeAdLoadedWithDidReceive:。
 * Swift protocol func nativeAdLoaded(didReceive:) is bridged to OC with selector nativeAdLoadedWithDidReceive:.
 */
- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> *)ads {
    NSLog(@"%@: nativeAdLoaded", TAG);
    
    AlxNativeAd *nativeAd = ads.firstObject;
    if (!nativeAd) {
        [self.nativeAdDelegate didFailToLoadNativeAdWithError:MAAdapterError.noFill];
        return;
    }
    
    self.nativeAd = nativeAd;
    
    MaxAlxNativeAd *maxNativeAd = [[MaxAlxNativeAd alloc] initWithNativeAd:nativeAd];
    UIViewController *viewController = self.nativeParameters.presentingViewController ?: [ALUtils topViewControllerFromKeyWindow];
    
    nativeAd.delegate = self;
    nativeAd.rootViewController = viewController;
    [self.nativeAdDelegate didLoadAdForNativeAd:maxNativeAd withExtraInfo:nil];
}

/**
 * Swift 协议 func nativeAdFailToLoad(didFailWithError:) 桥接到 OC 后 selector 为 nativeAdFailToLoadWithDidFailWithError:。
 * Swift protocol func nativeAdFailToLoad(didFailWithError:) is bridged to OC with selector nativeAdFailToLoadWithDidFailWithError:.
 */
- (void)nativeAdFailToLoadWithDidFailWithError:(NSError *)error {
    NSLog(@"%@: nativeAdFailToLoad", TAG);
    MAAdapterError *adapterError = [MAAdapterError errorWithCode:error.code errorString:error.localizedDescription];
    [self.nativeAdDelegate didFailToLoadNativeAdWithError:adapterError];
}

#pragma mark - AlxNativeAdDelegate

- (void)nativeAdImpression:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdImpression", TAG);
    [self.nativeAdDelegate didDisplayNativeAdWithExtraInfo:nil];
}

- (void)nativeAdClick:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClick", TAG);
    [self.nativeAdDelegate didClickNativeAd];
}

- (void)nativeAdClose:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClose", TAG);
}

@end
