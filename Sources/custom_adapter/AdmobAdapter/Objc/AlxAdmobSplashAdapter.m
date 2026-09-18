//
//  AlxAdmobSplashAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobSplashAdapter.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"AlxAdmobSplashAdapter";

@interface AlxAdmobSplashAdapter () <AlxSplashAdDelegate>

@property (nonatomic, strong, nullable) AlxSplashAd *splashAd;
@property (nonatomic, weak, nullable) id<GADMediationAppOpenAdEventDelegate> delegate;
@property (nonatomic, copy, nullable) GADMediationAppOpenLoadCompletionHandler completionHandler;

@end

@implementation AlxAdmobSplashAdapter

- (void)loadAppOpenAdForAdConfiguration:(GADMediationAppOpenAdConfiguration *)adConfiguration
                      completionHandler:(GADMediationAppOpenLoadCompletionHandler)completionHandler {
    NSLog(@"%@: loadAppOpenAd", TAG);

    NSDictionary *params = [AlxAdmobBaseAdapter parseAdparameterFor:adConfiguration.credentials];
    if (!params) {
        NSString *errorStr = @"The parameter field is not found in the adConfiguration object";
        NSLog(@"%@: config params is empty", TAG);
        self.delegate = completionHandler(nil, [self errorWithCode:-100 msg:errorStr]);
        return;
    }

    if (!AlxAdmobBaseAdapter.isInitialized) {
        [AlxAdmobBaseAdapter initSdkFor:params];
    }

    NSString *adId = params[@"unitid"];
    if (!adId || adId.length == 0) {
        NSString *errorStr = @"unitid is empty in the parameter configuration";
        NSLog(@"%@: error: %@", TAG, errorStr);
        self.delegate = completionHandler(nil, [self errorWithCode:-100 msg:errorStr]);
        return;
    }

    NSLog(@"%@: loadAppOpenAd unitid=%@", TAG, adId);
    self.completionHandler = completionHandler;

    BOOL autoClose = NO;
    if (params[@"autoCloseOnFinish"]) {
        autoClose = [params[@"autoCloseOnFinish"] boolValue];
    } else if (params[@"auto_close"]) {
        autoClose = [params[@"auto_close"] boolValue];
    } else if (params[@"is_auto_close"]) {
        autoClose = [params[@"is_auto_close"] boolValue];
    }

    self.splashAd = [[AlxSplashAd alloc] init];
    self.splashAd.delegate = self;
    self.splashAd.autoCloseOnFinish = autoClose;

    AlxAdRequest *req = [[[AlxAdRequest alloc] init] withUserExt:@{ @"bid_floor": @"1.68" }];
    [self.splashAd loadAdWithAdUnitId:adId request:req];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    NSLog(@"%@: present", TAG);
    if (self.splashAd && [self.splashAd isReady]) {
        [self.splashAd showAdWithPresent:viewController];
    } else {
        NSString *errorStr = @"Splash ad is not ready to present";
        NSLog(@"%@: error: %@", TAG, errorStr);
        [self.delegate didFailToPresentWithError:[self errorWithCode:-101 msg:errorStr]];
    }
}

#pragma mark - AlxSplashAdDelegate

- (void)splashAdDidLoad:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(self, nil);
    }
}

- (void)splashAdDidFailToLoad:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdDidFailToLoad: %@", TAG, error.localizedDescription);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(nil, error);
    }
}

- (void)splashAdDidShow:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidShow", TAG);
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
}

- (void)splashAdDidClick:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClick", TAG);
    [self.delegate reportClick];
}

- (void)splashAdDidClose:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClose", TAG);
    [self.delegate didDismissFullScreenView];
}

- (void)splashAdRenderDidFail:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdRenderDidFail: %@", TAG, error.localizedDescription);
    [self.delegate didFailToPresentWithError:error];
}

@end
