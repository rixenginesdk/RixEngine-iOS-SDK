//
//  AlxTopOnBiddingRequestManager.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnTool.h"
#import "AlxTopOnBannerEvent.h"
#import "AlxTopOnInterstitialEvent.h"
#import "AlxTopOnRewardVideoEvent.h"
#import "AlxTopOnNativeEvent.h"
#import <AlxAds/AlxAds.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

static NSString *const TAG = @"AlxTopOnBiddingRequestManager";

@implementation AlxTopOnBiddingRequestManager

+ (instancetype)shared {
    static AlxTopOnBiddingRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AlxTopOnBiddingRequestManager alloc] init];
    });
    return instance;
}

- (void)startWithRequest:(AlxTopOnBiddingRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.adType == ATAdFormatInterstitial) {
            [self startLoadInterstitialAdWithRequest:request];
        } else if (request.adType == ATAdFormatRewardedVideo) {
            [self startLoadRewardedVideoAdWithRequest:request];
        } else if (request.adType == ATAdFormatNative) {
            [self startLoadNativeAdWithRequest:request];
        } else if (request.adType == ATAdFormatBanner) {
            [self startLoadBannerAdWithRequest:request];
        }
    });
}

- (void)startLoadInterstitialAdWithRequest:(AlxTopOnBiddingRequest *)request {
    NSString *unitID = request.unitID;
    if (!unitID || unitID.length == 0) {
        NSString *errorStr = @"unitid is empty";
        NSLog(@"%@: startLoadInterstitialAd: error= %@", TAG, errorStr);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"unitId is empty"]);
        }
        return;
    }
    NSLog(@"%@: startLoadInterstitialAd: unitid=%@", TAG, unitID);
    
    if (![request.customEvent isKindOfClass:[AlxTopOnInterstitialEvent class]]) {
        NSLog(@"%@: startLoadInterstitialAd: customEvent is empty", TAG);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"customEvent object is empty"]);
        }
        return;
    }
    
    AlxInterstitialAd *interstitialAd = [[AlxInterstitialAd alloc] init];
    interstitialAd.delegate = (id<AlxInterstitialAdDelegate>)request.customEvent;
    
    request.customObject = interstitialAd;
    [[AlxTopOnTool shared] saveRequestItem:request withUnitId:unitID];
    
    [interstitialAd loadAdWithAdUnitId:unitID];
}

- (void)startLoadRewardedVideoAdWithRequest:(AlxTopOnBiddingRequest *)request {
    NSString *unitID = request.unitID;
    if (!unitID || unitID.length == 0) {
        NSString *errorStr = @"unitid is empty";
        NSLog(@"%@: startLoadRewardedVideoAd: error= %@", TAG, errorStr);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"unitId is empty"]);
        }
        return;
    }
    NSLog(@"%@: startLoadRewardedVideoAd: unitid=%@", TAG, unitID);
    
    if (![request.customEvent isKindOfClass:[AlxTopOnRewardVideoEvent class]]) {
        NSLog(@"%@: startLoadRewardedVideoAd: customEvent is empty", TAG);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"customEvent object is empty"]);
        }
        return;
    }
    
    AlxRewardVideoAd *rewardedAd = [[AlxRewardVideoAd alloc] init];
    rewardedAd.delegate = (id<AlxRewardVideoAdDelegate>)request.customEvent;
    
    request.customObject = rewardedAd;
    [[AlxTopOnTool shared] saveRequestItem:request withUnitId:unitID];
    
    [rewardedAd loadAdWithAdUnitId:unitID];
}

- (void)startLoadNativeAdWithRequest:(AlxTopOnBiddingRequest *)request {
    NSString *unitID = request.unitID;
    if (!unitID || unitID.length == 0) {
        NSString *errorStr = @"unitid is empty";
        NSLog(@"%@: startLoadNativeAd: error= %@", TAG, errorStr);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"unitId is empty"]);
        }
        return;
    }
    NSLog(@"%@: startLoadNativeAd: unitid=%@", TAG, unitID);
    
    if (![request.customEvent isKindOfClass:[AlxTopOnNativeEvent class]]) {
        NSLog(@"%@: startLoadNativeAd: customEvent is empty", TAG);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"customEvent object is empty"]);
        }
        return;
    }
    
    AlxNativeAdLoader *nativeAd = [[AlxNativeAdLoader alloc] initWithAdUnitID:unitID];
    nativeAd.delegate = (id<AlxNativeAdLoaderDelegate>)request.customEvent;
    
    request.customObject = nativeAd;
    [[AlxTopOnTool shared] saveRequestItem:request withUnitId:unitID];
    
    [nativeAd loadAd];
}

