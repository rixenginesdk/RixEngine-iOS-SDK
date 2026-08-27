//
//  AlxTopOnInterstitialEvent.m
//  AlxAdsOCDemo
//

#import "AlxTopOnInterstitialEvent.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBiddingRequestManager.h"

static NSString *const TAG = @"AlxTopOnInterstitialEvent";

@implementation AlxTopOnInterstitialEvent

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdLoad", TAG);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadSuccessWithPrice:[ad getPrice]
                                                            unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
        self.isC2SBiding = NO;
    } else {
        [self trackInterstitialAdLoaded:ad adExtra:nil];
    }
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdFailToLoad : %@", TAG, error.localizedDescription);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error
                                                         unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
    } else {
        [self trackInterstitialAdLoadFailed:error];
    }
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdImpression", TAG);
    [self trackInterstitialAdShow];
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClick", TAG);
    [self trackInterstitialAdClick];
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdClose", TAG);
    [self trackInterstitialAdClose:nil];
}

- (void)interstitialAdRenderFail:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: interstitialAdRenderFail", TAG);
}

- (void)interstitialAdVideoStart:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoStart", TAG);
    [self trackInterstitialAdVideoStart];
}

- (void)interstitialAdVideoEnd:(AlxInterstitialAd *)ad {
    NSLog(@"%@: interstitialAdVideoEnd", TAG);
    [self trackInterstitialAdVideoEnd];
}

- (NSString *)networkUnitId {
    return self.serverInfo[[AlxTopOnBaseManager unitID]] ?: @"";
}

- (void)dealloc {
    NSLog(@"%@: dealloc", TAG);
}

@end
