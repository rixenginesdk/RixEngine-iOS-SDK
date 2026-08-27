//
//  AlxTopOnNativeEvent.m
//  AlxAdsOCDemo
//

#import "AlxTopOnNativeEvent.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBiddingRequestManager.h"

static NSString *const TAG = @"AlxTopOnNativeEvent";

@implementation AlxTopOnNativeEvent

- (void)nativeAdImpression:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdImpression", TAG);
    [self trackNativeAdImpression];
}

- (void)nativeAdClick:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClick", TAG);
    [self trackNativeAdClick];
}

- (void)nativeAdClose:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClose", TAG);
    [self trackNativeAdClosed];
}

- (NSDictionary *)createAssetWithNativeAd:(AlxNativeAd *)nativeAd {
    NSMutableDictionary *assetDic = [NSMutableDictionary dictionary];
    assetDic[kATAdAssetsCustomEventKey] = self;
    assetDic[kATAdAssetsCustomObjectKey] = nativeAd;
    
    // 原生广告自渲染：数据添加 / Native ad self-rendering: populate data
    assetDic[kATNativeADAssetsIsExpressAdKey] = @NO;
    assetDic[kATNativeADAssetsMainTitleKey] = nativeAd.title ?: @"";
    assetDic[kATNativeADAssetsMainTextKey] = nativeAd.desc ?: @"";
    assetDic[kATNativeADAssetsIconURLKey] = nativeAd.icon.url ?: @"";
    assetDic[kATNativeADAssetsImageURLKey] = nativeAd.images.firstObject.url ?: @"";
    assetDic[kATNativeADAssetsCTATextKey] = nativeAd.callToAction ?: @"";
    assetDic[kATNativeADAssetsAdvertiserKey] = nativeAd.adSource ?: @"";
    assetDic[kATNativeADAssetsLogoImageKey] = nativeAd.adLogo ?: @"";
    assetDic[kATNativeADAssetsContainsVideoFlag] = @(nativeAd.createType == ATNativeADSourceTypeVideo);
    
    if (nativeAd.images.count == 1) {
        AlxNativeAdImage *mainImage = nativeAd.images.firstObject;
        assetDic[kATNativeADAssetsMainImageWidthKey] = @(mainImage.width);
        assetDic[kATNativeADAssetsMainImageHeightKey] = @(mainImage.height);
    }
    
    return [assetDic copy];
}

- (NSString *)networkUnitId {
    return self.serverInfo[[AlxTopOnBaseManager unitID]] ?: @"";
}

- (NSMutableArray *)assets {
    return [NSMutableArray arrayWithObject:self.assetDict ?: @{}];
}

- (void)nativeAdFailToLoadWithDidFailWithError:(NSError * _Nonnull)error { 
    NSLog(@"%@: nativeAdFailToLoad", TAG);
    if (self.isC2SBiding) {
        [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error
                                                         unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
    } else {
        [self trackNativeAdLoadFailed:error];
    }
}

- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> * _Nonnull)ads { 
    NSLog(@"%@: nativeAdLoaded", TAG);
    
    AlxNativeAd *nativeAd = ads.firstObject;
    if (!nativeAd) {
        NSString *errorStr = @"native ad data is empty";
        NSLog(@"%@: native ad data is empty", TAG);
        NSError *error = [AlxTopOnBaseManager errorWithCode:-100 message:errorStr];
        
        if (self.isC2SBiding) {
            [AlxTopOnBiddingRequestManager disposeLoadFailWithError:error
                                                             unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
        } else {
            [self trackNativeAdLoadFailed:error];
        }
        return;
    }
    
    NSDictionary *assetData = [self createAssetWithNativeAd:nativeAd];
    
    if (self.isC2SBiding) {
        self.assetDict = assetData;
        [AlxTopOnBiddingRequestManager disposeLoadSuccessWithPrice:[nativeAd getPrice]
                                                            unitID:self.serverInfo[[AlxTopOnBaseManager unitID]]];
        self.isC2SBiding = NO;
    } else {
        [self trackNativeAdLoaded:@[assetData]];
    }
}

@end