- (void)startLoadBannerAdWithRequest:(AlxTopOnBiddingRequest *)request {
    NSString *unitID = request.unitID;
    if (!unitID || unitID.length == 0) {
        NSString *errorStr = @"unitid is empty";
        NSLog(@"%@: startLoadBannerAd: error= %@", TAG, errorStr);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"unitId is empty"]);
        }
        return;
    }
    NSLog(@"%@: startLoadBannerAd: unitid=%@", TAG, unitID);
    
    if (![request.customEvent isKindOfClass:[AlxTopOnBannerEvent class]]) {
        NSLog(@"%@: startLoadBannerAd: customEvent is empty", TAG);
        if (request.bidCompletion) {
            request.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"customEvent object is empty"]);
        }
        return;
    }
    
    CGSize adSize = CGSizeMake(320, 50);
    ATUnitGroupModel *unitGroupModel = request.extraInfo[kATAdapterCustomInfoUnitGroupModelKey];
    if (unitGroupModel) {
        adSize = unitGroupModel.adSize;
        NSLog(@"%@: loadAD: width=%.2f , height=%.2f", TAG, adSize.width, adSize.height);
    }
    
    AlxBannerAdView *bannerAd = [[AlxBannerAdView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    bannerAd.delegate = (id<AlxBannerViewAdDelegate>)request.customEvent;
    bannerAd.refreshInterval = 0;
    bannerAd.translatesAutoresizingMaskIntoConstraints = NO;
    
    request.customObject = bannerAd;
    [[AlxTopOnTool shared] saveRequestItem:request withUnitId:unitID];
    
    [bannerAd loadAdWithAdUnitId:unitID];
}

+ (void)disposeLoadSuccessWithPrice:(double)price unitID:(NSString *)unitID {
    NSLog(@"%@: disposeLoadSuccess", TAG);
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    
    if (!unitID) {
        NSLog(@"%@: disposeLoadSuccess: unitID is empty", TAG);
        return;
    }
    
    AlxTopOnBiddingRequest *bidRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:unitID];
    if (!bidRequest) {
        NSLog(@"%@: disposeLoadSuccess: bidRequest cache no found", TAG);
        return;
    }
    
    if (!bidRequest.placementID) {
        if (bidRequest.bidCompletion) {
            bidRequest.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"placementID is empty"]);
        }
        [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitID];
        return;
    }
    
    if (!bidRequest.unitGroup.unitID) {
        if (bidRequest.bidCompletion) {
            bidRequest.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"ATUnitGroupModel object: unitID is empty"]);
        }
        [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitID];
        return;
    }
    
    if (!bidRequest.unitGroup.adapterClassString) {
        if (bidRequest.bidCompletion) {
            bidRequest.bidCompletion(nil, [AlxTopOnBaseManager errorWithCode:-100 message:@"ATUnitGroupModel object: adapterClassString is empty"]);
        }
        [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitID];
        return;
    }
    
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:bidRequest.placementID
                                              unitGroupUnitID:bidRequest.unitGroup.unitID
                                           adapterClassString:bidRequest.unitGroup.adapterClassString
                                                        price:priceStr
                                                 currencyType:ATBiddingCurrencyTypeUS
                                           expirationInterval:bidRequest.unitGroup.bidTokenTime
                                                 customObject:bidRequest.customObject];
    bidInfo.networkFirmID = bidRequest.unitGroup.networkFirmID;
    
    NSLog(@"%@: disposeLoadSuccess: price=%@", TAG, bidInfo.price);
    NSLog(@"%@: disposeLoadSuccess: adapterClassString=%@", TAG, bidInfo.adapterClassString);
    NSLog(@"%@: disposeLoadSuccess: bidTokenTime=%@", TAG, bidInfo.expireDate);
    
    if (bidRequest.bidCompletion) {
        bidRequest.bidCompletion(bidInfo, nil);
        NSLog(@"%@: disposeLoadSuccess: bidCompletion is called successfully", TAG);
    } else {
        NSLog(@"%@: disposeLoadSuccess: bidCompletion is empty", TAG);
    }
}

+ (void)disposeLoadFailWithError:(NSError *)error unitID:(NSString *)unitID {
    NSLog(@"%@: disposeLoadFail", TAG);
    if (!unitID) {
        NSLog(@"%@: disposeLoadFail: unitID is empty", TAG);
        return;
    }
    
    AlxTopOnBiddingRequest *bidRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:unitID];
    if (!bidRequest) {
        NSLog(@"%@: disposeLoadFail: bidRequest cache no found", TAG);
        return;
    }
    
    if (bidRequest.bidCompletion) {
        bidRequest.bidCompletion(nil, error);
    }
    [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitID];
}

@end
