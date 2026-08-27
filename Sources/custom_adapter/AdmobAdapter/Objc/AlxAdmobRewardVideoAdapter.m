//
//  AlxAdmobRewardVideoAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobRewardVideoAdapter.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"AlxAdmobRewardVideoAdapter";

@interface AlxAdmobRewardVideoAdapter () <AlxRewardVideoAdDelegate>

@property (nonatomic, strong, nullable) AlxRewardVideoAd *rewardedAd;
@property (nonatomic, weak, nullable) id<GADMediationRewardedAdEventDelegate> delegate;
@property (nonatomic, copy, nullable) GADMediationRewardedLoadCompletionHandler completionHandler;

@end

@implementation AlxAdmobRewardVideoAdapter

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    NSLog(@"%@: loadRewardedAd", TAG);
    
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
    
    NSLog(@"%@: loadRewardedAd unitid=%@", TAG, adId);
    self.completionHandler = completionHandler;
    
    // Load ad
    self.rewardedAd = [[AlxRewardVideoAd alloc] init];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAdWithAdUnitId:adId];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    NSLog(@"%@: present", TAG);
    if (self.rewardedAd && [self.rewardedAd isReady]) {
        [self.rewardedAd showAdWithPresent:viewController];
    }
}

#pragma mark - AlxRewardVideoAdDelegate

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(self, nil);
    }
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(nil, error);
    }
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdImpression", TAG);
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClick", TAG);
    [self.delegate reportClick];
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClose", TAG);
    [self.delegate didDismissFullScreenView];
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayStart", TAG);
    [self.delegate didStartVideo];
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayEnd", TAG);
    [self.delegate didEndVideo];
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdReward", TAG);
    [self.delegate didRewardUser];
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdPlayFail", TAG);
}

@end
