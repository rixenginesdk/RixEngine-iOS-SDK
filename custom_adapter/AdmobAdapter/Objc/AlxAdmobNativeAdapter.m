//
//  AlxAdmobNativeAdapter.m
//  AlxAdsOCDemo
//

#import "AlxAdmobNativeAdapter.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"AlxAdmobNativeAdapter";

@interface AlxAdmobNativeAdapter () <AlxNativeAdLoaderDelegate, AlxNativeAdDelegate>

@property (nonatomic, weak, nullable) id<GADMediationNativeAdEventDelegate> delegate;
@property (nonatomic, strong, nullable) AlxNativeAd *nativeAd;
@property (nonatomic, copy, nullable) GADMediationNativeLoadCompletionHandler completionHandler;

@property (nonatomic, strong, nullable) NSArray<GADNativeAdImage *> *images;
@property (nonatomic, strong, nullable) GADNativeAdImage *icon;

@end

@implementation AlxAdmobNativeAdapter

#pragma mark - GADMediationNativeAd Properties

- (nullable NSString *)headline {
    return self.nativeAd.title;
}

- (nullable NSArray<GADNativeAdImage *> *)images {
    return _images;
}

- (nullable NSString *)body {
    return self.nativeAd.desc;
}

- (nullable GADNativeAdImage *)icon {
    return _icon;
}

- (nullable NSString *)callToAction {
    return self.nativeAd.callToAction;
}

- (nullable NSDecimalNumber *)starRating {
    return nil;
}

- (nullable NSString *)store {
    return nil;
}

- (nullable NSString *)price {
    double priceValue = [self.nativeAd getPrice];
    if (priceValue > 0) {
        return [NSString stringWithFormat:@"%.2f", priceValue];
    }
    return nil;
}

- (nullable NSString *)advertiser {
    return self.nativeAd.adSource;
}

- (nullable NSDictionary<NSString *, id> *)extraAssets {
    return nil;
}

#pragma mark - Load

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    NSLog(@"%@: loadNativeAd", TAG);
    
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
    
    NSLog(@"%@: loadNativeAd unitid=%@", TAG, adId);
    self.completionHandler = completionHandler;
    
    // Load ad
    AlxNativeAdLoader *loader = [[AlxNativeAdLoader alloc] initWithAdUnitID:adId];
    loader.delegate = self;
    [loader loadAd];
}

- (void)didRenderInView:(UIView *)view
    clickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
 nonclickableAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
         viewController:(UIViewController *)viewController {
    self.nativeAd.rootViewController = viewController;
    [self.nativeAd registerViewWithContainer:view clickableViews:clickableAssetViews.allValues closeView:nil];
}

- (BOOL)handlesUserClicks {
    return YES;
}

- (BOOL)handlesUserImpressions {
    return YES;
}

#pragma mark - Private Methods

- (void)downloadImagesWithNativeAd:(AlxNativeAd *)nativeAd completion:(void (^)(void))completion {
    // Download icon
    if (nativeAd.icon && nativeAd.icon.url) {
        NSURL *url = [NSURL URLWithString:nativeAd.icon.url];
        if (url) {
            CGFloat scale = nativeAd.icon.height == 0 ? 0 : (CGFloat)nativeAd.icon.width / (CGFloat)nativeAd.icon.height;
            _icon = [[GADNativeAdImage alloc] initWithURL:url scale:scale];
        }
    }
    
    // Download main image
    if (nativeAd.images.firstObject && nativeAd.images.firstObject.url) {
        NSString *imageUrl = nativeAd.images.firstObject.url;
        [self downloadImageAsync:imageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                self->_images = @[[[GADNativeAdImage alloc] initWithImage:image]];
            }
            completion();
        }];
    } else {
        completion();
    }
}

- (void)downloadImageAsync:(NSString *)urlString completion:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        completion(nil, [self errorWithCode:-101 msg:@"Image URL is invalid"]);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil, [self errorWithCode:-103 msg:error.localizedDescription]);
            } else if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    completion(image, nil);
                } else {
                    completion(nil, [self errorWithCode:-102 msg:@"Error while creating UIImage from received data"]);
                }
            } else {
                completion(nil, [self errorWithCode:-102 msg:@"No data received"]);
            }
        });
    });
}

#pragma mark - AlxNativeAdLoaderDelegate

- (void)nativeAdFailToLoadWithDidFailWithError:(NSError *)error {
    NSLog(@"%@: nativeAdFailToLoad", TAG);
    if (self.completionHandler) {
        self.delegate = self.completionHandler(nil, error);
    }
}

- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> *)ads {
    NSLog(@"%@: nativeAdLoaded", TAG);
    
    if (!ads.firstObject) {
        if (self.completionHandler) {
            NSString *errorStr = @"native ad data is empty";
            NSLog(@"%@: native ad data is empty", TAG);
            self.delegate = self.completionHandler(nil, [self errorWithCode:-100 msg:errorStr]);
        }
        return;
    }
    
    self.nativeAd = ads.firstObject;
    self.nativeAd.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [self downloadImagesWithNativeAd:self.nativeAd completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (strongSelf.completionHandler) {
            strongSelf.delegate = strongSelf.completionHandler(strongSelf, nil);
        }
    }];
}

#pragma mark - AlxNativeAdDelegate

- (void)nativeAdImpression:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdImpression", TAG);
    [self.delegate reportImpression];
}

- (void)nativeAdClick:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClick", TAG);
    [self.delegate reportClick];
}

- (void)nativeAdClose:(AlxNativeAd *)nativeAd {
    NSLog(@"%@: nativeAdClose", TAG);
    [self.delegate didDismissFullScreenView];
}

@end
