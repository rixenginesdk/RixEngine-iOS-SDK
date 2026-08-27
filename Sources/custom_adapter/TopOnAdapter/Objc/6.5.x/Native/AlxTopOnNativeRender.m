//
//  AlxTopOnNativeRender.m
//  AlxAdsOCDemo
//

#import "AlxTopOnNativeRender.h"
#import "AlxTopOnNativeObject.h"
#import <AlxAds/AlxAds.h>

static NSString *const TAG = @"AlxTopOnNativeRender";

@interface AlxTopOnNativeRender ()
@property (nonatomic, strong) AlxTopOnNativeObject *nativeObject;
@end

@implementation AlxTopOnNativeRender

- (instancetype)initWithConfiguraton:(ATNativeADConfiguration *)configuration adView:(ATNativeADView *)adView {
    self = [super initWithConfiguraton:configuration adView:adView];
    return self;
}

- (void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    NSLog(@"%@: renderOffer", TAG);
    
    // ⚠️ 注意：TopOn SDK 传的 customObject 就是我们的 AlxTopOnNativeObject
    // ⚠️ Note: the customObject passed by TopOn SDK is our AlxTopOnNativeObject
    if ([offer.customObject isKindOfClass:[AlxTopOnNativeObject class]]) {
        self.nativeObject = (AlxTopOnNativeObject *)offer.customObject;
        NSLog(@"%@: renderOffer: nativeObject found", TAG);
    } else {
        NSLog(@"%@: renderOffer: customObject is not AlxTopOnNativeObject", TAG);
    }
}

- (UIView *)getNetWorkMediaView {
    NSLog(@"%@: getNetWorkMediaView", TAG);
    
    if (self.nativeObject && self.nativeObject.nativeAd && self.nativeObject.nativeAd.mediaContent) {
        NSLog(@"%@: getNetWorkMediaView: creating mediaView", TAG);
        AlxMediaView *mediaView = [[AlxMediaView alloc] initWithFrame:self.configuration.mediaViewFrame];
        [mediaView setMediaContent:self.nativeObject.nativeAd.mediaContent];
        return mediaView;
    }
    
    NSLog(@"%@: getNetWorkMediaView: no media content", TAG);
    return [[UIView alloc] init];
}

- (ATNativeAdRenderType)getCurrentNativeAdRenderType {
    NSLog(@"%@: getCurrentNativeAdRenderType", TAG);
    return ATNativeAdRenderSelfRender;
}

- (void)dealloc {
    NSLog(@"%@: dealloc", TAG);
    // AlxTopOnNativeObject 的 dealloc 会自动清理
    // AlxTopOnNativeObject's dealloc will handle cleanup automatically
}

@end
