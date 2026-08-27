#import "AdmobMainVC.h"
#import "AdmobBannerVC.h"
#import "AdmobRewardVideoVC.h"
#import "AdmobInterstitialVC.h"
#import "AdmobNativeVC.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation AdmobMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"admob_ad", @"");
}

- (MenuAppearance)menuAppearance {
    return MenuAppearanceCard;
}

- (NSArray<MenuItem *> *)menuItems {
    return @[
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad", @"") makeVC:^UIViewController *{ return [[AdmobBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"rewardVideo_ad", @"") makeVC:^UIViewController *{ return [[AdmobRewardVideoVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_ad", @"") makeVC:^UIViewController *{ return [[AdmobInterstitialVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"native_ad", @"") makeVC:^UIViewController *{ return [[AdmobNativeVC alloc] init]; }]
    ];
}

- (NSString *)menuSubtitleAtIndex:(NSInteger)index {
    NSArray *subtitles = @[
        @"Flexible formats at the top, middle or bottom of your app.",
        @"Users engage with a video ad in exchange for in-app rewards.",
        @"Full-screen ads at natural breaks or transition points.",
        @"Ads that match the look and feel of your app."
    ];
    if (index >= 0 && index < subtitles.count) {
        return subtitles[index];
    }
    return nil;
}

- (void)setupSDK {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *status) {
        NSDictionary *statuses = [status adapterStatusesByClassName];
        for (NSString *key in statuses) {
            GADAdapterStatus *adapterStatus = statuses[key];
            NSLog(@"Adapter Name: %@, Description: %@, Latency: %f",
                  key, adapterStatus.description, adapterStatus.latency);
        }
    }];
}

@end
