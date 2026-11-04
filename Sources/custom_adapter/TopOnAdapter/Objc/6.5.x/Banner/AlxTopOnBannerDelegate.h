//
//  AlxTopOnBannerDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnBannerDelegate : NSObject <AlxBannerViewAdDelegate>

@property (nonatomic, strong) ATBannerAdStatusBridge *adStatusBridge;
@property (nonatomic, copy, nullable) BOOL (^onAdLoaded)(id<AlxAdDelegate> ad);

@end

NS_ASSUME_NONNULL_END
