//
//  AlxTopOnBannerEvent.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBannerEvent.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBiddingRequestManager.h"

static NSString *const TAG = @"AlxTopOnBannerEvent";

@implementation AlxTopOnBannerEvent

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdLoad", TAG);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadSuccessWithPrice:[bannerView getPrice]
                                                            unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
        self.isC2SBiding = NO;
    } else {
        [self trackBannerAdLoaded:bannerView adExtra:nil];
    }
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSLog(@"%@ bannerViewAdFailToLoad: %@", TAG, error.localizedDescription);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error
                                                         unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
    } else {
        [self trackBannerAdLoadFailed:error];
    }
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdImpression", TAG);
    [self trackBannerAdImpression];
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClick", TAG);
    [self trackBannerAdClick];
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClose", TAG);
    [self trackBannerAdClosed];
}

- (NSString *)networkUnitId {
    return self.serverInfo[[AlxTopOnBaseManager unitID]] ?: @"";
}

@end
