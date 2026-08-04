#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import <AlxAds/AlxAds-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxBannerXibVC : BaseUIViewController <AlxBannerViewAdDelegate>

@property (weak, nonatomic) IBOutlet UIButton *bnLoadAndShow;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet AlxBannerAdView *bannerView;

@end

NS_ASSUME_NONNULL_END
