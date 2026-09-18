//
//  AlxTopOnSplashDelegate.m
//  AlxAdsOCDemo
//

#import "AlxTopOnSplashDelegate.h"

static NSString *const TAG = @"AlxTopOnSplashDelegate";

@implementation AlxTopOnSplashDelegate

#pragma mark - AlxSplashAdDelegate

- (void)splashAdDidLoad:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidLoad", TAG);
    self.splashAd = ad;

    double price = [ad getPrice];
    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];

    if (price > 0) {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        adExtra[ATAdSendC2SBidPriceKey] = priceStr;
        adExtra[ATAdSendC2SCurrencyTypeKey] = @(ATBiddingCurrencyTypeUS);
        NSLog(@"%@: splashAdDidLoad: price = %@", TAG, priceStr);
    }

    adExtra[kATAdAssetsCustomObjectKey] = ad;
    [self notifySplashLoaded:adExtra];
}

- (void)splashAdDidFailToLoad:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdDidFailToLoad: %@", TAG, error.localizedDescription);
    [self notifyLoadFailed:error];
}

- (void)splashAdDidShow:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidShow", TAG);
    [self notifyAdShow];
}

- (void)splashAdDidClick:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClick", TAG);
    [self notifyAdClick];
}

- (void)splashAdDidClose:(AlxSplashAd *)ad {
    NSLog(@"%@: splashAdDidClose", TAG);
    [self notifyAdClosed];
}

- (void)splashAdRenderDidFail:(AlxSplashAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@: splashAdRenderDidFail: %@", TAG, error.localizedDescription);
    [self notifyAdShowFailed:error];
}

- (void)splashAdCountdown:(AlxSplashAd *)ad countdown:(NSInteger)countdown {
    NSLog(@"%@: splashAdCountdown: %ld", TAG, (long)countdown);
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnSplashAdCountdownTime:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:@(countdown)];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - Helper Notifications

- (void)notifySplashLoaded:(NSDictionary *)adExtra {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnSplashAdLoadedExtra:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:adExtra];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyLoadFailed:(NSError *)error {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdLoadFailed:adExtra:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:error withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyAdShow {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdShow:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyAdClick {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdClick:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyAdClosed {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdClosed:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyAdShowFailed:(NSError *)error {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdShowFailed:extra:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:error withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

@end
