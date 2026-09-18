//
//  AlxTopOnNativeObject.m
//  AlxAdsOCDemo
//

#import "AlxTopOnNativeObject.h"
#import "AlxTopOnNativeEvent.h"

@implementation AlxTopOnNativeObject

#pragma mark - ATCustomNetworkNativeAd Override Methods

// ⚠️ 注意：TopOn SDK 会调用这个方法
- (BOOL)isExpressAd {
    // 自渲染广告返回 NO，模板广告返回 YES
    return NO;
}

// TopOn SDK 会从这些方法获取数据，而不是直接访问属性
- (NSString *)title {
    NSString *result = self.nativeAd.title ?: @"";
    NSLog(@"AlxTopOnNativeObject: title = %@", result);
    return result;
}

- (NSString *)mainText {
    NSString *result = self.nativeAd.desc ?: @"";
    NSLog(@"AlxTopOnNativeObject: mainText = %@", result);
    return result;
}

- (NSString *)iconUrl {
    NSString *result = self.nativeAd.icon.url ?: @"";
    NSLog(@"AlxTopOnNativeObject: iconUrl = %@", result);
    return result;
}

- (NSString *)mainImageUrl {
    NSString *result = @"";
    if (self.nativeAd.images.count > 0) {
        result = self.nativeAd.images.firstObject.url ?: @"";
    }
    NSLog(@"AlxTopOnNativeObject: mainImageUrl = %@", result);
    return result;
}

- (NSString *)ctaText {
    NSString *result = self.nativeAd.callToAction ?: @"";
    NSLog(@"AlxTopOnNativeObject: ctaText = %@", result);
    return result;
}

- (NSString *)advertiser {
    NSString *result = self.nativeAd.adSource ?: @"";
    NSLog(@"AlxTopOnNativeObject: advertiser = %@", result);
    return result;
}

- (UIImage *)logoImage {
    UIImage *result = self.nativeAd.adLogo;
    NSLog(@"AlxTopOnNativeObject: logoImage = %@", result ? @"exists" : @"nil");
    return result;
}

- (BOOL)isVideoContents {
    BOOL result = self.nativeAd.createType == 1;
    NSLog(@"AlxTopOnNativeObject: isVideoContents = %@", result ? @"YES" : @"NO");
    return result;
}

- (UIView *)mediaView {
    NSLog(@"AlxTopOnNativeObject: mediaView requested");
    
    // 如果已经创建过，直接返回缓存的实例，避免 TopOn 多次调用时返回不同对象
    if (self.cachedMediaView) {
        NSLog(@"AlxTopOnNativeObject: returning cached mediaView");
        return self.cachedMediaView;
    }
    
    // 否则创建新的 mediaView 并缓存
    if (self.nativeAd.mediaContent) {
        NSLog(@"AlxTopOnNativeObject: creating mediaView");
        AlxMediaView *mediaView = [[AlxMediaView alloc] init];
        [mediaView setMediaContent:self.nativeAd.mediaContent];
        self.cachedMediaView = mediaView;
        return mediaView;
    }
    
    NSLog(@"AlxTopOnNativeObject: no mediaContent");
    return nil;
}

- (CGFloat)mainImageWidth {
    CGFloat result = 0;
    if (self.nativeAd.images.count > 0) {
        result = self.nativeAd.images.firstObject.width;
    }
    NSLog(@"AlxTopOnNativeObject: mainImageWidth = %f", result);
    return result;
}

- (CGFloat)mainImageHeight {
    CGFloat result = 0;
    if (self.nativeAd.images.count > 0) {
        result = self.nativeAd.images.firstObject.height;
    }
    NSLog(@"AlxTopOnNativeObject: mainImageHeight = %f", result);
    return result;
}

#pragma mark - ATCustomNetworkNativeAd Required Methods

- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews
                  withContainer:(UIView *)container
               registerArgument:(ATNativeRegisterArgument *)registerArgument {
    NSLog(@"AlxTopOnNativeObject: registerClickableViews");
    
    if (!self.nativeAd) {
        NSLog(@"AlxTopOnNativeObject: nativeAd is nil, cannot register");
        return;
    }
    
    if (container) {
        // ⚠️ 从 registerArgument 获取 viewController
        if (registerArgument.viewController) {
            self.nativeAd.rootViewController = registerArgument.viewController;
        }
        
        [self.nativeAd registerViewWithContainer:container
                                  clickableViews:clickableViews ?: @[container]];
    }
}

- (void)dealloc {
    NSLog(@"AlxTopOnNativeObject: dealloc");
    [self.nativeAd unregisterView];
    self.cachedMediaView = nil;
}

@end
