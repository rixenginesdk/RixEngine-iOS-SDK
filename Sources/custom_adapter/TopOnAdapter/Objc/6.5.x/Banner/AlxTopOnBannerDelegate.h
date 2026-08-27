//
//  AlxTopOnBannerDelegate.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import "AlxTopOnAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnBannerDelegate : NSObject <AlxBannerViewAdDelegate>

@property (nonatomic, strong) ATBannerAdStatusBridge *adStatusBridge;

@end

NS_ASSUME_NONNULL_END
