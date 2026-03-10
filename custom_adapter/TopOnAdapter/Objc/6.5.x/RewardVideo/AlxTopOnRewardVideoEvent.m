//
//  AlxTopOnRewardVideoEvent.m
//  AlxAdsOCDemo
//

#import "AlxTopOnRewardVideoEvent.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBiddingRequestManager.h"

static NSString *const TAG = @"AlxTopOnRewardVideoEvent";

@implementation AlxTopOnRewardVideoEvent

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdLoad", TAG);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadSuccessWithPrice:[ad getPrice]
                                                            unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
        self.isC2SBiding = NO;
    } else {
        [self trackRewardedVideoAdLoaded:ad adExtra:nil];
    }
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdFailToLoad: %@", TAG, error.localizedDescription);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error
                                                         unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
    } else {
        [self trackRewardedVideoAdLoadFailed:error];
    }
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdImpression", TAG);
    [self trackRewardedVideoAdShow];
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClick", TAG);
    [self trackRewardedVideoAdClick];
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdClose", TAG);
    [self trackRewardedVideoAdCloseRewarded:YES extra:@{@"":@""}];
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayStart", TAG);
    [self trackRewardedVideoAdVideoStart];
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdPlayEnd", TAG);
    [self trackRewardedVideoAdVideoEnd];
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@: rewardVideoAdReward", TAG);
    [self trackRewardedVideoAdRewarded];
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: rewardVideoAdPlayFail", TAG);
//    [self trackRewardedVideoAdPlayFailed:error];
    [self trackRewardedVideoAdPlayEventWithError:error extra:@{@"":@""}];
}

- (NSString *)networkUnitId {
    return self.serverInfo[[AlxTopOnBaseManager unitID]] ?: @"";
}

- (void)dealloc {
    NSLog(@"%@: dealloc", TAG);
}

@end
