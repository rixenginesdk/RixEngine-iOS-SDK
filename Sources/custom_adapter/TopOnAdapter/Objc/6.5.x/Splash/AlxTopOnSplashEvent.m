//
//  AlxTopOnSplashEvent.m
//  AlxAdsOCDemo
//

#import "AlxTopOnSplashEvent.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBiddingRequestManager.h"

static NSString *const TAG = @"AlxTopOnSplashEvent";

@implementation AlxTopOnSplashEvent

- (instancetype)initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    self = [super initWithInfo:serverInfo localInfo:localInfo];
    return self;
}

- (void)splashAdDidLoad:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidLoad", TAG);
    if (self.isC2SBiding) {
        NSString *unitId = self.serverInfo[[AlxTopOnBaseManager unitID]];
        [AlxTopOnBiddingRequestManager disposeLoadSuccessWithPrice:[ad getPrice] unitID:unitId];
        self.isC2SBiding = NO;
    } else {
        NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
        adExtra[kATAdAssetsCustomObjectKey] = ad;
        [self trackSplashAdLoaded:ad adExtra:adExtra];
    }
}

- (void)splashAdDidFailToLoad:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdDidFailToLoad: %@", TAG, error.localizedDescription);
    if (self.isC2SBiding) {
        NSString *unitId = self.serverInfo[[AlxTopOnBaseManager unitID]];
        [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error unitID:unitId];
    } else {
        [self trackSplashAdLoadFailed:error];
    }
}

- (void)splashAdDidShow:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidShow", TAG);
    [self trackSplashAdShow];
}

- (void)splashAdDidClick:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClick", TAG);
    [self trackSplashAdClick];
}

- (void)splashAdDidClose:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClose", TAG);
    [self trackSplashAdClosed:nil];
}

- (void)splashAdRenderDidFail:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdRenderDidFail: %@", TAG, error.localizedDescription);
    [self trackSplashAdShowFailed:error];
}

- (void)splashAdCountdown:(AlxSplashAd *)ad countdown:(NSInteger)countdown {
    NSLog(@"%@: splashAdCountdown: %ld", TAG, (long)countdown);
    [self trackSplashAdCountdownTime:countdown];
}

- (NSString *)networkUnitId {
    return self.serverInfo[[AlxTopOnBaseManager unitID]] ?: @"";
}

- (void)dealloc {
    NSLog(@"%@: dealloc", TAG);
}

@end
