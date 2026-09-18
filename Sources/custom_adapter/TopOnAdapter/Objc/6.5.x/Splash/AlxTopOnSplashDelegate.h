//
//  AlxTopOnSplashDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxToponAdapterCommonHeader.h"
#import <AlxAds/AlxAds-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnSplashDelegate : NSObject <AlxSplashAdDelegate>

@property (nonatomic, strong, nullable) ATSplashAdStatusBridge *adStatusBridge;
@property (nonatomic, weak, nullable) AlxSplashAd *splashAd;

@end

NS_ASSUME_NONNULL_END
