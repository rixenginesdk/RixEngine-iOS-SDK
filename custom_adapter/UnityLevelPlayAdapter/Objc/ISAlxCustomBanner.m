//
//  ISAlxCustomBanner.m
//  AlxAdsOCDemo
//
//  LevelPlay Banner 广告适配器
//

#import "ISAlxCustomBanner.h"
#import <AlxAds/AlxAds-Swift.h>

static NSString *const TAG = @"ISAlxCustomBanner";

@interface ISAlxCustomBanner () <AlxBannerViewAdDelegate>
@property (nonatomic, strong, nullable) AlxBannerAdView *bannerAdView;
@property (nonatomic, weak, nullable) id<ISBannerAdDelegate> adDelegate;
@end

@implementation ISAlxCustomBanner

#pragma mark - ISBaseBanner

/// LevelPlay 请求加载 Banner 广告
/// adData.configuration 包含:
///   appid / sid / token (app 级) + unitid (instance 级)
- (void)loadAdWithAdData:(ISAdData *)adData
         viewController:(UIViewController *)viewController
                   size:(ISBannerSize *)size
               delegate:(id<ISBannerAdDelegate>)delegate {
    NSLog(@"%@: loadAd", TAG);
    self.adDelegate = delegate;

    [ISAlxCustomAdapter initSdkWithAdData:adData];

    NSString *unitId = adData.configuration[@"unitid"];
    if (!unitId || unitId.length == 0) {
        NSString *msg = @"unitid is empty";
        NSLog(@"%@: error: %@", TAG, msg);
        [delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                     errorCode:ISAdapterErrorMissingParams
                                  errorMessage:msg];
        return;
    }

    NSLog(@"%@: loadAd unitid=%@", TAG, unitId);

    CGSize adSize = [self bannerSizeFromISSize:size];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bannerAdView = [[AlxBannerAdView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
        self.bannerAdView.delegate = self;
        self.bannerAdView.refreshInterval = 0;
        self.bannerAdView.rootViewController = viewController;
        [self.bannerAdView loadAdWithAdUnitId:unitId];
    });
}

/// LevelPlay 销毁 Banner
- (void)destroyAdWithAdData:(ISAdData *)adData {
    NSLog(@"%@: destroyAd", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bannerAdView destroy];
        self.bannerAdView = nil;
    });
}

#pragma mark - AlxBannerViewAdDelegate

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdLoad", TAG);
    [self.adDelegate adDidLoadWithView:bannerView];
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSLog(@"%@: bannerViewAdFailToLoad: %@", TAG, error.localizedDescription);
    [self.adDelegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal
                                        errorCode:error.code
                                     errorMessage:error.localizedDescription];
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdImpression", TAG);
    [self.adDelegate adDidOpen];
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClick", TAG);
    [self.adDelegate adDidClick];
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@: bannerViewAdClose", TAG);
    [self.adDelegate adDidDismissScreen];
}

#pragma mark - Private

/// 将 LevelPlay ISBannerSize 映射为 CGSize
/// ⚠️ 此方法可能在后台线程调用，禁止访问 vc.view（UI API），改用 UIScreen
- (CGSize)bannerSizeFromISSize:(ISBannerSize *)size {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

    if ([size.sizeDescription isEqualToString:@"RECTANGLE"]) {
        return CGSizeMake(300, 250);
    } else if ([size.sizeDescription isEqualToString:@"LARGE"]) {
        return CGSizeMake(320, 90);
    } else if ([size.sizeDescription isEqualToString:@"SMART"] || [size.sizeDescription isEqualToString:@"BANNER"]) {
        return CGSizeMake(screenWidth, 50);
    }
    return CGSizeMake(320, 50);
}

@end
